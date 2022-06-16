import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test1/layout/noyd/authentication.dart';
import 'package:test1/layout/myAppBar.dart';
import 'package:test1/layout/myBottomNavigator.dart';
import 'package:test1/layout/myDialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test1/layout/noyd/userInfo.dart';
import 'package:test1/layout/sliverLayout.dart';
import 'package:test1/layout/video/camera.dart';
import 'package:test1/layout/ydCreate.dart';
import 'package:test1/layout/ydList.dart';
import 'package:test1/layout/video/videoExam.dart';
import 'firebase_options.dart';
import 'layout/sliverLayout.dart';
import 'layout/ydCourtList.dart';
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
    String? url;
    try {
      final refImage =
          FirebaseStorage.instance.ref().child('court_image/$townData/$png');
      url = await refImage.getDownloadURL();
      return url;
    } catch (_) {
      return ''; // [이미지 없음] URL
    }
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraPage()));
                      },
                      child: Text('video'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VideoExamMain()));
                      },
                      child: Text('videoExam'),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          // print(await _courtPhotoURL('test', 'busan'));
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
                              CupertinoPageRoute(
                                  builder: (context) => SliverLayout(
                                        photoURLList: const [
                                          'https://firebasestorage.googleapis.com/v0/b/test1-f35fc.appspot.com/o/court_image%2Fkyungki%2F%EA%B3%A4%EC%A7%80%EC%95%94%EC%83%9D%ED%99%9C%EC%B2%B4%EC%9C%A1%EA%B3%B5%EC%9B%90%ED%85%8C%EB%8B%88%EC%8A%A4%EC%9E%A5.png?alt=media&token=aa659800-cc38-47a8-81a9-1180351142dd',
                                          'https://firebasestorage.googleapis.com/v0/b/test1-f35fc.appspot.com/o/yd_user_made%2Ff9ipNzncgvQFoGrw9HW9yrAlrRu22022-05-09%2010%3A04%3A14.206528.png?alt=media&token=523dd4dd-dba8-4fea-8407-f3903f1dee09',
                                          'https://firebasestorage.googleapis.com/v0/b/test1-f35fc.appspot.com/o/court_image%2Fincheon%2F%EC%97%B4%EC%9A%B0%EB%AC%BC%ED%85%8C%EB%8B%88%EC%8A%A4%EC%9E%A5.png?alt=media&token=be5a8b4c-b7f8-4fbb-8db6-659c9b66ad93',
                                          'https://firebasestorage.googleapis.com/v0/b/test1-f35fc.appspot.com/o/court_image%2Fbusan%2F%EA%B0%95%EC%84%9C%EC%B2%B4%EC%9C%A1%EA%B3%B5%EC%9B%90.png?alt=media&token=96420e62-ca89-4712-874b-153d7f7a38ce',
                                          'https://firebasestorage.googleapis.com/v0/b/test1-f35fc.appspot.com/o/court_image%2Fseoul%2F%EC%96%91%EC%9E%AC%EC%8B%9C%EB%AF%BC%EC%9D%98%EC%88%B2%ED%85%8C%EB%8B%88%EC%8A%A4%EC%9E%A5.png?alt=media&token=14d9bb17-e9d4-47bc-9042-fa4806f2bdd8',
                                          'https://firebasestorage.googleapis.com/v0/b/test1-f35fc.appspot.com/o/court_image%2Fseoul%2F%EC%96%91%EC%9E%AC%EC%8B%9C%EB%AF%BC%EC%9D%98%EC%88%B2%ED%85%8C%EB%8B%88%EC%8A%A4%EC%9E%A5.png?alt=media&token=14d9bb17-e9d4-47bc-9042-fa4806f2bdd8',
                                        ],
                                        myTabs: const [
                                          Tab(text: 'tab1'),
                                          Tab(text: 'tab2'),
                                          Tab(text: 'tab3'),
                                        ],
                                        myTabsView: const [
                                          YDList(),
                                          YDCreate(),
                                          YDCourtList(),
                                        ],
                                        fixTabNumber: 3,
                                      )));
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
