import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/layout/ydMakeCourt.dart';
import 'package:test1/layout/renderTextFormField.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:test1/yd_dbManager.dart' as firebase;
import 'ydCourtList.dart';
import 'myDialog.dart';

class YDUpdate extends StatefulWidget {
  const YDUpdate(
      {Key? key,
      this.index,
      this.docs,
      this.uid,
      this.userImage,
      this.userName,
      this.setListTab
      //this.setListTab,
      })
      : super(key: key);
  final userName;
  final userImage;
  final uid;
  final index;
  final docs;
  final setListTab;
  //final setListTab;

  @override
  State<YDUpdate> createState() => _YDUpdateState();
}

class _YDUpdateState extends State<YDUpdate> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _contentsFocus = FocusNode();
  final FocusNode _costFocus = FocusNode();
  void _unFocus() {
    _titleFocus.unfocus();
    _contentsFocus.unfocus();
    _costFocus.unfocus();
  }

  TextEditingController? _lastTitle;
  TextEditingController? _lastContents;
  TextEditingController? _lastCost;

  String? _contents;
  int? _cost;
  String? _title;
  // [courtName,address,photoURL]
  List<String> _selectedCourtInfo = [];
  void _setYDCourtInfo(List<String> courtInfo) {
    setState(() {
      _selectedCourtInfo = courtInfo;
    });
  }

  DateTime? _dateTime;
  Timestamp? _date;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lastTitle =
        TextEditingController(text: widget.docs[widget.index]['title']);
    _lastContents =
        TextEditingController(text: widget.docs[widget.index]['contents']);
    _lastCost = TextEditingController(
      text: NumberFormat('###,###,###,###')
          .format(widget.docs[widget.index]['cost'])
          .replaceAll(' ', ''),
    );
    _dateTime = widget.docs[widget.index]['date'].toDate();
    _date = widget.docs[widget.index]['date'];
    _selectedCourtInfo = [
      widget.docs[widget.index]['courtName'],
      widget.docs[widget.index]['address'],
      widget.docs[widget.index]['photoURL'],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          _unFocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      renderTextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: _titleFocus,
                        controller: _lastTitle,
                        minLines: 1,
                        label: '제목',
                        onSaved: (val) {
                          setState(() {
                            _title = val;
                          });
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return '제목을 입력하세요.';
                          }
                        },
                      ),
                      renderTextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: _contentsFocus,
                        controller: _lastContents,
                        minLines: 3,
                        label: '내용',
                        onSaved: (val) {
                          setState(() {
                            if (val == null) {
                              _contents = '';
                            } else {
                              _contents = val;
                            }
                          });
                        },
                        // validator: (val) {
                        //   if (val == null || val.isEmpty) {
                        //     return '내용을 입력하세요.';
                        //   }
                        // },
                      ),
                      renderTextFormField(
                        controller: _lastCost,
                        textInputAction: TextInputAction.done,
                        focusNode: _costFocus,
                        minLines: 1,
                        label: '비용',
                        hintText: '금액 (원)',
                        onSaved: (val) {
                          setState(() {
                            _cost = int.parse(val.replaceAll(',', ''));
                          });
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return '금액을 입력하세요.';
                          }
                        },
                      ),
                      InkWell(
                        onTap: () {
                          _unFocus();
                          DatePicker.showDatePicker(
                            context,
                            locale: LocaleType.ko,
                            theme: DatePickerTheme(
                              backgroundColor: Colors.white,
                            ),
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime(DateTime.now().year,
                                DateTime.now().month + 1, DateTime.now().day),
                            onConfirm: (date) {
                              setState(() {
                                _dateTime = date;
                              });
                              DatePicker.showTimePicker(
                                context,
                                currentTime: _dateTime,
                                locale: LocaleType.ko,
                                showSecondsColumn: false,
                                showTitleActions: true,
                                onConfirm: (time) {
                                  print(time);
                                  setState(() {
                                    _dateTime = time;
                                    _date =
                                        Timestamp.fromMicrosecondsSinceEpoch(
                                            time.microsecondsSinceEpoch);
                                  });
                                },
                              );
                            },
                          );
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              dateBox(
                                  flex: 4,
                                  dateType: ' 년 ',
                                  dateFormat: 'yyyy',
                                  fontSize: 16),
                              SizedBox(width: 10),
                              dateBox(
                                  flex: 2,
                                  dateType: ' 월 ',
                                  dateFormat: 'MM',
                                  fontSize: 16),
                              SizedBox(width: 10),
                              dateBox(
                                  flex: 2,
                                  dateType: ' 일 ',
                                  dateFormat: 'dd',
                                  fontSize: 16),
                              Flexible(
                                flex: 2,
                                child: Container(
                                  height: 30,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: _date == null
                                        ? Text(
                                            '00:00',
                                            style: TextStyle(fontSize: 16),
                                          )
                                        : Text(
                                            DateFormat('HH:mm')
                                                .format(_date!.toDate()),
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                  ),
                                ),
                              )
                            ]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              _unFocus();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => YDCourtList(
                                          setYDCourtInfoList:
                                              _setYDCourtInfo)));
                            },
                            child: Text('목록'),
                          ),
                          TextButton(
                            onPressed: () {
                              _unFocus();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => YDMakeCourt(
                                          setYDCourtInfo: _setYDCourtInfo)));
                            },
                            child: Text('직접 입력'),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          _selectedCourtInfo.isEmpty
                              ? Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: Colors.black,
                                  )))
                              //width: ,
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      //width: 180,
                                      child: Image.network(
                                        _selectedCourtInfo.elementAt(2),
                                      ),
                                    ),
                                    Text(
                                      _selectedCourtInfo.elementAt(0),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(_selectedCourtInfo.elementAt(1))
                                  ],
                                ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _unFocus();
                          _unFocus();
                          if (_date == null) {
                            showDialog(
                                context: context,
                                builder: (context) => MyDialog(
                                    dialogTitle: '시간을 선택해주세요.',
                                    buttonText: const ['확인']));
                          } else if (_selectedCourtInfo.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) => MyDialog(
                                    dialogTitle: '코트를 선택해주세요.',
                                    buttonText: const ['확인']));
                          }
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            firebase.updateYDCourt(
                              widget.docs,
                              widget.index,
                              _selectedCourtInfo.elementAt(1), //address
                              _contents,
                              _cost,
                              _selectedCourtInfo.elementAt(0), //courtName
                              _date,
                              _selectedCourtInfo.elementAt(2), //photoURL
                              _title,
                            );
                            widget.setListTab(0);
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) => MyDialog(
                                    dialogTitle: '게시물을 수정하였습니다',
                                    buttonText: const ['확인']));
                          }
                        },
                        child: Text('수정'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dateBox({
    @required int? flex,
    @required double? width,
    @required String? dateType,
    @required String? dateFormat,
    @required double? fontSize,
  }) {
    assert(flex != 0);
    assert(width != 0);
    assert(dateType != null);
    assert(dateFormat != null);
    assert(fontSize != 0);

    return Flexible(
      flex: flex!,
      child: Container(
        width: width,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: Colors.grey.shade400)),
        child: _date == null
            ? Align(
                alignment: Alignment.centerRight,
                child: Text(
                  dateType!,
                  style: TextStyle(fontSize: fontSize),
                ),
              )
            : Align(
                alignment: Alignment.centerRight,
                child: Text(
                  DateFormat(dateFormat!).format(_date!.toDate()) + dateType!,
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
      ),
    );
  }
}
