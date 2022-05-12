import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:test1/layout/myDialog.dart';
import 'package:test1/layout/renderTextFormField.dart';
import '../../main.dart';
import 'package:image_picker/image_picker.dart';
import 'dbManager.dart' as firebase;

class SetUserInfo extends StatefulWidget {
  const SetUserInfo({
    Key? key,
    this.isUpdate,
    this.uid,
    this.docs,
  }) : super(key: key);
  final isUpdate;
  final uid;
  final docs;

  @override
  State<SetUserInfo> createState() => _SetUserInfoState();
}

class _SetUserInfoState extends State<SetUserInfo> {
  final formKey = GlobalKey<FormState>();

  File? pickedImage;
  String? _displayName;

  void _camPickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 150,
    );
    print(pickedImageFile?.path.toString());
    setState(() {
      if (pickedImageFile != null) {
        setState(() {
          pickedImage = File(pickedImageFile.path);
        });
      }
    });
    setPhotoURL();
  }

  void _galPickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 150,
    );
    setState(() {
      if (pickedImageFile != null) {
        setState(() {
          pickedImage = File(pickedImageFile.path);
        });
      }
    });
    setPhotoURL();
  }

  void setDisplayName(String? displayName) async {
    await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);
  }

  void setPhotoURL() async {
    final refImage = FirebaseStorage.instance
        .ref()
        .child('picked_image')
        .child(FirebaseAuth.instance.currentUser!.uid + '.png');
    await refImage.putFile(pickedImage!);
    final url = await refImage.getDownloadURL();
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(url.toString());
  }

  bool buttonPressAble = false;
  bool nameCheck(displayName) {
    for (int i = 0; i < widget.docs.length; i++) {
      if (widget.docs[i]['name'] == displayName) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => widget.isUpdate ? true : false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    widget.isUpdate == true ? Text('수정') : Text('Welcome'),
                    Container(
                      padding: EdgeInsets.all(8),
                      width: 100,
                      height: 100,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: pickedImage == null
                            ? null
                            : FileImage(pickedImage!),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade200),
                          child: IconButton(
                            splashRadius: 30,
                            color: Colors.grey,
                            iconSize: 30,
                            onPressed: () {
                              _camPickImage();
                            },
                            icon: Icon(Icons.camera_alt_outlined),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade200),
                          child: IconButton(
                            splashRadius: 30,
                            color: Colors.grey,
                            iconSize: 30,
                            onPressed: () {
                              _galPickImage();
                            },
                            icon: Icon(Icons.image_search),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        buttonPressAble = false;
                      },
                      child: Container(
                        width: 300,
                        child: renderTextFormField(
                          minLines: 1,
                          label: '닉네임',
                          onSaved: (val) {
                            setState(() {
                              _displayName = val;
                            });
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return '닉네임을 입력하세요.';
                            }
                          },
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        formKey.currentState?.save();
                        if (formKey.currentState!.validate()) {
                          if (nameCheck(_displayName)) {
                            buttonPressAble = true;
                            showDialog(
                                context: context,
                                builder: (context) => MyDialog(
                                    dialogTitle: '사용 가능한 이름입니다.',
                                    buttonText: const ['확인']));
                            setDisplayName(_displayName);
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => MyDialog(
                                    dialogTitle: '중복된 이름입니다.',
                                    buttonText: const ['확인']));
                          }
                        }
                      },
                      child: Text('Check'),
                    ),
                    ElevatedButton(
                      onPressed: !buttonPressAble
                          ? () {
                              showDialog(
                                  context: context,
                                  builder: (context) => MyDialog(
                                      dialogTitle: 'Please passed Check',
                                      buttonText: const ['확인']));
                            }
                          : () {
                              if (FirebaseAuth
                                      .instance.currentUser!.displayName !=
                                  null) {
                                widget.isUpdate == true
                                    ? firebase.updateUserinfo(
                                        _displayName,
                                        FirebaseAuth
                                            .instance.currentUser!.photoURL,
                                      )
                                    : firebase.addUserinfo(
                                        _displayName,
                                        FirebaseAuth
                                            .instance.currentUser!.photoURL,
                                      );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyApp()));
                              }
                            },
                      child: Text('확인'),
                    )
                  ],
                ),
              ),
            );
          },
        )),
      ),
    );
  }
}
