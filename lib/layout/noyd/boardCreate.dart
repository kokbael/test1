import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test1/layout/ydCourtList.dart';
import 'package:test1/layout/myDialog.dart';
import 'package:test1/layout/renderTextFormField.dart';
import 'dbManager.dart' as firebase;

class BoardCreate extends StatefulWidget {
  const BoardCreate(
      {Key? key,
      this.userName,
      this.userImage,
      this.uid,
      this.isUpdate,
      this.index,
      this.docs,
      this.setMainTab,
      this.setListTab})
      : super(key: key);
  final userName;
  final userImage;
  final uid;
  final isUpdate; // update 할 때 필요한 인자
  final index; // update 할 때 필요한 인자
  final docs; // update 할 때 필요한 인자
  final setListTab; // boardReadControl 화면 전환
  final setMainTab;
  @override
  State<BoardCreate> createState() => _BoardCreateState();
}

class _BoardCreateState extends State<BoardCreate> {
  final formKey = GlobalKey<FormState>();

  Timestamp getToday() {
    return Timestamp.now();
  }

  String timestamp2String(Timestamp timestamp) {
    DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    return formatter.format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    var _boardTitle = '';
    var _boardContents = '';

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // renderTextFormField(
                  //   minLines: 1,
                  //   label: 'Title',
                  //   onSaved: (val) {
                  //     setState(() {
                  //       _boardTitle = val;
                  //     });
                  //   },
                  //   validator: (val) {
                  //     if (val == null || val.isEmpty) {
                  //       return '제목을 입력하세요.';
                  //     }
                  //   },
                  // ),
                  // renderTextFormField(
                  //   minLines: 3,
                  //   label: 'Contents',
                  //   onSaved: (val) {
                  //     setState(() {
                  //       _boardContents = val;
                  //     });
                  //   },
                  //   validator: (val) {
                  //     if (val == null || val.isEmpty) {
                  //       return '내용을 입력하세요.';
                  //     }
                  //   },
                  // ),
                  // renderTextFormField(
                  //   minLines: 1,
                  //   label: '금액',
                  //   onSaved: (val) {
                  //     setState(() {
                  //       //_boardContents = val;
                  //     });
                  //   },
                  //   validator: (val) {
                  //     if (val == null || val.isEmpty) {
                  //       return '금액을 입력하세요.';
                  //     }
                  //   },
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('테니스장 선택  '),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => YDCourtList()));
                        },
                        child: Text('목록'),
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print(widget.isUpdate);
                        if (widget.isUpdate == true &&
                            formKey.currentState!.validate()) {
                          formKey.currentState?.save();
                          firebase.updateBoard(
                            widget.docs,
                            widget.index,
                            _boardTitle,
                            _boardContents,
                            getToday(),
                            widget.userName,
                            widget.userImage,
                          );
                          showDialog(
                              context: context,
                              builder: (context) => MyDialog(
                                  dialogTitle: '게시물을 수정하였습니다',
                                  buttonText: const ['확인']));
                          widget.setListTab(0);
                        }
                        if (widget.isUpdate == null &&
                            formKey.currentState!.validate()) {
                          formKey.currentState?.save();
                          firebase.createBoard(
                            _boardTitle,
                            _boardContents,
                            getToday(),
                            widget.userName,
                            widget.userImage,
                            FirebaseAuth.instance.currentUser!.uid,
                          );
                          showDialog(
                              context: context,
                              builder: (context) => MyDialog(
                                  dialogTitle: '게시물을 등록하였습니다',
                                  buttonText: const ['확인']));
                          setState(() {
                            widget.setMainTab(2);
                          });
                        }
                      },
                      child: Text('등록'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
