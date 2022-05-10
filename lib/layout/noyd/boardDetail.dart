import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'boardPopButton.dart';
import 'package:intl/intl.dart';

class BoardDetail extends StatefulWidget {
  const BoardDetail({
    Key? key,
    this.docs,
    this.index,
    this.uid,
    this.setListTab,
  }) : super(key: key);
  final docs;
  final index;
  final setListTab;
  final uid;

  @override
  State<BoardDetail> createState() => _BoardDetailState();
}

String timestamp2String(Timestamp timestamp) {
  DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
  return formatter.format(timestamp.toDate());
}

class _BoardDetailState extends State<BoardDetail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(18.0),
          child: Row(
            children: [
              Flexible(
                flex: 9,
                child: Row(
                  children: [
                    Text(widget.docs[widget.index]['title'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25)),
                  ],
                ),
              ),
              Row(
                children: [
                  BoardPopButton(
                    index: widget.index,
                    docs: widget.docs,
                    uid: widget.uid,
                    setListTab: widget.setListTab,
                  )
                ],
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 15, 12),
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 0.2, color: Colors.grey))),
          child: Row(
            children: [
              // Icon(Icons.account_circle),
              SizedBox(
                height: 20,
                width: 20,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.docs[widget.index]['userImage'],
                  ),
                ),
              ),
              Text('  '),
              Text(widget.docs[widget.index]['userName']),
              Text('  |  ', style: TextStyle(color: Colors.grey)),
              Text(
                timestamp2String(widget.docs[widget.index]['date']),
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
        Container(
          width: 400,
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: RichText(
                  strutStyle: StrutStyle(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 15,
                  text: TextSpan(
                    text: widget.docs[widget.index]['contents'],
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  //style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
