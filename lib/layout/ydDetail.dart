import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:test1/layout/ydDday.dart';
import 'package:test1/layout/ydPopButton.dart';
import 'package:test1/layout/ydTurnByTurn.dart';
import '../dbManager.dart' as firebase;
import 'ydmap.dart';

class YDDetail extends StatefulWidget {
  const YDDetail(
      {Key? key,
      this.docs,
      this.index,
      this.uid,
      this.setListTab,
      this.sortField,
      this.selectedSearchData})
      : super(key: key);
  final docs;
  final index;
  final setListTab;
  final uid;
  final sortField;
  final selectedSearchData;

  @override
  State<YDDetail> createState() => _YDDetailState();
}

String timestamp2String(Timestamp timestamp) {
  DateFormat formatter = DateFormat('yyyy년 MM월 dd일 HH시 mm분');
  return formatter.format(timestamp.toDate());
}

class _YDDetailState extends State<YDDetail> {
  final List<String> _stateList = [
    '양도 중',
    '양도완료',
  ];
  String? _selectedState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedState = widget.docs[widget.index]['confirm'] ? '양도완료' : '양도 중';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: widget.selectedSearchData == '모든 지역'
              ? firebase.ydcourt
                  .orderBy(widget.sortField!,
                      descending:
                          widget.sortField! == 'postDate' ? true : false)
                  .snapshots()
              : firebase.ydcourt
                  .orderBy(widget.sortField!,
                      descending:
                          widget.sortField! == 'postDate' ? true : false)
                  .where('town', isEqualTo: widget.selectedSearchData)
                  .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              final _docs = snapshot.data!.docs;
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 9,
                          child: Row(
                            children: [
                              YDDday(docs: _docs, index: widget.index),
                              SizedBox(width: 10),
                              Text(_docs[widget.index]['title'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            FirebaseAuth.instance.currentUser!.uid ==
                                    _docs[widget.index]['uid']
                                ? YDPopButton(
                                    index: widget.index,
                                    docs: _docs,
                                    uid: widget.uid,
                                    setListTab: widget.setListTab,
                                  )
                                : Container()
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 15, 12),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(width: 0.2, color: Colors.grey))),
                    child: Row(
                      children: [
                        // Icon(Icons.account_circle),
                        Flexible(
                          flex: 7,
                          child: Row(
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    _docs[widget.index]['userPhoto'],
                                  ),
                                ),
                              ),
                              Text('  '),
                              Text(_docs[widget.index]['userName']),
                              Text('  |  ',
                                  style: TextStyle(color: Colors.grey)),
                              Text(
                                getPostTime(_docs[widget.index]['postDate']),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Row(children: [
                          FirebaseAuth.instance.currentUser!.uid ==
                                  _docs[widget.index]['uid']
                              ? DropdownButton(
                                  value: _selectedState,
                                  items: _stateList.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value,
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value == '양도완료' &&
                                        !_docs[widget.index]['confirm']) {
                                      setState(() {
                                        _selectedState = '양도완료';
                                      });
                                      // print(_selectedState);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text('[양도완료]로 변경하였습니다.')));

                                      firebase.confirmYDCourt(
                                          _docs, widget.index);
                                    } else if (value == '양도 중' &&
                                        _docs[widget.index]['confirm']) {
                                      setState(() {
                                        _selectedState = '양도 중';
                                      });
                                      // print(_selectedState);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text('[양도 중]으로 변경하였습니다.')));
                                      firebase.confirmYDCourt(
                                          _docs, widget.index);
                                    }
                                  },
                                )
                              : Container()
                        ]),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        _docs[widget.index]['courtName'],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _docs[widget.index]['address'],
                      ),
                      Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.white,
                          )),
                          height: 280,
                          width: 400,
                          child: Image.network(
                            _docs[widget.index]['photoURL'],
                            fit: BoxFit.fill,
                          )),
                      Text(
                        timestamp2String(_docs[widget.index]['date']),
                      ),
                      Text(NumberFormat('###,###,###,###원')
                          .format(_docs[widget.index]['cost'])),
                      RichText(
                        strutStyle: StrutStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        text: TextSpan(
                          text: _docs[widget.index]['contents'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        //style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.black,
                        )),
                        width: double.infinity,
                        height: 200,
                        //
                        child: YDMap(docs: _docs, index: widget.index),
                      ),
                      YDTurnByTurn(docs: _docs, index: widget.index),
                    ],
                  ),
                ],
              );
            }
          }),
    );
  }

  String getPostTime(Timestamp postDate) {
    DateFormat _formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String _jiffyDate = _formatter.format(postDate.toDate());
    Jiffy.locale('ko');
    if (Jiffy(_jiffyDate).fromNow().contains('달') ||
        Jiffy(_jiffyDate).fromNow().contains('년')) {
      return DateFormat('yyyy-MM-dd HH:mm')
          .format(postDate.toDate()); // [n 달 전, n 년 전] 은 날짜로 표시
    } else {
      return Jiffy(_jiffyDate).fromNow(); // [몇 초 전, n분 전, n시간 전, n일 전]
    }
  }
}
