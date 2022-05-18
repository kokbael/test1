import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class YDTurnByTurn extends StatefulWidget {
  const YDTurnByTurn({Key? key, this.docs, this.index}) : super(key: key);
  final docs;
  final index;

  @override
  State<YDTurnByTurn> createState() => _YDTurnByTurnState();
}

class _YDTurnByTurnState extends State<YDTurnByTurn> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 어플 없을 시 메시지 처리 추가 필요
                      TextButton(
                        onPressed: () async {
                          final String _address =
                              widget.docs[widget.index]['address'];
                          final LatLng _latlag = await getAddress(_address);
                          final double _lat = _latlag.latitude;
                          final double _lag = _latlag.longitude;
                          final Uri _url = Uri.parse(
                              // driving, walking 경로 안뜸. 한국 정책 상 불가능.
                              'https://www.google.co.kr/maps/dir//$_address/'
                              // 'google.navigation:q=$_address&mode=d',
                              // 'geo:$_lat,$_lag?q=$_address',
                              // "http://maps.google.com/maps?&daddr=+$_lat+,+$_lag+&mode=driving"
                              );
                          if (!await
                              // launchUrl(_url)
                              launchUrl(
                            _url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw 'Could not launch $_url';
                          }
                        },
                        child: Text('[구글 맵] 에서 길 찾기'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final String _address =
                              widget.docs[widget.index]['address'];
                          final LatLng _latlag = await getAddress(_address);
                          final double _lat = _latlag.latitude;
                          final double _lag = _latlag.longitude;
                          final Uri _url = Uri.parse(
                              'https://map.kakao.com/link/to/$_address,$_lat,$_lag');
                          try {
                            if (!await launchUrl(_url,
                                mode: LaunchMode.externalApplication)) {
                              throw 'Could not launch $_url';
                            }
                          } catch (e) {
                            launchUrl(Uri.parse(
                                'market://details?id=com.net.daum.android.map'));
                          }
                        },
                        child: Text('[카카오 맵] 에서 길 찾기'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final String _address =
                              widget.docs[widget.index]['address'];
                          final LatLng _latlag = await getAddress(_address);
                          final double _lat = _latlag.latitude;
                          final double _lag = _latlag.longitude;
                          final Uri _url = Uri.parse(
                            'nmap://route/car?slat=&slng=&sname=&dlat=$_lat&dlng=$_lag&dname=$_address&appname=com.epin.test1',
                          );
                          try {
                            if (!await launchUrl(_url,
                                mode: LaunchMode.externalApplication)) {
                              throw 'Could not launch $_url';
                            }
                          } catch (e) {
                            launchUrl(Uri.parse(
                                'market://details?id=com.nhn.android.nmap'));
                          }
                        },
                        child: Text('[네이버 지도] 에서 길 찾기'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final String _address =
                              widget.docs[widget.index]['address'];
                          final LatLng _latlag = await getAddress(_address);
                          final double _lat = _latlag.latitude;
                          final double _lag = _latlag.longitude;
                          final Uri _url = Uri.parse(
                              'tmap://search?name=$_address&rGox=$_lag&rGoY=$_lat');
                          try {
                            if (!await launchUrl(_url,
                                mode: LaunchMode.externalApplication)) {
                              throw 'Could not launch $_url';
                            }
                          } catch (e) {
                            launchUrl(Uri.parse(
                                'market://details?id=com.skt.tmap.ku'));
                          }
                        },
                        child: Text('[티 맵] 에서 길 찾기'),
                      ),
                    ],
                  ),
                );
              });
        },
        child: Text('길찾기'));
  }

  Future<LatLng> getAddress(address) async {
    final query = address;
    List<Location> geoAddress = await locationFromAddress(query);
    var first = geoAddress.first;
    var _lat = first.latitude;
    var _lng = first.longitude;
    LatLng(_lat, _lng).latitude;
    return LatLng(_lat, _lng);
  }
}
