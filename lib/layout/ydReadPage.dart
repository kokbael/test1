import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/layout/ydDetail.dart';
import 'package:test1/layout/ydUpdate.dart';
import 'myAppBar.dart';

// Update 시 Navigator Push 없이 수행하기 위한 페이지
class YDReadPage extends StatefulWidget {
  const YDReadPage(
      {Key? key,
      this.index,
      this.docs,
      this.sortField,
      this.selectedSearchData})
      : super(key: key);
  final index;
  final docs;
  final sortField;
  final selectedSearchData;
  @override
  State<YDReadPage> createState() => _YDReadPageState();
}

class _YDReadPageState extends State<YDReadPage> {
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
          YDDetail(
            docs: widget.docs,
            index: widget.index,
            sortField: widget.sortField,
            uid: FirebaseAuth.instance.currentUser!.uid,
            selectedSearchData: widget.selectedSearchData,
            setListTab: _setListTab, // DetailPage 에서 수정을 누르면 Tab 을 1 로 전환
          ),
          YDUpdate(
            userName: FirebaseAuth.instance.currentUser!.displayName,
            userImage: FirebaseAuth.instance.currentUser!.photoURL,
            uid: FirebaseAuth.instance.currentUser!.uid,
            index: widget.index,
            docs: widget.docs,
            setListTab: _setListTab,
            //setListTab: _setListTab // 수정을 완료하면 Tab 을 0 으로 전환
          )
        ][_listRouteTab]);
  }
}
