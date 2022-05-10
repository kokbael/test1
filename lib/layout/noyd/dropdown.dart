import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  const DropDown({Key? key, this.setDocs, this.setTownData}) : super(key: key);
  final setDocs;
  final setTownData;
  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  final List<String> _townList = [
    '지역 선택',
    '서울',
    '경기',
    '인천',
    '부산',
  ];
  String _selectedTown = '지역 선택';
  String? _townData;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: _selectedTown,
      items: _townList.map((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(
            value,
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
      onChanged: (value) async {
        setState(() {
          _selectedTown = value.toString();
          if (value != '지역 선택') {
            if (value == '서울') {
              _townData = 'seoul';
              widget.setTownData('seoul');
            }
            if (value == '경기') {
              _townData = 'kyungki';
              widget.setTownData('kyungki');
            }
            if (value == '인천') {
              _townData = 'incheon';
              widget.setTownData('incheon');
            }
            if (value == '부산') {
              _townData = 'busan';
              widget.setTownData('busan');
            }
          }
        });
        List? flag = await townList(_townData!);
        widget.setDocs(flag);
      },
    );
  }

  Future<List?> townList(String townData) async {
    List list = [];
    var first =
        FirebaseFirestore.instance.collection(townData).orderBy('courtName');
    await first.get().then((QuerySnapshot querySnapshot) =>
        {for (var doc in querySnapshot.docs) list.add(doc.data())});
    return list;
  }
}
