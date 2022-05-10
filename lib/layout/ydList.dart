import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:test1/layout/ydDday.dart';
import 'package:test1/layout/ydReadPage.dart';
import '../dbManager.dart' as firebase;
import 'package:intl/intl.dart';

class YDList extends StatefulWidget {
  const YDList({Key? key}) : super(key: key);

  @override
  State<YDList> createState() => _YDListState();
}

class _YDListState extends State<YDList> {
  String timestamp2String(Timestamp timestamp) {
    DateFormat formatter = DateFormat('yyyy년 MM월 dd일 HH시 mm분');
    return formatter.format(timestamp.toDate());
  }

  final List<String> _searchList = [
    '모든 지역',
    '서울',
    '경기',
    '인천',
    '부산',
    '기타 지역',
  ];
  String _selectedSearchData = '모든 지역';
  String? _sortField;

  DropdownButton dropdownButton() {
    return DropdownButton(
      value: _selectedSearchData,
      items: _searchList.map((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedSearchData = value.toString();
          if (value == '모든 지역') {
            _selectedSearchData = '모든 지역';
          }
          if (value == '서울') {
            _selectedSearchData = '서울';
          }
          if (value == '경기') {
            _selectedSearchData = '경기';
          }
          if (value == '인천') {
            _selectedSearchData = '인천';
          }
          if (value == '부산') {
            _selectedSearchData = '부산';
          }
          if (value == '기타 지역') {
            _selectedSearchData = '기타 지역';
          }
        });
      },
    );
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh(docs) async {
    await Future.delayed(Duration(milliseconds: 500));
    firebase.updateDday(docs);
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _sortField = 'postDate';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _selectedSearchData == '모든 지역'
              ? firebase.ydcourt
                  .orderBy(_sortField!,
                      descending: _sortField == 'postDate' ? true : false)
                  .snapshots()
              : firebase.ydcourt
                  .orderBy(_sortField!,
                      descending: _sortField == 'postDate' ? true : false)
                  .where('town', isEqualTo: _selectedSearchData)
                  .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              final _docs = snapshot.data!.docs;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          dropdownButton(),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (_sortField == 'postDate') {
                                    _sortField = 'Dday';
                                  } else if (_sortField == 'Dday') {
                                    _sortField = 'postDate';
                                  }
                                });
                              },
                              child: Text(_sortField! == 'postDate'
                                  ? '정렬기준 : 작성일'
                                  : '정렬기준 : 마감일')),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 9,
                      child: Container(
                        // height: 480,
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: true,
                          enablePullUp: false,
                          onRefresh: () => _onRefresh(_docs),
                          header: ClassicHeader(),
                          child: ListView.builder(
                            itemCount: _docs.length,
                            itemBuilder: (BuildContext context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => YDReadPage(
                                              index: index,
                                              docs: _docs,
                                              sortField: _sortField,
                                              selectedSearchData:
                                                  _selectedSearchData)));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  margin: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 1.0,
                                          color: Colors.deepPurple.shade400),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 70,
                                            width: 80,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                _docs[index]['photoURL'],
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _docs[index]['courtName'],
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Text(
                                                _docs[index]['title'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                '양도일자 : ' +
                                                    timestamp2String(
                                                        _docs[index]['date']),
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          Container(
                                              child: YDDday(
                                                  docs: _docs, index: index)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
