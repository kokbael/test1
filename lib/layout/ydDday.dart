import 'package:flutter/material.dart';

class YDDday extends StatefulWidget {
  const YDDday({Key? key, this.docs, this.index}) : super(key: key);
  final docs;
  final index;
  @override
  State<YDDday> createState() => _YDDdayState();
}

class _YDDdayState extends State<YDDday> {
  @override
  Widget build(BuildContext context) {
    return widget.docs[widget.index]['Dday'] > 31
        ? Container(
            width: 45,
            decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              widget.docs[widget.index]['confirm'] == false ? '마감' : '완료',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : Container(
            width: 45,
            decoration: BoxDecoration(
                color: Colors.deepPurple.shade300,
                border: Border.all(
                  width: 1,
                  color: Colors.deepPurple.shade300,
                ),
                borderRadius: BorderRadius.circular(8)),
            child:
                // getDdday(widget.docs[widget.index]['date']),
                Text(
              widget.docs[widget.index]['Dday'] == 0
                  ? 'D-day'
                  : 'D-' + widget.docs[widget.index]['Dday'].toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
  }
}
