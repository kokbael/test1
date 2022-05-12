import 'package:flutter/material.dart';
import 'package:test1/yd_dbManager.dart' as firebase;

class MyDialog extends StatefulWidget {
  const MyDialog({
    Key? key,
    required this.dialogTitle,
    required this.buttonText, // list 형식 Ex. buttonText : ['확인' , '취소']
    this.docs,
    this.index,
  }) : super(key: key);
  final dialogTitle;
  final buttonText;
  final docs;
  final index;

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        widget.dialogTitle,
      ),
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < widget.buttonText.length; i++)
              if (widget.buttonText[i] == '삭제')
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: TextButton(
                    onPressed: () {
                      firebase.deleteYDCourt(widget.docs, widget.index);
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) => MyDialog(
                              dialogTitle: '게시물이 삭제되었습니다.',
                              buttonText: const ['확인']));
                    },
                    child: Text(
                      widget.buttonText[i],
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        widget.buttonText[i],
                        textAlign: TextAlign.center,
                      )),
                ),
          ],
        ),
      ],
    );
  }
}
