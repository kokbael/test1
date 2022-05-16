import 'package:flutter/material.dart';
import 'myDialog.dart';

class YDPopButton extends StatefulWidget {
  const YDPopButton(
      {Key? key, this.index, this.docs, this.uid, this.setListTab})
      : super(key: key);
  final index;
  final docs;
  final setListTab;
  final uid;

  @override
  State<YDPopButton> createState() => _YDPopButtonState();
}

class _YDPopButtonState extends State<YDPopButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PopupMenuButton(
          splashRadius: 18,
          itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("수정"),
                  value: 'Update',
                ),
                PopupMenuItem(
                  child: Text("삭제"),
                  value: 'Delete',
                ),
              ],
          onSelected: (value) {
            if (value == 'Confirm') {
              // DB delete
              showDialog(
                  context: context,
                  builder: (context) => MyDialog(
                        // MyDialog 에서 delete 쿼리 수행 수정
                        dialogTitle: '완료하시겠습니까?',
                        buttonText: const ['취소', '완료'],
                        docs: widget.docs,
                        index: widget.index,
                      ));
            }
            if (value == 'Update') {
              setState(() {
                widget.setListTab(1); // boardReadPage.dart
              });
            }
            if (value == 'Delete') {
              // DB delete
              showDialog(
                  context: context,
                  builder: (context) => MyDialog(
                        // MyDialog 에서 delete 쿼리 수행 수정
                        dialogTitle: '게시물을 삭제하시겠습니까?',
                        buttonText: const ['취소', '삭제'],
                        docs: widget.docs,
                        index: widget.index,
                      ));
            }
          }),
    );
  }
}
