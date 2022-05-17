import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kpostal/kpostal.dart';
import 'package:test1/layout/renderTextFormField.dart';

import 'myDialog.dart';

class YDMakeCourt extends StatefulWidget {
  const YDMakeCourt({Key? key, this.setYDCourtInfoList}) : super(key: key);
  // [courtName,address,photoURL]
  final setYDCourtInfoList;
  @override
  State<YDMakeCourt> createState() => _YDMakeCourtState();
}

class _YDMakeCourtState extends State<YDMakeCourt> {
  final formKey = GlobalKey<FormState>();
  File? _pickedImage;
  String? _address;
  String? _courtName;
  String? _photoURL;
  List<String> _makeCourtInfo = [];
  final FocusNode _courtNameFocus = FocusNode();

  void _camPickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      // maxHeight: 150,
    );
    setState(() {
      if (pickedImageFile != null) {
        setState(() {
          _pickedImage = File(pickedImageFile.path);
        });
      }
    });
    setPhotoURL();
  }

  void _galPickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      // maxHeight: 150,
    );
    setState(() {
      if (pickedImageFile != null) {
        setState(() {
          _pickedImage = File(pickedImageFile.path);
        });
      }
    });
    setPhotoURL();
  }

  void setPhotoURL() async {
    final refImage = FirebaseStorage.instance.ref().child('yd_user_made').child(
        FirebaseAuth.instance.currentUser!.uid +
            DateTime.now().toString() +
            '.png');
    await refImage.putFile(_pickedImage!);
    final url = await refImage.getDownloadURL();
    setState(() {
      _photoURL = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: GestureDetector(
              onTap: () {
                _courtNameFocus.unfocus();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _photoURL == null
                      ? Text('이미지를 등록해주세요.')
                      : SizedBox(
                          height: 150,
                          child: Image.network(
                            _photoURL!,
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
                            _courtNameFocus.unfocus();
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
                            _courtNameFocus.unfocus();
                            _galPickImage();
                          },
                          icon: Icon(Icons.image_search),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 300,
                    child: renderTextFormField(
                      focusNode: _courtNameFocus,
                      label: '코트명',
                      onSaved: (val) {
                        setState(() {
                          _courtName = val;
                        });
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return '코트명을 입력하세요.';
                        }
                      },
                      minLines: 1,
                    ),
                  ),
                  Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: _address == null
                        ? Center(
                            child: Text(
                            '주소를 검색해주세요.',
                            style: TextStyle(color: Colors.grey),
                          ))
                        : Text(_address!),
                  ),
                  TextButton(
                    onPressed: () async {
                      _courtNameFocus.unfocus();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KpostalView(
                            useLocalServer: true,
                            localPort: 38628,
                            callback: (Kpostal result) {
                              setState(() {
                                _address = result.address;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Text('주소 검색'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _courtNameFocus.unfocus();
                      if (_photoURL == null) {
                        showDialog(
                            context: context,
                            builder: (context) => MyDialog(
                                dialogTitle: '이미지를 등록해주세요.',
                                buttonText: const ['확인']));
                      } else if (formKey.currentState!.validate()) {
                        formKey.currentState?.save();
                        setState(() {
                          _makeCourtInfo = [_courtName!, _address!, _photoURL!];
                        });
                        widget.setYDCourtInfoList(_makeCourtInfo);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('등록'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
