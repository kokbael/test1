import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../myDialog.dart';

class BoardPopButton extends StatefulWidget {
  const BoardPopButton(
      {Key? key, this.index, this.docs, this.uid, this.setListTab})
      : super(key: key);
  final index;
  final docs;
  final setListTab;
  final uid;

  @override
  State<BoardPopButton> createState() => _BoardPopButtonState();
}

class _BoardPopButtonState extends State<BoardPopButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text("수정"),
          value: 'Update',
        ),
        PopupMenuItem(
          child: Text("삭제"),
          value: 'Delete',
        )
      ],
      onSelected: (value) {
        if (value == 'Update') {
          if (widget.docs[widget.index]['uid'] ==
              FirebaseAuth.instance.currentUser!.uid) {
            // PopButton 보이기/안보이기로 수정
            setState(() {
              widget.setListTab(1); // boardReadPage.dart
            });
          } else {
            showDialog(
                context: context,
                builder: (context) => MyDialog(
                    dialogTitle: '내 게시글만 수정 가능합니다.', buttonText: const ['확인']));
          }
        }
        if (value == 'Delete') {
          // DB delete
          if (widget.docs[widget.index]['uid'] == widget.uid) {
            showDialog(
                context: context,
                builder: (context) => MyDialog(
                      dialogTitle: '게시물을 삭제하시겠습니까?',
                      buttonText: const ['취소', '삭제'],
                      docs: widget.docs,
                      index: widget.index,
                    ));
          } else {
            showDialog(
                context: context,
                builder: (context) => MyDialog(
                    dialogTitle: '내 게시글만 삭제 가능합니다.', buttonText: const ['확인']));
          }
        }
      },
    );
  }
}
