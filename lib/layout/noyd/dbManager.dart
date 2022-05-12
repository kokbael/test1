import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

CollectionReference board = FirebaseFirestore.instance.collection('board');
CollectionReference user = FirebaseFirestore.instance.collection('user');
CollectionReference ydcourt = FirebaseFirestore.instance.collection('ydcourt');

// Create
void createPost() {
  var doc1 = FirebaseFirestore.instance.collection('post');
  var doc2 = FirebaseFirestore.instance
      .collection('post')
      .doc('abc')
      .collection('post_sub')
      .doc('1234');

  doc1.add({
    'id': doc1.id,
    'datetime': DateTime.now().toString(),
    'displayName': 'MrPark',
    'photoUrl': 'photoUrl1',
  });

  doc2.set({
    'id': doc2.id,
    'datetime': DateTime.now().toString(),
    'displayName': 'MrKim',
    'photoUrl': 'photoUrl2',
  });
}

// https://unsungit.tistory.com/3
// var result2 = await board //#2  +) where
//     .doc(doc.id)
//     .collection('title')
//     .where('userName', isEqualTo: 'tester')
//     .get()
//     .then((QuerySnapshot snapshot) => {
//           snapshot.docs.forEach((doc) {
//             testResult?.add(doc.data()); //모든 document 정보를 리스트에 저장.
//           })
//         });
// if (result2.toString() != null) {
//   //리스트 관련 후처리 필요한 경우 여기서 처리함.
// }
// }

//   doc.exists() : 하위에 필드가 있으면 true 를 반환.
//   컬렉션(폴더)가 아니라 필드(Data)임!!
//   문서가 있더라도 그 문서 하위에 필드(문서 안에 컬렉션 안에 다시 문서가 갖고 있는 필드 말고,
//   문서 바로 하위에 있는 필드)가 없으면 exists()를 했을 때 결과가 false 가 나온다.
//
//   혹시 본인이 아래와 같은 구조의 데이터베이스를 갖고있다면,
//   collection1 -> document1 -> collection2 -> document2 -> 필드
//
//   db.collection("collection1").doc("document1")의 경우는 false 를 반환하더라도
//
//   db.collection("collection1").doc("document1").collection("collection2")
//   .doc("document2")의 경우는 true 를 반환할것이다.
//
//  https://nerdymint.tistory.com/11

void addUserinfo(userName, userPhotoURL) {
  try {
    user.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'name': userName,
      'photoURL': userPhotoURL,
    });
  } catch (e) {
    print(e);
  }
}

void updateUserinfo(userName, userPhotoURL) {
  user.doc(FirebaseAuth.instance.currentUser!.uid).update({
    'name': userName,
    'photoURL': userPhotoURL,
  });
}

void createYDCourt(address, contents, cost, courtName, date, photoURL, title) {
  List<String> _townList = ['서울', '경기', '인천', '부산'];
  try {
    ydcourt.add({
      'Dday': _setDday(date),
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
    });
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
  List<String> _townList = ['서울', '경기', '인천', '부산'];
  try {
    ydcourt.doc(docs[index]['id']).update({
      'Dday': _setDday(date),
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

int _setDday(Timestamp date) {
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
      // 마감 D-day
      return 32;
    }
  } else {
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

void createBoard(
    boardTitle, boardContents, boardDate, boardUser, userImage, uid) {
  try {
    board.add({
      'title': boardTitle,
      'contents': boardContents,
      'date': boardDate,
      'userName': boardUser,
      'userImage': userImage, // url
      'uid': uid,
    });
  } catch (e) {
    print(e);
  }
}

void updateBoard(
  docs,
  index,
  boardTitle,
  boardContents,
  boardDate,
  boardUser,
  userImage,
) {
  try {
    board.doc(docs[index].id.toString()).update({
      'title': boardTitle,
      'contents': boardContents,
      'date': boardDate,
      'userName': boardUser,
      'userImage': userImage, // url
    });
  } catch (e) {
    print(e);
  }
}

void deleteBoard(docs, index) {
  board.doc(docs[index].id.toString()).delete();
}

void deleteYDCourt(docs, index) {
  ydcourt.doc(docs[index].id.toString()).delete();
}
