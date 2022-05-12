import 'package:flutter/material.dart';
import 'package:test1/layout/noyd/set_userInfo.dart';
import 'dbManager.dart' as firebase;

class InfoUser extends StatefulWidget {
  const InfoUser({Key? key, this.uid}) : super(key: key);
  final uid;
  @override
  State<InfoUser> createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: firebase.user.get(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              final docs = snapshot.data.docs;
              for (int index = 0; index < docs.length; index++) {
                if (docs[index]['uid'] == widget.uid) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(docs[index]['name']),
                        Container(
                          padding: EdgeInsets.all(8),
                          width: 100,
                          height: 100,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(docs[index]['photoURL']),
                          ),
                        ),
                        IconButton(
                          splashRadius: 15,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SetUserInfo(
                                          isUpdate: true,
                                          uid: widget.uid,
                                          docs: docs,
                                        )));
                          },
                          icon: Icon(Icons.settings),
                        ),
                      ],
                    ),
                  );
                }
              }
            }
            return Container();
          }),
    );
  }
}
