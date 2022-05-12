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

class YDCreate extends StatefulWidget {
  const YDCreate({Key? key, this.setTab}) : super(key: key);
  final setTab;
  @override
  State<YDCreate> createState() => _YDCreateState();
}

class _YDCreateState extends State<YDCreate> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _contentsFocus = FocusNode();
  final FocusNode _costFocus = FocusNode();
  void _unFocus() {
    _titleFocus.unfocus();
    _contentsFocus.unfocus();
    _costFocus.unfocus();
  }

  String? _contents;
  int? _cost;
  Timestamp? _date;
  String? _title;

  final DateFormat _formatter = DateFormat('yyyy-MM-dd HH:mm');
  DateTime? _dateTime;

  // [courtName,address,photoURL]
  List<String> _selectedCourtInfo = [];
  void _setYDCourtInfoList(List<String> courtInfo) {
    setState(() {
      _selectedCourtInfo = courtInfo;
    });
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
                        minLines: 3,
                        label: '내용',
                        // Contents 는 내용이 없을 수 있음
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
                        textInputAction: TextInputAction.done,
                        focusNode: _costFocus,
                        minLines: 1,
                        label: '비용',
                        hintText: '금액 (원)',
                        onSaved: (val) {
                          setState(() {
                            // 파이어베이스에는 , 를 제외하고 Number(int) 로 저장
                            _cost = int.parse(val.replaceAll(',', ''));
                          });
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return '금액을 입력하세요.';
                          }
                        },
                      ),
                      Text('날짜 / 시간'),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                _unFocus();
                                DatePicker.showDatePicker(
                                  context,
                                  locale: LocaleType.ko,
                                  theme: DatePickerTheme(
                                    backgroundColor: Colors.white,
                                  ),
                                  showTitleActions: true,
                                  minTime: DateTime.now(),
                                  maxTime: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month + 1,
                                      DateTime.now().day),
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
                                          _date = Timestamp
                                              .fromMicrosecondsSinceEpoch(
                                                  time.microsecondsSinceEpoch);
                                        });
                                      },
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.calendar_today_outlined),
                            ),
                            _dateTime == null
                                ? Text('')
                                : Text(_formatter.format(_dateTime!)),
                          ]),
                      Text('코트 선택'),
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
                                              _setYDCourtInfoList)));
                            },
                            child: Text('목록'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => YDMakeCourt(
                                          setYDCourtInfo:
                                              _setYDCourtInfoList)));
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
                                    Container(
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
                          } else if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            firebase.createYDCourt(
                              _selectedCourtInfo.elementAt(1),
                              _contents,
                              _cost,
                              _selectedCourtInfo.elementAt(0),
                              _date,
                              _selectedCourtInfo.elementAt(2),
                              _title,
                            );
                            widget.setTab(2);
                            showDialog(
                                context: context,
                                builder: (context) => MyDialog(
                                    dialogTitle: '게시물을 등록하였습니다',
                                    buttonText: const ['확인']));
                          }
                        },
                        child: Text('등록'),
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
}
