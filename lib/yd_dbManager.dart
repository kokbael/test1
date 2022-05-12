import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

CollectionReference ydcourt = FirebaseFirestore.instance.collection('ydcourt');

void createYDCourt(address, contents, cost, courtName, date, photoURL, title) {
  List<String> _townList = ['서울', '경기', '인천', '부산'];
  try {
    ydcourt.add({
      'Dday': setDday(date),
      'address': address,
      'confirm': false,
      'contents': contents,
      'cost': cost,
      'courtName': courtName,
      'date': date,
      'postDate': Timestamp.now(),
      'photoURL': photoURL,
      'title': title,
      'town': _townList.contains(address.substring(0, 2))
          ? address.substring(0, 2)
          : '기타 지역',
      'userName': FirebaseAuth.instance.currentUser!.displayName,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'userPhoto': FirebaseAuth.instance.currentUser!.photoURL,
    }).then((docRef) => docRef.update({'id': docRef.id}));
  } catch (e) {
    print(e);
  }
}

void confirmYDCourt(docs, index) {
  try {
    ydcourt.doc(docs[index]['id']).update({
      'confirm': !docs[index]['confirm'],
    });
  } catch (e) {
    print(e);
  }
}

void updateYDCourt(
    docs, index, address, contents, cost, courtName, date, photoURL, title) {
  try {
    ydcourt.doc(docs[index]['id']).update({
      'id': docs[index]['id'],
    });
  } catch (e) {
    print(e);
  }

  List<String> _townList = ['서울', '경기', '인천', '부산'];
  try {
    ydcourt.doc(docs[index]['id']).update({
      'Dday': setDday(date),
      'address': address,
      'contents': contents,
      'cost': cost,
      'courtName': courtName,
      'date': date,
      // 'postDate': Timestamp.now(),
      'photoURL': photoURL,
      'title': title,
      'town': _townList.contains(address.substring(0, 2))
          ? address.substring(0, 2)
          : '기타 지역',
      'userName': FirebaseAuth.instance.currentUser!.displayName,
      // 'uid': FirebaseAuth.instance.currentUser!.uid,
      'userPhoto': FirebaseAuth.instance.currentUser!.photoURL,
    });
  } catch (e) {
    print(e);
  }
}

int setDday(Timestamp date) {
  // 오름차순 : 1, 2, ... , 31, 마감(32), 완료(33)
  String eightDate = DateFormat('yyyyMMdd').format(date.toDate());
  int days = DateTime.now().difference(DateTime.parse(eightDate)).inDays;
  int hours = DateTime.now().difference(DateTime.parse(eightDate)).inHours;
  if (days == 0) {
    // days == 0 일 경우 2 가지 경우 따로 처리.
    // 같은 날 시간이 지났으면 마감(32), 아니면 0 (D-day)
    String dateHH = DateFormat('HH').format(date.toDate());
    String nowHH = DateFormat('HH').format(DateTime.now());
    int diffHH = int.parse(dateHH) - int.parse(nowHH);
    if (diffHH > 0) {
      // D-day
      return 0;
    } else {
      // D-day 에서 시간 지난 마감
      return 32;
    }
  } else if (days > 0) {
    // Day 넘어 간 마감
    return 32;
  } else {
    // D-n
    return (-hours / 24).round();
  }
}

void updateDday(docs) {
  for (var doc in docs) {
    // 오름차순 : 1, 2, 마감(32), 완료(33)
    String eightDate = DateFormat('yyyyMMdd').format(doc['date'].toDate());
    int days = DateTime.now().difference(DateTime.parse(eightDate)).inDays;
    int hours = DateTime.now().difference(DateTime.parse(eightDate)).inHours;
    if (doc['confirm'] == true) {
      // 완료
      try {
        ydcourt.doc(doc['id']).update({
          'Dday': 33,
        });
      } catch (e) {
        print(e);
      }
    } else {
      if (days == 0) {
        // days == 0 일 경우 2 가지 경우 따로 처리.
        // 같은 날 시간이 지났으면 마감(32), 아니면 0 (D-day)
        String dateHH = DateFormat('HH').format(doc['date'].toDate());
        String nowHH = DateFormat('HH').format(DateTime.now());
        int diffHH = int.parse(dateHH) - int.parse(nowHH);
        if (diffHH > 0) {
          try {
            ydcourt.doc(doc['id']).update({
              'Dday': 0,
            });
          } catch (e) {
            print(e);
          }
        } else {
          try {
            ydcourt.doc(doc['id']).update({
              // 마감 D-day
              'Dday': 32,
            });
          } catch (e) {
            print(e);
          }
        }
      } else if (days < 0) {
        // 현역
        try {
          ydcourt.doc(doc['id']).update({
            'Dday': (-hours / 24).round(),
          });
        } catch (e) {
          print(e);
        }
      } else if (days > 0) {
        // 마감
        try {
          ydcourt.doc(doc['id']).update({
            'Dday': 32,
          });
        } catch (e) {
          print(e);
        }
      }
    }
  }
}

void deleteYDCourt(docs, index) {
  ydcourt.doc(docs[index]['id']).delete();
}
