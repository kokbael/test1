import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:test1/layout/authentication.dart';
import 'package:test1/layout/boardCreate.dart';
import 'package:test1/layout/boardList.dart';
import 'package:test1/layout/myAppBar.dart';
import 'package:test1/layout/myBottomNavigator.dart';
import 'package:test1/layout/myDialog.dart';
import 'package:test1/layout/courtPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test1/layout/userInfo.dart';
import 'package:test1/layout/ydCreate.dart';
import 'package:test1/layout/ydList.dart';
import 'firebase_options.dart';
import 'style.dart' as style;
import 'package:test1/jsonToCourtList.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
      theme: style.theme,
      debugShowCheckedModeBanner: false,
      home: Authentication()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //JSON 파싱
  //https://oowgnoj.dev/post/flutter-json
  //https://flutter-ko.dev/docs/development/data-and-backend/json

  Future<String> _loadCourtAsset() async {
    return await rootBundle.loadString('assets/busan.json');
  }

  void _addCourt() async {
    var ref = FirebaseFirestore.instance.collection('busan');
    String jsonString = await _loadCourtAsset();
    final jsonResponse = json.decode(jsonString);
    CourtList courtsList = CourtList.fromJson(jsonResponse);
    for (var list in courtsList.courts!) {
      ref.doc(list.courtName).set({
        // if( data != null )
        'city': list.city,
        'courtName': list.courtName,
        'courtEA': list.courtEA,
        'contact': list.contact,
        'chargeInfo': list.chargeInfo,
        'reservation': list.reservation,
        'address': list.address,
      });
    }
  }
  // void _addCourt() async {
  //   var ref = FirebaseFirestore.instance.collection('court');
  //   String jsonString = await _loadCourtAsset();
  //   final jsonResponse = json.decode(jsonString);
  //   CourtList courtsList = CourtList.fromJson(jsonResponse);
  //   for (var list in courtsList.courts!) {
  //     ref.doc('busan').collection(list.courtName).doc('Info').set({
  //       // if( data != null )
  //       'city': list.city,
  //       'courtName': list.courtName,
  //       'courtEA': list.courtEA,
  //       'contact': list.contact,
  //       'chargeInfo': list.chargeInfo,
  //       'reservation': list.reservation,
  //       'address': list.address,
  //     });
  //   }
  // }

  //File
  //https://flutter-ko.dev/docs/cookbook/persistence/reading-writing-files
  //https://pub.dev/packages/path_provider

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    final File file = File('${directory.path}/busan.txt');
    await file.writeAsString(text);
  }

  Future<List?> _read() async {
    List? text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/busan.txt');
      return text;
    } catch (e) {
      print(e);
      return [];
    }
  }
  //File

  //SharedPreferences
  //https://pub.dev/packages/shared_preferences
  //https://flutter-ko.dev/docs/cookbook/persistence/key-value
  //시작할 때 counter 값을 불러옵니다.
  int _counter = 0;
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0);
    });
  }

  //클릭하면 counter 를 증가시킵니다.
  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter);
    });
  }

  //SharedPreferences

  var tab = 0;
  void setTab(a) {
    setState(() {
      tab = a;
    });
  }

  String? userName;
  String? userImage;
  void setUser() {
    setState(() {
      userName = FirebaseAuth.instance.currentUser!.displayName;
      userImage = FirebaseAuth.instance.currentUser!.photoURL;
    });
  }

  @override
  void initState() {
    super.initState();
    setUser();
    _loadCounter();
  }

  void setDB() async {
    var citiesRef = FirebaseFirestore.instance.collection('cities');
    await citiesRef.doc('SF').set({
      'name': 'San Francisco',
      'state': 'CA',
      'country': 'USA',
      'capital': false,
      'population': 860000,
      'regions': ['west_coast', 'norcal']
    });
    await citiesRef.doc('LA').set({
      'name': 'Los Angeles',
      'state': 'CA',
      'country': 'USA',
      'capital': false,
      'population': 3900000,
      'regions': ['west_coast', 'socal']
    });
    await citiesRef.doc('DC').set({
      'name': 'Washington, D.C.',
      'state': null,
      'country': 'USA',
      'capital': true,
      'population': 680000,
      'regions': ['east_coast']
    });
    await citiesRef.doc('TOK').set({
      'name': 'Tokyo',
      'state': null,
      'country': 'Japan',
      'capital': true,
      'population': 9000000,
      'regions': ['kanto', 'honshu']
    });
    await citiesRef.doc('BJ').set({
      'name': 'Beijing',
      'state': null,
      'country': 'China',
      'capital': true,
      'population': 21500000,
      'regions': ['jingjinji', 'hebei']
    });
    await citiesRef.doc('SSN').set({
      'name': 'Seoul',
      'state': null,
      'country': 'Korea',
      'capital': true,
      'population': 980000,
      'regions': ['asia-northeast3']
    });
    await citiesRef.doc('PSN').set({
      'name': 'Pusan',
      'state': null,
      'country': 'Korea',
      'capital': false,
      'population': 350000,
      'regions': ['asia-northeast3']
    });
  }

  postQuery() async {
    var postRef = FirebaseFirestore.instance.collection('post');

    var query = await postRef.get().then((QuerySnapshot querySnapshot) => {
          for (var doc in querySnapshot.docs)
            print(doc.id + ' => ' + doc.data().toString())
        });
  }

  citiesQuery() async {
    var citiesRef = FirebaseFirestore.instance.collection("cities");

    var query = await citiesRef.get().then((QuerySnapshot querySnapshot) => {
          for (var doc in querySnapshot.docs)
            print(doc.id + ' => ' + doc.data().toString())
        });
    print('1-----------------------------------------------------');
    var query1 = await citiesRef
        .where('country', whereIn: ['USA'])
        .where('capital', isEqualTo: false)
        .where('state', isEqualTo: 'CA')
        .where('regions', arrayContains: 'socal')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              for (var doc in querySnapshot.docs)
                print(doc.id + ' => ' + doc.data().toString())
            });
    // capital 이 false 이고 인구가 1000000 초과 지역
    print('2-----------------------------------------------------');
    var query2 = await citiesRef
        .where("state", isEqualTo: 'CA')
        .where('population', isGreaterThan: 860000)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              for (var doc in querySnapshot.docs)
                print(doc.id + ' => ' + doc.data().toString())
            });
  }

  citiesUpdate(String docID, String field, updateData) {
    var doc = FirebaseFirestore.instance.collection('cities');

    doc.doc(docID).update({field: updateData});
  }

  citiesDelete(String docID) {
    var doc = FirebaseFirestore.instance.collection('cities');

    doc.doc(docID).delete();
  }

  @override
  Widget build(BuildContext context) {
    List? txt;

    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
          appBar: MyAppBar(),
          body: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => MyDialog(
                                dialogTitle: 'dialogTitle',
                                buttonText: const ['확인', '취소']));
                      },
                      child: Text("ElevatedButton - Dialog")),
                  TextButton(
                      onPressed: () async {
                        final Uri _url = Uri.parse(
                            'https://www.google.co.kr/maps/dir//대한민국+부산광역시+해운대구+송정중앙로36번길+24-24');
                        if (!await launchUrl(_url)) {
                          throw 'Could not launch $_url';
                        }
                        // setDB();
                        // postQuery();
                        // citiesQuery();
                        // citiesDelete('PSN');
                      },
                      child: Text('TextButton')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('LOGOUT '),
                      IconButton(
                        splashRadius: 15,
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Authentication()));
                        },
                        icon: Icon(Icons.logout),
                      ),
                    ],
                  ),
                  IconButton(
                    splashRadius: 15,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfoUser(
                                  uid: FirebaseAuth.instance.currentUser!.uid
                                      .toString())));
                    },
                    icon: Icon(Icons.person),
                  ),
                  //Text(userName!),
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(userImage!),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            // _write('');
                          },
                          child: Text('write')),
                      ElevatedButton(
                          onPressed: () async {
                            txt = await _read();
                            print(txt);
                          },
                          child: Text('Read')),
                      //Text('file' + txt!),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            print(prefs.get('counter'));
                            await prefs.remove('counter');
                            setState(() {
                              _counter = (prefs.getInt('counter') ?? 0);
                            });
                            print(_counter);
                          },
                          child: Text('remove')),
                      ElevatedButton(
                          onPressed: _incrementCounter,
                          child: Text('incrementCounter')),
                    ],
                  ),
                  Text('$_counter'),
                  ElevatedButton(
                      onPressed: () {
                        _addCourt();
                      },
                      child: Text('add')),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BoardCreate()));
                        },
                        child: Text('BoardCreate'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BoardList()));
                        },
                        child: Text('BoardList'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // BoardCreate(
            //   userName: userName,
            //   userImage: userImage,
            //   setMainTab: setTab,
            // ),
            YDCreate(setTab: setTab),
            YDList(),
            CourtPage(),
          ][tab],
          bottomNavigationBar:
              MyBottomNavigationBar(setMainTab: setTab, mainTab: tab)),
    );
  }
}
