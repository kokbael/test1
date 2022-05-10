import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class YDMap extends StatefulWidget {
  const YDMap({Key? key, this.docs, this.index}) : super(key: key);
  final docs;
  final index;
  @override
  State<YDMap> createState() => YDMapState();
}

final Completer<GoogleMapController> _controller = Completer();

class YDMapState extends State<YDMap> {
  LatLng? latLng;
  Future<LatLng> getAddress() async {
    final query = widget.docs[widget.index]['address'];
    List<Location> geoAddress = await locationFromAddress(query);
    var first = geoAddress.first;
    var _lat = first.latitude;
    var _lng = first.longitude;
    return LatLng(_lat, _lng);
  }

  Set<Marker> _createMarker(AsyncSnapshot snapshot) {
    return <Marker>{
      Marker(
        markerId: MarkerId("marker_1"),
        position: snapshot.data,
        infoWindow: InfoWindow(
          title: widget.docs[widget.index]['courtName'],
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAddress(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  mapType: MapType.normal,
                  markers: _createMarker(snapshot),
                  initialCameraPosition: CameraPosition(
                    target: snapshot.data,
                    zoom: 15.2746,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                );
        });
  }
}
