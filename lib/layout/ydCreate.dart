import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  String? _title;
  String? _contents;
  int? _cost;
  // [courtName,address,photoURL]
  List<String> _selectedCourtInfo = [];
  void _setYDCourtInfoList(List<String> courtInfo) {
    setState(() {
      _selectedCourtInfo = courtInfo;
    });
  }

  DateTime? _dateTime;
  Timestamp? _date;
  Timestamp? _time;

  int? _howMuchTime;
  void _setTime(int i) {
    setState(() {
      _howMuchTime = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
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
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      Row(
                        children: [
                          Flexible(
                            flex: 7,
                            child: InkWell(
                              onTap: () {
                                _unFocus();
                                DatePicker.showDatePicker(
                                  context,
                                  locale: LocaleType.ko,
                                  theme: DatePickerTheme(
                                    doneStyle: TextStyle(
                                      color: Colors.deepPurple.shade300,
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  showTitleActions: true,
                                  minTime: DateTime.now(),
                                  maxTime: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month + 1,
                                      DateTime.now().day),
                                  onConfirm: (pickDate) {
                                    setState(() {
                                      _dateTime = DateTime(
                                        pickDate.year,
                                        pickDate.month,
                                        pickDate.day,
                                      );
                                      _date =
                                          Timestamp.fromMicrosecondsSinceEpoch(
                                              pickDate.microsecondsSinceEpoch);
                                    });
                                  },
                                );
                              },
                              child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _dateBox(
                                        flex: 4,
                                        dateType: ' 년 ',
                                        dateFormat: 'yyyy',
                                        fontSize: 14),
                                    SizedBox(width: 10),
                                    _dateBox(
                                        flex: 3,
                                        dateType: ' 월 ',
                                        dateFormat: 'MM',
                                        fontSize: 14),
                                    SizedBox(width: 10),
                                    _dateBox(
                                        flex: 3,
                                        dateType: ' 일 ',
                                        dateFormat: 'dd',
                                        fontSize: 14),
                                  ]),
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _date == null
                                              ? showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      MyDialog(
                                                          dialogTitle:
                                                              '날짜를 먼저 선택해주세요.',
                                                          buttonText: const [
                                                            '확인'
                                                          ]))
                                              : DatePicker.showTimePicker(
                                                  context,
                                                  currentTime: _dateTime,
                                                  locale: LocaleType.ko,
                                                  showSecondsColumn: false,
                                                  showTitleActions: true,
                                                  theme: DatePickerTheme(
                                                    doneStyle: TextStyle(
                                                      color: Colors
                                                          .deepPurple.shade300,
                                                    ),
                                                  ),
                                                  onConfirm: (pickTime) {
                                                    // print(time);
                                                    setState(() {
                                                      _time = Timestamp
                                                          .fromMicrosecondsSinceEpoch(
                                                              pickTime
                                                                  .microsecondsSinceEpoch);
                                                      _dateTime = pickTime;
                                                    });
                                                  },
                                                );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              border: Border.all(
                                                  color: Colors.grey.shade400)),
                                          height: 30,
                                          child: _time == null
                                              ? Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    ' 00:00 ',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                )
                                              : Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    DateFormat('HH:mm  ')
                                                        .format(
                                                            _time!.toDate()),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => SizedBox(
                                          height: 250,
                                          child: SingleChildScrollView(
                                            // primary: true,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Stack(children: [
                                                  Container(
                                                    width: double.infinity,
                                                    height: 56.0,
                                                    child: Center(
                                                        child: Text(
                                                      "시간 선택",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ) // Your desired title
                                                        ),
                                                  ),
                                                  Positioned(
                                                    left: 0.0,
                                                    top: 0.0,
                                                    child: IconButton(
                                                        icon: Icon(
                                                            Icons.arrow_back),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }),
                                                  ),
                                                ]),
                                                for (int i = 1; i <= 12; i++)
                                                  ListTile(
                                                      title: Center(
                                                          child: Text('$i 시간')),
                                                      onTap: () {
                                                        _setTime(i);
                                                        Navigator.pop(context);
                                                      }),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 30,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: _howMuchTime == null
                                            ? Row(
                                                children: const [
                                                  Text('시간 선택',
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                  Icon(Icons.arrow_drop_down),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  _howMuchTime! < 10
                                                      ? Text(_howMuchTime
                                                              .toString() +
                                                          '   시간')
                                                      : Text(_howMuchTime
                                                              .toString() +
                                                          ' 시간'),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(Icons.arrow_drop_down),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => YDCourtList(
                                      setYDCourtInfoList:
                                          _setYDCourtInfoList)));
                        },
                        child: Text('테니스장 선택'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _unFocus();
                          if (_date == null) {
                            showDialog(
                                context: context,
                                builder: (context) => MyDialog(
                                    dialogTitle: '날짜를 선택해주세요.',
                                    buttonText: const ['확인']));
                          } else if (_time == null || _howMuchTime == null) {
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
                              address: _selectedCourtInfo.elementAt(1),
                              contents: _contents!,
                              cost: _cost!,
                              courtName: _selectedCourtInfo.elementAt(0),
                              howMuchTime: _howMuchTime!,
                              date: _time!,
                              photoURL: _selectedCourtInfo.elementAt(2),
                              title: _title!,
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

  Widget _dateBox({
    @required int? flex,
    @required String? dateType,
    @required String? dateFormat,
    @required double? fontSize,
  }) {
    assert(flex != 0);
    assert(dateType != null);
    assert(dateFormat != null);
    assert(fontSize != 0);

    return Flexible(
        flex: flex!,
        child: Container(
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
        ));
  }
}
