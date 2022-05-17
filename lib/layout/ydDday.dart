import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YDDday extends StatefulWidget {
  const YDDday({Key? key, this.docs, this.index}) : super(key: key);
  final docs;
  final index;
  @override
  State<YDDday> createState() => _YDDdayState();
}

class _YDDdayState extends State<YDDday> {
  @override
  Widget build(BuildContext context) {
    return _Dday(widget.docs[widget.index]['date'],
        widget.docs[widget.index]['confirm']);
  }

  Widget _Dday(Timestamp date, confirm) {
    String eightDate = DateFormat('yyyyMMdd').format(date.toDate());
    int days = DateTime.now().difference(DateTime.parse(eightDate)).inDays;
    int hours = DateTime.now().difference(DateTime.parse(eightDate)).inHours;
    if (confirm == true) {
      return renderDday(Dday: 33);
    } else if (days == 0 && hours >= 0) {
      String dateHH = DateFormat('HH').format(date.toDate());
      String nowHH = DateFormat('HH').format(DateTime.now());
      int diffHH = int.parse(dateHH) - int.parse(nowHH);
      if (diffHH > 0) {
        // D-day
        return renderDday(Dday: 0);
      } else {
        // D-day 에서 시간 지난 마감
        return renderDday(Dday: 32);
      }
    } else if (days > 0) {
      // Day 넘어 간 마감
      return renderDday(Dday: 32);
    } else {
      // D-n
      return renderDday(Dday: (-hours / 24).ceil());
    }
  }

  Widget renderDday({@required int? Dday}) {
    assert(Dday != null);
    return Container(
      width: 45,
      decoration: BoxDecoration(
          color: Dday! == 33
              ? Colors.lightGreen
              : Dday <= 7
                  ? Colors.red
                  : Dday <= 20
                      ? Colors.orange
                      : Dday <= 31
                          ? Colors.lightBlueAccent
                          : Colors.grey,
          border: Border.all(
            width: 1,
            color: Dday == 33
                ? Colors.lightGreen
                : Dday <= 7
                    ? Colors.red
                    : Dday <= 20
                        ? Colors.orange
                        : Dday <= 31
                            ? Colors.lightBlueAccent
                            : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        Dday == 33
            ? '완료'
            : Dday == 32
                ? '만료'
                : Dday == 0
                    ? 'D-day'
                    : 'D-' + Dday.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
