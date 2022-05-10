import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

String timestamp2String(Timestamp timestamp) {
  DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
  return formatter.format(timestamp.toDate());
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
              child: Text(
                'Search',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border.all(width: 2, color: Colors.deepPurple.shade400),
                  borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.all(10),
              //padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
              height: 480,
              child: Container(
                  child: FutureBuilder(
                      future: titleSearchQuery(['t']),
                      builder: (context, AsyncSnapshot snapshot) {
                        final docs = snapshot.data;
                        return ElevatedButton(
                          onPressed: () {
                            for (int i = 0; i < docs.length; i++) {
                              print(docs[i]['title']);
                              print(timestamp2String(docs[i]['date']));
                            }
                          },
                          child: Text('search'),
                        );
                      })),
            ),
          ],
        ),
      ),
    );
  }
}

// https://okky.kr/article/812089
//https://velog.io/@dongchyeon/%EC%BD%94%ED%8B%80%EB%A6%B0Kotlin-%ED%8C%8C%EC%9D%B4%EC%96%B4%EB%B2%A0%EC%9D%B4%EC%8A%A4-%ED%8C%8C%EC%9D%B4%EC%96%B4%EC%8A%A4%ED%86%A0%EC%96%B4-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EA%B2%80%EC%83%89-%EA%B8%B0%EB%8A%A5-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0
//https://petercoding.com/firebase/2020/02/16/using-firebase-queries-in-flutter/
//https://stackoverflow.com/questions/46642641/sql-like-operator-in-cloud-firestore
Future<List?> titleSearchQuery(List<String> searchTitle) async {
  print('searchTitle : ' + searchTitle.toString());
  List titleList = [];
  List<String> endText = [searchTitle.last + '\uf8ff'];
  var board = FirebaseFirestore.instance.collection("board");
  await board.orderBy('title').startAt(searchTitle).endAt(endText).get().then(
      (QuerySnapshot querySnapshot) =>
          {for (var doc in querySnapshot.docs) titleList.add(doc.data())});
  searchSort(titleList);
  return titleList;
}

//https://www.daleseo.com/sort-bubble/
void searchSort(List titleList) {
  int end = titleList.length - 1;
  while (end > 0) {
    int lastSwap = 0;
    for (int i = 0; i < end; i++) {
      int a = titleList[i]['date'].compareTo(titleList[i + 1]['date']);
      if (a == -1) {
        var tmp = titleList[i];
        titleList[i] = titleList[i + 1];
        titleList[i + 1] = tmp;
        lastSwap = i;
      }
    }
    end = lastSwap;
  }
}

// List searchSort(List titleList) {
//   for (int i = 0; i < titleList.length; i++) {
//     for (int j = 0; j < i; j++) {
//       int a = titleList[i]['date']
//           .compareTo(titleList[j]['date']); // i 번째가 크면 1, j 번째가 크면 -1
//       if (a == 1) {
//         var tmp;
//         tmp = titleList[i];
//         titleList[i] = titleList[j];
//         titleList[j] = tmp;
//       }
//     }
//   }
//   // for (int i = 0; i < titleList.length; i++) {
//   //   print(titleList[i]['title']);
//   //   print(timestamp2String(titleList[i]['date']));
//   // }
//   return titleList;
// }
