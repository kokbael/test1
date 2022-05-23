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
      child: Text('길찾기'),
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(mainAxisSize: MainAxisSize.min, children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 30, 0),
                    child: GestureDetector(
                        child: Image(
                          image: AssetImage('assets/popButton.png'),
                          height: 30,
                          width: 30,
                        ), // Your desired icon
                        onTap: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          final String _address =
                              widget.docs[widget.index]['address'];
                          final Uri _url = Uri.parse(
                              // driving, walking 경로 안뜸. 한국 정책 상 불가능.
                              'https://www.google.co.kr/maps/dir//$_address/');
                          if (!await launchUrl(
                            _url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw 'Could not launch $_url';
                          }
                        },
                        child: Container(
                          width: 70,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                child: Image(
                                  image:
                                      AssetImage('assets/icon_Googlemap.png'),
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '구글맵',
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
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
                        child: Container(
                          width: 70,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Image(
                                image: AssetImage('assets/icon_Kakaomap.png'),
                                width: 70,
                                height: 70,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '카카오맵',
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
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
                        child: Container(
                          width: 70,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Image(
                                image: AssetImage('assets/icon_Navermap.png'),
                                width: 70,
                                height: 70,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '네이버지도',
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
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
                        child: Container(
                          width: 70,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Image(
                                image: AssetImage('assets/icon_Tmap.png'),
                                width: 70,
                                height: 70,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '티맵',
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]);
            });
      },
    );
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
