import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:test1/layout/ydPopButton.dart';
import 'package:test1/layout/ydTurnByTurn.dart';
import 'ydmap.dart';
import 'package:test1/yd_dbManager.dart' as firebase;

class YDDetail extends StatefulWidget {
  const YDDetail({
    Key? key,
    this.docs,
    this.index,
    this.uid,
    this.setListTab,
    this.sortField,
    this.selectedSearchData,
  }) : super(key: key);
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
  bool? _isConfirm;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedState = widget.docs[widget.index]['confirm'] ? '양도완료' : '양도 중';
    _isConfirm = widget.docs[widget.index]['confirm'] ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 9,
                      child: Row(
                        children: [
                          readPageDday(widget.docs[widget.index]['date']),
                          // YDDday(docs: widget.docs, index: widget.index),
                          SizedBox(width: 10),
                          Text(widget.docs[widget.index]['title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        FirebaseAuth.instance.currentUser!.uid ==
                                widget.docs[widget.index]['uid']
                            ? YDPopButton(
                                index: widget.index,
                                docs: widget.docs,
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
                        bottom: BorderSide(width: 0.2, color: Colors.grey))),
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
                                widget.docs[widget.index]['userPhoto'],
                              ),
                            ),
                          ),
                          Text('  '),
                          Text(widget.docs[widget.index]['userName']),
                          Text('  |  ', style: TextStyle(color: Colors.grey)),
                          Text(
                            getPostTime(widget.docs[widget.index]['postDate']),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Row(children: [
                      FirebaseAuth.instance.currentUser!.uid ==
                              widget.docs[widget.index]['uid']
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
                                if (value == '양도완료') {
                                  setState(() {
                                    _selectedState = '양도완료';
                                    _isConfirm = true;
                                  });
                                  try {
                                    FirebaseFirestore.instance
                                        .collection('ydcourt')
                                        .doc(widget.docs[widget.index]['id'])
                                        .update({'confirm': _isConfirm});
                                  } catch (e) {
                                    print(e);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('변경에 실패하였습니다.')));
                                  }
                                } else if (value == '양도 중') {
                                  setState(() {
                                    _selectedState = '양도 중';
                                    _isConfirm = false;
                                  });
                                  try {
                                    FirebaseFirestore.instance
                                        .collection('ydcourt')
                                        .doc(widget.docs[widget.index]['id'])
                                        .update({'confirm': _isConfirm});
                                  } catch (e) {
                                    print(e);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('변경에 실패하였습니다.')));
                                  }
                                }
                              },
                            )
                          : Container()
                    ]),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                widget.docs[widget.index]['courtName'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.docs[widget.index]['address'],
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
                    widget.docs[widget.index]['photoURL'],
                    fit: BoxFit.fill,
                  )),
              Text(
                timestamp2String(widget.docs[widget.index]['date']),
              ),
              Text(NumberFormat('###,###,###,###원')
                  .format(widget.docs[widget.index]['cost'])),
              RichText(
                strutStyle: StrutStyle(fontSize: 20),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                text: TextSpan(
                  text: widget.docs[widget.index]['contents'],
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
                child: YDMap(docs: widget.docs, index: widget.index),
              ),
              YDTurnByTurn(docs: widget.docs, index: widget.index),
              ElevatedButton(
                  onPressed: () {
                    print(firebase.setDday(widget.docs[widget.index]['date']));
                  },
                  child: Text('diff')),
            ],
          ),
        ],
      ),
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

  // Detail 내에서 동작하기 위해 작성
  Widget readPageDday(Timestamp date) {
    String eightDate = DateFormat('yyyyMMdd').format(date.toDate());
    int days = DateTime.now().difference(DateTime.parse(eightDate)).inDays;
    int hours = DateTime.now().difference(DateTime.parse(eightDate)).inHours;
    if (_isConfirm == true) {
      return renderDday(Dday: 33, color: Colors.grey, confirm: true);
    } else if (days == 0 && hours >= 0) {
      String dateHH = DateFormat('HH').format(date.toDate());
      String nowHH = DateFormat('HH').format(DateTime.now());
      int diffHH = int.parse(dateHH) - int.parse(nowHH);
      if (diffHH > 0) {
        // D-day
        return renderDday(
            Dday: 0, color: Colors.deepPurple.shade400, confirm: false);
      } else {
        // D-day 에서 시간 지난 마감
        return renderDday(Dday: 32, color: Colors.grey, confirm: false);
      }
    } else if (days > 0) {
      // Day 넘어 간 마감
      return renderDday(Dday: 32, color: Colors.grey, confirm: false);
    } else {
      // D-n
      return renderDday(
          Dday: (-hours / 24).ceil(),
          color: Colors.deepPurple.shade400,
          confirm: false);
    }
  }

  Widget renderDday(
      {@required int? Dday, @required Color? color, @required bool? confirm}) {
    assert(Dday != null);
    assert(color != null);
    assert(confirm != null);
    return Container(
      width: 45,
      decoration: BoxDecoration(
          color: color!,
          border: Border.all(
            width: 1,
            color: color,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        confirm == true
            ? '완료'
            : Dday == 32
                ? '마감'
                : Dday == 0
                    ? 'D-day'
                    : 'D-' + Dday!.toString(),
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
