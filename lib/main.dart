import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test1/layout/noyd/authentication.dart';
import 'package:test1/layout/myAppBar.dart';
import 'package:test1/layout/myBottomNavigator.dart';
import 'package:test1/layout/myDialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test1/layout/noyd/userInfo.dart';
import 'package:test1/layout/sliverTest.dart';
import 'package:test1/layout/ydCreate.dart';
import 'package:test1/layout/ydList.dart';
import 'firebase_options.dart';
import 'layout/sliverTest.dart';
import 'style.dart' as style;
import 'package:test1/jsonToCourtList.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Future<String> _courtPhotoURL(String imageName, String townData) async {
    String png = imageName + '.png';
    final refImage =
        FirebaseStorage.instance.ref().child('court_image/$townData/$png');
    String url = await refImage.getDownloadURL();
    return url;
    // print(url);
  }

  Future<String> _loadCourtAsset() async {
    return await rootBundle.loadString('assets/busan.json');
  }

  void _addCourt() async {
    var ref = FirebaseFirestore.instance
        .collection('court')
        .doc('busan')
        .collection('busanCourt');
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
        'photoURL': await _courtPhotoURL(list.courtName, 'busan'),
      });
    }
  }

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
    // setUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
          appBar: MyAppBar(),
          body: [
            Center(
              child: SingleChildScrollView(
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SliverTest()));
                        },
                        child: Text('TextButton')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('LOGIN '),
                        IconButton(
                          splashRadius: 15,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Authentication()));
                          },
                          icon: Icon(Icons.login),
                        ),
                      ],
                    ),
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
                    ElevatedButton(
                      onPressed: () {
                        _addCourt();
                      },
                      child: Text('court add'),
                    ),
                  ],
                ),
              ),
            ),
            YDCreate(setTab: setTab),
            YDList(),
          ][tab],
          bottomNavigationBar:
              MyBottomNavigationBar(setMainTab: setTab, mainTab: tab)),
    );
  }
}
