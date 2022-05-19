import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class YDGoogleMap extends StatefulWidget {
  const YDGoogleMap({Key? key, this.docs, this.index}) : super(key: key);
  final docs;
  final index;
  @override
  State<YDGoogleMap> createState() => YDGoogleMapState();
}

final Completer<GoogleMapController> _controller = Completer();

class YDGoogleMapState extends State<YDGoogleMap> {
  LatLng? latLng;
  Future<LatLng> getAddress() async {
    final query = widget.docs[widget.index]['address'];
    List<Location> geoAddress = await locationFromAddress(query);
    var first = geoAddress.first;
    var _lat = first.latitude;
    var _lng = first.longitude;
    return LatLng(_lat, _lng);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> _getBitmapDescriptor() async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/mapPin.png', 150);
    return BitmapDescriptor.fromBytes(markerIcon);
  }

  Set<Marker> _createMarker(AsyncSnapshot snapshot1, AsyncSnapshot snapshot2) {
    return <Marker>{
      Marker(
        markerId: MarkerId("marker_1"),
        position: snapshot1.data,
        infoWindow: InfoWindow(
          title: widget.docs[widget.index]['courtName'],
        ),
        icon: snapshot2.data,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.black,
      )),
      width: double.infinity,
      height: 180,
      child: FutureBuilder(
          future: getAddress(),
          builder: (BuildContext context, AsyncSnapshot snapshot1) {
            return !snapshot1.hasData
                ? Center(child: CircularProgressIndicator())
                : FutureBuilder(
                    future: _getBitmapDescriptor(),
                    builder: (context, snapshot2) {
                      return !snapshot2.hasData
                          ? Center(child: CircularProgressIndicator())
                          : GoogleMap(
                              mapType: MapType.normal,
                              markers: _createMarker(snapshot1, snapshot2),
                              initialCameraPosition: CameraPosition(
                                target: snapshot1.data,
                                zoom: 15.2746,
                              ),
                              // onMapCreated: (GoogleMapController controller) {
                              //   _controller.complete(controller);
                              // },
                            );
                    });
          }),
    );
  }
}
