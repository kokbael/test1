import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:test1/layout/ydDday.dart';
import 'package:test1/layout/ydReadPage.dart';
import 'package:test1/yd_dbManager.dart' as firebase;
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
    '경남',
    '기타 지역',
  ];
  String _selectedSearchData = '모든 지역';
  String? _sortField;

  DropdownButton _dropdownButton() {
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
          if (value == '경남') {
            _selectedSearchData = '경남';
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

  var _docs;
  Future<List> _firstCourtList() async {
    List list = [];
    var ref = FirebaseFirestore.instance.collection('ydcourt').orderBy(
        _sortField!,
        descending: _sortField == 'postDate' ? true : false);
    await ref.get().then((QuerySnapshot querySnapshot) =>
        {for (var doc in querySnapshot.docs) list.add(doc.data())});
    return list;
  }

  Future<List> _changeCourtList(docs) async {
    firebase.updateDday(docs);
    List tempList = [];
    if (_selectedSearchData == '모든 지역') {
      tempList = await _firstCourtList();
    } else {
      for (var doc in docs) {
        if (doc['town'] == _selectedSearchData) {
          tempList.add(doc);
        }
      }
    }
    return tempList;
  }

  void _onRefresh(docs) async {
    setState(() {
      //StreamBuilder 가 새로 listen 할 수 있도록 sortField 를 setState 함.
      _sortField = _sortField;
    });
    await Future.delayed(Duration(milliseconds: 500));
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
    return FutureBuilder(
        future: _firstCourtList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            _docs = snapshot.data!;
            return Scaffold(
              body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _dropdownButton(),
                            SizedBox(
                              width: 15,
                            ),
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
                          child: StreamBuilder(
                            stream: Stream.fromFuture(_changeCourtList(_docs)),
                            builder: ((BuildContext context,
                                AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                _docs = snapshot.data!;
                                return SmartRefresher(
                                    controller: _refreshController,
                                    enablePullDown: true,
                                    enablePullUp: false,
                                    onRefresh: () => _onRefresh(_docs),
                                    header: MaterialClassicHeader(
                                        color: Colors.deepPurple.shade300),
                                    child: ListView.builder(
                                      itemCount: _docs.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        YDReadPage(
                                                          index: index,
                                                          docs: _docs,
                                                          sortField: _sortField,
                                                          selectedSearchData:
                                                              _selectedSearchData,
                                                        )));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            // margin:
                                            //     EdgeInsets.fromLTRB(0, 3, 0, 3),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 1.0,
                                                    color:
                                                        Colors.grey.shade300),
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
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.network(
                                                          _docs[index]
                                                              ['photoURL'],
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _docs[index]
                                                              ['courtName'],
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                        Text(
                                                          _docs[index]['title'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          '양도일자 : ' +
                                                              timestamp2String(
                                                                  _docs[index]
                                                                      ['date']),
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                        child: YDDday(
                                                            docs: _docs,
                                                            index: index)),
                                                  ],
                                                ),
                                                // SizedBox(
                                                //   height: 8,
                                                // ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ));
                              }
                            }),
                          ),
                        ),
                      ),
                    ]),
              ),
            );
          }
        });
  }
}
