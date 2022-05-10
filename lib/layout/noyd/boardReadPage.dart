import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/layout/myAppBar.dart';
import 'boardCreate.dart';
import 'boardDetail.dart';
// BoardList 에서 index 와 docs 를 받아온 후, DetailPage 를 출력한다.
// DetailPage 에서 '수정' 을 누르면 setListTab 을 1 로 전환하여
// BoardCreate (isUpdate == true) 로 이동하여 Update 기능을 수행한다.

class BoardReadPage extends StatefulWidget {
  const BoardReadPage({Key? key, this.index, this.docs}) : super(key: key);
  final index;
  final docs;
  @override
  State<BoardReadPage> createState() => _BoardReadPageState();
}

class _BoardReadPageState extends State<BoardReadPage> {
  var _listRouteTab = 0;
  _setListTab(a) {
    setState(() {
      _listRouteTab = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: [
          BoardDetail(
              docs: widget.docs,
              index: widget.index,
              uid: FirebaseAuth.instance.currentUser!.uid,
              setListTab: _setListTab // DetailPage 에서 수정을 누르면 Tab 을 1 로 전환
              ),
          BoardCreate(
              userName: FirebaseAuth.instance.currentUser!.displayName,
              userImage: FirebaseAuth.instance.currentUser!.photoURL,
              uid: FirebaseAuth.instance.currentUser!.uid,
              isUpdate: true,
              index: widget.index,
              docs: widget.docs,
              setListTab: _setListTab // 수정을 완료하면 Tab 을 0 으로 전환
              )
        ][_listRouteTab]);
  }
}
