import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/layout/listData.dart';
import 'package:test1/layout/ydKakaoMap.dart';
import 'package:url_launcher/url_launcher.dart';

class YDCourtDetail extends StatefulWidget {
  const YDCourtDetail({
    Key? key,
    this.index,
    this.docs,
    this.townData,
    this.setYDCourtInfo,
  }) : super(key: key);
  final index;
  final docs;
  final setYDCourtInfo;
  final townData;
  @override
  State<YDCourtDetail> createState() => _YDCourtDetailState();
}

class _YDCourtDetailState extends State<YDCourtDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.docs[widget.index]['courtName'])),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.white,
                  )),
                  width: double.infinity,
                  height: 200,
                  child: Image.network(
                    widget.docs[widget.index]['photoURL'],
                    fit: BoxFit.fill,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.docs[widget.index]['address'],
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    '면수 :  : ' +
                        widget.docs[widget.index]['courtEA'].toString(),
                  ),
                  Text(
                    '이용 요금 : ' + widget.docs[widget.index]['chargeInfo'],
                  ),
                  Text(
                    '연락처 : ' + widget.docs[widget.index]['contact'],
                  ),
                  Text('예약정보'),
                  //https://pub.dev/packages/link_text
                  //https://pub.dev/packages/flutter_html#onlinktap
                  LinkText(widget.docs[widget.index]['reservation'],
                      onLinkTap: (url) => launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication)),
                ],
              ),
              YDKakaoMap(docs: widget.docs, index: widget.index),
              ElevatedButton(
                onPressed: () async {
                  List<String> _courtInfo = [
                    widget.docs[widget.index]['courtName'],
                    widget.docs[widget.index]['address'],
                    widget.docs[widget.index]['photoURL'],
                  ];
                  widget.setYDCourtInfo(_courtInfo);

                  ListData _listData = ListData(
                    courtName: widget.docs[widget.index]['courtName'],
                    address: widget.docs[widget.index]['address'],
                    photoURL: widget.docs[widget.index]['photoURL'],
                  );
                  _saveListData(_listData.toString());
                  Navigator.pop(context);
                  Navigator.pop(context);
                  // pop(1) -> 코트 리스트 페이지
                  // pop(2) -> 작성 페이지
                },
                child: Text('선택'),
              ),
            ],
          ),
        ),
      ),
    );
    // ,
    // ),
    // );
  }

  Future<void> _saveListData(String splitString) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> _selectedCourtList = prefs.getStringList('SelectCourt') ?? [];
    _selectedCourtList.add(splitString);
    prefs.setStringList('SelectCourt', _selectedCourtList);
  }
}
