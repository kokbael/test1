import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/layout/noyd/searchResult.dart';
import '../../dbManager.dart' as firebase;
import 'boardReadPage.dart';
import 'package:intl/intl.dart';

class BoardList extends StatelessWidget {
  const BoardList({Key? key}) : super(key: key);

  String timestamp2String(Timestamp timestamp) {
    DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    return formatter.format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      body: StreamBuilder(
          stream: firebase.board.orderBy('date', descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              final docs = snapshot.data!._docs;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                        child: Text(
                          'Community',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 2, color: Colors.deepPurple.shade400),
                          borderRadius: BorderRadius.circular(8)),
                      margin: EdgeInsets.all(10),
                      height: 400,
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (BuildContext context1, index) {
                            return GestureDetector(
                              // 게시판 목록 Container
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BoardReadPage(
                                            index: index, docs: docs)));
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1.0,
                                            color:
                                                Colors.deepPurple.shade400))),
                                child: (Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          docs[index]['userName'],
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          docs[index]['title'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          timestamp2String(docs[index]['date']),
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchResult()));
                      },
                      child: Text('검색'),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
