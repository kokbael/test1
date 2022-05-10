import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';
import 'package:test1/layout/ydmap.dart';

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
  String? _photoURL;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.docs[widget.index]['courtName'])),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              FutureBuilder(
                  future: courtPhotoURL(
                      widget.docs[widget.index]['courtName'], widget.townData),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) _photoURL = snapshot.data;
                    return !snapshot.hasData
                        ? Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.black,
                            )),
                            width: double.infinity,
                            height: 200,
                            child: Center(child: CircularProgressIndicator()))
                        : Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.white,
                            )),
                            width: double.infinity,
                            height: 200,
                            child: Image.network(
                              snapshot.data,
                              fit: BoxFit.fill,
                            ));
                  }),
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
                      onLinkTap: (url) =>
                          widget.docs[widget.index]['reservation']),
                ],
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
              ElevatedButton(
                onPressed: () {
                  // String? _courtName;
                  // String? _address;
                  // String? _photoURL;
                  List<String> _courtInfo = [
                    widget.docs[widget.index]['courtName'],
                    widget.docs[widget.index]['address'],
                    _photoURL!,
                  ];
                  widget.setYDCourtInfo(_courtInfo);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('선택'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> courtPhotoURL(String imageName, String townData) async {
  String png = imageName + '.png';
  final refImage =
      FirebaseStorage.instance.ref().child('court_image/$townData/$png');
  String url = await refImage.getDownloadURL();
  return url;
  // print(url);
}
