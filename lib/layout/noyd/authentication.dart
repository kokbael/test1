import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:test1/layout/noyd/set_userInfo.dart';
import '../../dbManager.dart' as firebase;

import '../../main.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SignInScreen(
                // headerBuilder: (context, constraints, _) {
                //   return Text('data');
                // },
                providerConfigs: const [
                  EmailProviderConfiguration(),
                  GoogleProviderConfiguration(clientId: 'clientId'),
                  PhoneProviderConfiguration(),
                  FacebookProviderConfiguration(clientId: 'clientId'),
                ],
                // footerBuilder: (context, constraints) {
                //   return Container(
                //     width: 300,
                //     height: 300,
                //     color: Colors.black,
                //   );
                // }
              );
            }
            if (FirebaseAuth.instance.currentUser!.displayName == null) {
              FirebaseAuth.instance.currentUser!.updatePhotoURL(
                  'https://firebasestorage.googleapis.com/v0/b/test1-f35fc.appspot.com/o/picked_image%2Fdefault-user-image.png?alt=media&token=e2b23d6e-baeb-40a9-b191-73711449290c');
              return FutureBuilder(
                  future: firebase.user.get(),
                  builder: (context, AsyncSnapshot snapshot) {
                    final docs = snapshot.data.docs;
                    if (snapshot.hasData == false && docs != null) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return SetUserInfo(
                      docs: docs,
                    );
                  });
            }
            return MyApp();
          }),
    );
  }
}
