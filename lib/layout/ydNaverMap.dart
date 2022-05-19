import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class YDNaverMap extends StatefulWidget {
  const YDNaverMap({Key? key, this.docs, this.index}) : super(key: key);
  final docs;
  final index;
  @override
  State<YDNaverMap> createState() => YDNaverMapState();
}

class YDNaverMapState extends State<YDNaverMap> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getAddress(widget.docs, widget.index),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.black,
              )),
              width: double.infinity,
              height: 180,
              child: NaverMap(
                initialCameraPosition: CameraPosition(target: snapshot.data),
                markers: [
                  Marker(markerId: 'markerId', position: snapshot.data)
                ],
              ),
            );
          }
        });
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
