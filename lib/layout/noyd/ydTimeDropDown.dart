import 'package:flutter/material.dart';

class YDTimeDropDown extends StatefulWidget {
  const YDTimeDropDown({Key? key, this.setTime, this.selectedTimeForUpdate})
      : super(key: key);
  final setTime;
  final selectedTimeForUpdate;

  @override
  State<YDTimeDropDown> createState() => _YDTimeDropDownState();
}

class _YDTimeDropDownState extends State<YDTimeDropDown> {
  final List<String> _hourList = [
    '시간 선택',
    '1 시간',
    '2 시간',
    '3 시간',
    '4 시간',
    '5 시간',
    '6 시간',
    '7 시간',
    '8 시간',
    '9 시간',
    '10 시간',
    '11 시간',
    '12 시간',
  ];
  String? _selectedHour;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedHour = widget.selectedTimeForUpdate == null
        ? '시간 선택'
        : '${widget.selectedTimeForUpdate} 시간';
    print(widget.selectedTimeForUpdate);
    print(_selectedHour);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: _selectedHour,
        items: _hourList.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (value) async {
          setState(() {
            _selectedHour = value.toString();
            if (value != '시간 선택') {
              for (int i = 1; i <= 12; i++) {
                if (value == '$i 시간') {
                  widget.setTime(i);
                }
              }
            }
          });
        });
  }
}
