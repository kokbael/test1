import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:geocoding/geocoding.dart';

class YDKakaoMap extends StatefulWidget {
  const YDKakaoMap({Key? key, this.docs, this.index}) : super(key: key);
  final docs;
  final index;

  @override
  State<YDKakaoMap> createState() => _YDKakaoMapState();
}

class _YDKakaoMapState extends State<YDKakaoMap> {
  String kakaoMapKey = '7b7e63e4f629891e9a589d8d941f3fe5';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: _getAddress(widget.docs, widget.index),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          } else {
            final _lat = snapshot.data.lat;
            final _lng = snapshot.data.lng;
            return KakaoMapView(
                mapType: MapType.TERRAIN,
                width: size.width,
                height: 200,
                kakaoMapKey: kakaoMapKey,
                lat: _lat,
                lng: _lng,
                showMapTypeControl: false,
                showZoomControl: true,
                markerImageURL:
                    'https://firebasestorage.googleapis.com/v0/b/test1-f35fc.appspot.com/o/marker_final.png?alt=media&token=d941be39-65bb-4ee9-8284-aad21bd17de4',
                onTapMarker: (message) {
                  //event callback when the marker is tapped
                });
          }
        });
  }

  Future<KakaoLatLng> _getAddress(docs, index) async {
    final query = docs[index]['address'];
    List<Location> geoAddress = await locationFromAddress(query);
    var first = geoAddress.first;
    var _lat = first.latitude;
    var _lng = first.longitude;
    return KakaoLatLng(lat: _lat, lng: _lng);
  }
}
