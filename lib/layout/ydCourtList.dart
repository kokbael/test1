import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/layout/ydCourtDetail.dart';
import 'package:test1/layout/renderTextFormField.dart';
import 'package:test1/layout/ydMakeCourt.dart';
import 'dropdown.dart';

class YDCourtList extends StatefulWidget {
  const YDCourtList({Key? key, this.setYDCourtInfoList}) : super(key: key);
  final setYDCourtInfoList;
  @override
  State<YDCourtList> createState() => _YDCourtListState();
}

class _YDCourtListState extends State<YDCourtList> {
  int _itemCount = 20;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final formKey = GlobalKey<FormState>();

  List? _docs;

  String? _townData = '전체';
  void setTownData(a) {
    setState(() {
      _townData = a;
    });
  }

  String? _searchString;

  List<String> _searchedList = [];
  _loadSearchedList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchedList = (prefs.getStringList('searchedList') ?? ['']);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSearchedList();
  }

  bool _isLoading = false;
  bool _isEmpty = false;

  _addSearchedList(String searchString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchedList = (prefs.getStringList('searchedList') ?? ['']);
      _searchedList.add(searchString);
      prefs.setStringList('searchedList', _searchedList);
    });
  }

  _deleteSearchedList(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchedList = (prefs.getStringList('searchedList') ?? ['']);
      _searchedList.removeAt(index);
      prefs.setStringList('searchedList', _searchedList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropDown(setTownData: setTownData),
                  Form(
                    key: formKey,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                              child: Container(
                                width: 150,
                                child: renderTextFormField(
                                  maxLines: 1,
                                  label: '',
                                  onSaved: (val) {
                                    setState(() {
                                      _searchString = val;
                                    });
                                  },
                                  // validator: (val) {
                                  //   if (val == null || val.isEmpty) {
                                  //     return '';
                                  //   }
                                  // },
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                setState(() {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                  }
                                });
                                List? flag = searchQuery(
                                  _searchString!,
                                  await courtList(_townData!),
                                );

                                setState(() {
                                  if (flag!.isEmpty) {
                                    _isEmpty = true;
                                  }
                                  _docs = flag;
                                  _itemCount = flag.length;
                                  _isLoading = true;
                                });
                                if (_searchString != '') {
                                  _addSearchedList(_searchString!);
                                }
                              },
                              child: Text('검색'),
                            ),
                          ]),
                        ]),
                  ),
                ],
              )),
              _docs == null
                  ? _isLoading == false
                      ? Container(
                          height: 30,
                          child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: _searchedList.length,
                              itemBuilder: (BuildContext context, index) {
                                return Container(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          List? flag = searchQuery(
                                            _searchedList[_searchedList.length -
                                                1 -
                                                index],
                                            await courtList('전체'),
                                          );
                                          setState(() {
                                            if (flag!.isEmpty) {
                                              _isEmpty = true;
                                            }
                                            _docs = flag;
                                            _itemCount = flag.length;
                                          });
                                        },
                                        child: Text(
                                          _searchedList[
                                              _searchedList.length - 1 - index],
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        width: 20,
                                        child: TextButton(
                                          onPressed: () {
                                            _deleteSearchedList(
                                                _searchedList.length -
                                                    1 -
                                                    index);
                                          },
                                          child: Text(
                                            'X',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                    width: 10,
                                  )),
                        )
                      : Center(
                          child: Center(child: CircularProgressIndicator()))
                  : Column(children: [
                      Scrollbar(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 2, color: Colors.deepPurple.shade400),
                              borderRadius: BorderRadius.circular(8)),
                          margin: EdgeInsets.all(10),
                          height: 450,
                          child: SmartRefresher(
                            enablePullDown: false,
                            enablePullUp: true,
                            controller: _refreshController,
                            onLoading: _onLoading,
                            footer: ClassicFooter(
                              noDataText: "No More",
                            ),
                            child: ListView.builder(
                                key: PageStorageKey<String>(_townData!),
                                itemCount: _itemCount,
                                itemBuilder: (BuildContext context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => YDCourtDetail(
                                            index: index,
                                            docs: _docs,
                                            townData: _townData,
                                            setYDCourtInfo:
                                                widget.setYDCourtInfoList,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      // margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 1.0,
                                              color:
                                                  Colors.deepPurple.shade400),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                _docs![index]['city'] + ' ',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey),
                                              ),
                                              Flexible(
                                                child: RichText(
                                                  // strutStyle: StrutStyle(
                                                  //     fontSize: 20),
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  text: TextSpan(
                                                    text: _docs![index]
                                                        ['courtName'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  //style: TextStyle(fontSize: 18),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            _docs![index]['address'],
                                            style: TextStyle(fontSize: 13),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                      _isEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('찾으시는 코트가 없으신가요? '),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => YDMakeCourt(
                                                setYDCourtInfoList: widget
                                                    .setYDCourtInfoList)));
                                  },
                                  child: Text('코트 정보 직접 입력하기'),
                                ),
                              ],
                            )
                          : Container(),
                    ]),
            ],
          ),
        ),
      ),
    );
  }

  Future<List> courtList(String townData) async {
    List list = [];
    List _townList = ['seoul', 'kyungki', 'incheon', 'busan'];
    if (townData == '전체') {
      for (var town in _townList) {
        var ref = FirebaseFirestore.instance
            .collection('court')
            .doc(town)
            .collection(town + 'Court')
            .orderBy('courtName');
        await ref.get().then((QuerySnapshot querySnapshot) =>
            {for (var doc in querySnapshot.docs) list.add(doc.data())});
      }
      return list;
    } else {
      var ref = FirebaseFirestore.instance
          .collection('court')
          .doc(townData)
          .collection(townData + 'Court')
          .orderBy('courtName');
      await ref.get().then((QuerySnapshot querySnapshot) =>
          {for (var doc in querySnapshot.docs) list.add(doc.data())});
      return list;
    }
  }

  List? searchQuery(String searchString, List docs) {
    List resultList = [];
    for (var doc in docs) {
      if (doc['courtName'].contains(searchString)) {
        resultList.add(doc);
      }
    }
    return resultList;
  }

  void _onLoading() async {
    int _ydCount = _docs!.length;
    int _pageCount = 20;
    await Future.delayed(Duration(milliseconds: 500));
    if (_itemCount + _pageCount <= _ydCount) {
      setState(() {
        _itemCount += _pageCount;
      });
      _refreshController.loadComplete();
    } else if (_itemCount + _pageCount > _ydCount) {
      int lastNum = 0;
      for (int i = 1; i < _pageCount; i++) {
        if (_itemCount + i == _ydCount) {
          setState(() {
            lastNum = i;
            _itemCount += lastNum;
          });
        }
      }
      _refreshController.refreshCompleted();
      _refreshController.loadNoData();
    }
  }
}
