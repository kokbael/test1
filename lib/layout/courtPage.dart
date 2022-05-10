import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:test1/layout/courtDetail.dart';
import 'package:test1/layout/renderTextFormField.dart';
import 'dropdown.dart';

class CourtPage extends StatefulWidget {
  const CourtPage({Key? key, this.setYDCourtInfo}) : super(key: key);
  final setYDCourtInfo;
  @override
  State<CourtPage> createState() => _CourtPageState();
}

class _CourtPageState extends State<CourtPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int _itemCount = 20;

  final formKey = GlobalKey<FormState>();

  List? _docs;
  void setDocs(a) {
    setState(() {
      _docs = a;
    });
  }

  String? _townData;
  void setTownData(a) {
    setState(() {
      _townData = a;
    });
  }

  final List<String> _searchList = [
    '선택',
    '코트명',
    '구/군',
  ];
  String _selectedSearchData = '선택';
  String? _searchData;
  String? _searchString;

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
                  child: _townData == null
                      ? DropDown(
                          setDocs: setDocs,
                          setTownData: setTownData,
                        )
                      : null),
              _townData == null
                  ? Text('지역을 선택하세요.')
                  : Column(children: [
                      _docs == null
                          ? CircularProgressIndicator()
                          : Scrollbar(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 2,
                                        color: Colors.deepPurple.shade400),
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
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CourtDetail(
                                                  index: index,
                                                  docs: _docs,
                                                  townData: _townData,
                                                  setYDCourtInfo:
                                                      widget.setYDCourtInfo,
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
                                                    color: Colors
                                                        .deepPurple.shade400),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      _docs![index]['city'] +
                                                          ' ',
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey),
                                                    ),
                                                    Flexible(
                                                      child: RichText(
                                                        // strutStyle: StrutStyle(
                                                        //     fontSize: 20),
                                                        overflow:
                                                            TextOverflow.fade,
                                                        maxLines: 1,
                                                        text: TextSpan(
                                                          text: _docs![index]
                                                              ['courtName'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        //style: TextStyle(fontSize: 18),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  _docs![index]['address'],
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                      Form(
                        key: formKey,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(children: [
                                DropdownButton(
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
                                      if (value != '선택') {
                                        if (value == '코트명') {
                                          _searchData = 'courtName';
                                        }
                                        if (value == '구/군') {
                                          _searchData = 'city';
                                        }
                                      }
                                    });
                                  },
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 10, 0),
                                  child: Container(
                                    width: 150,
                                    child: renderTextFormField(
                                      minLines: 1,
                                      label: '',
                                      onSaved: (val) {
                                        setState(() {
                                          _searchString = val;
                                        });
                                      },
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return '';
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                _searchData == null
                                    ? ElevatedButton(
                                        onPressed: () {},
                                        child: Text('검색'),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.grey),
                                      )
                                    : ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            if (formKey.currentState!
                                                .validate()) {
                                              formKey.currentState!.save();
                                            }
                                          });
                                          List? flag = await searchQuery(
                                              _searchData!,
                                              _searchString!,
                                              _townData!);
                                          setState(() {
                                            _docs = flag;
                                            _itemCount = flag!.length;
                                          });
                                        },
                                        child: Text('검색'),
                                      ),
                              ]),
                            ]),
                      ),
                    ]),
            ],
          ),
        ),
      ),
    );
  }

  Future<List?> searchQuery(
      String searchData, String searchString, String selectedTown) async {
    List resultList = [];
    CollectionReference court =
        FirebaseFirestore.instance.collection(selectedTown);
    await court
        .orderBy(searchData)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              for (var doc in querySnapshot.docs)
                if (doc.get(searchData).contains(searchString))
                  resultList.add(doc.data())
            });
    return resultList;
  }

  void _onLoading() async {
    int _ydCount = _docs!.length;
    int _pageCount = 20;
    await Future.delayed(Duration(milliseconds: 500));
    print(_ydCount);
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
      setState(() {});
      _refreshController.refreshCompleted();
      _refreshController.loadNoData();
    }
  }
}
