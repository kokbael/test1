import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:http/http.dart' as http;

class YDNaverMap extends StatefulWidget {
  const YDNaverMap({Key? key, this.docs, this.index}) : super(key: key);
  final docs;
  final index;
  @override
  State<YDNaverMap> createState() => YDNaverMapState();
}

class YDNaverMapState extends State<YDNaverMap> {
  void _naverGeo() async {
    var headers = {
      'X-NCP-APIGW-API-KEY-ID': 'oyktoxjkiv',
      'X-NCP-APIGW-API-KEY': 'kJzDV0xkcfh8m4DO0zL3bftBUa4UdtzstvnBr6AB',
      // 'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data = {
      'query': widget.docs[widget.index]['address'],
      'coordinate': '127.1054328,37.3595963',
    };

    var url = Uri.parse(
        'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode');
    var res = await http.post(url, headers: headers, body: data);
    print(res.body);
    if (res.statusCode != 200)
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    print(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getAddress(widget.docs, widget.index),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final _latLag = snapshot.data;
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            _naverGeo();
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.black,
              )),
              width: double.infinity,
              height: 180,
              child: FutureBuilder(
                  future: getOverLayImage(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    final _overlayImage = snapshot.data;
                    return NaverMap(
                      initialCameraPosition: CameraPosition(target: _latLag),
                      markers: [
                        Marker(
                          markerId: 'markerId',
                          position: _latLag,
                          icon: _overlayImage,
                          width: 60,
                          height: 60,
                        )
                      ],
                    );
                  }),
            );
          }
        });
  }

  Future<OverlayImage> getOverLayImage() async {
    return await OverlayImage.fromAssetImage(
      assetName: 'assets/mapPin.png',
    );
  }

  Future<LatLng> _getAddress(docs, index) async {
    final query = docs[index]['address'];
    List<Location> geoAddress = await locationFromAddress(query);
    var first = geoAddress.first;
    var _lat = first.latitude;
    var _lng = first.longitude;
    return LatLng(_lat, _lng);
  }
}
