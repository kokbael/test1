import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  const DropDown({Key? key, this.setTownData}) : super(key: key);
  final setTownData;
  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  final List<String> _townList = [
    '지역 선택',
    '전체',
    '서울',
    '경기',
    '인천',
    '부산',
  ];
  String _selectedTown = '지역 선택';

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
            if (value == '전체') {
              widget.setTownData('전체');
            }
            if (value == '서울') {
              widget.setTownData('seoul');
            }
            if (value == '경기') {
              widget.setTownData('kyungki');
            }
            if (value == '인천') {
              widget.setTownData('incheon');
            }
            if (value == '부산') {
              widget.setTownData('busan');
            }
          }
        });
      },
    );
  }

  // Future<List?> courtList(String townData) async {
  //   List list = [];
  //   List _townList = ['seoul', 'kyungki', 'incheon', 'busan'];
  //   if (townData == '전체') {
  //     for (var town in _townList) {
  //       var ref = FirebaseFirestore.instance
  //           .collection('court')
  //           .doc(town)
  //           .collection(town + 'Court')
  //           .orderBy('courtName');
  //       await ref.get().then((QuerySnapshot querySnapshot) =>
  //           {for (var doc in querySnapshot.docs) list.add(doc.data())});
  //     }
  //     return list;
  //   } else {
  //     var ref = FirebaseFirestore.instance
  //         .collection('court')
  //         .doc(townData)
  //         .collection(townData + 'Court')
  //         .orderBy('courtName');
  //     await ref.get().then((QuerySnapshot querySnapshot) =>
  //         {for (var doc in querySnapshot.docs) list.add(doc.data())});
  //     return list;
  //   }
  // }
}
