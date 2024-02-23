import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:islamic_application/constants/app_contants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui' as ui;
import '../../shared_prefs/shared_prefs.dart';
import 'Data.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class MosqueLocator extends StatefulWidget {
  double? lat;
  double? long;

  MosqueLocator({Key? key, required this.lat, required this.long})
      : super(key: key);

  @override
  State<MosqueLocator> createState() => _MosqueLocatorState();
}

class _MosqueLocatorState extends State<MosqueLocator> {
  String? search;

  late WebViewController controller;

  LatLng? userLocation;

  LatLng? endLocation;
  late GoogleMapController mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  String? encodedData;

  String test = '';

  TextEditingController placeController = TextEditingController();

  //PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void getMosques() async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${widget.lat!},${widget.long!}&radius=5000&type=mosque&key=$apiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final places = data['results'];
      for (int i = 0; i < places.length; i++) {
        final place = places[i];
        final lat = place['geometry']['location']['lat'];
        final lng = place['geometry']['location']['lng'];

        // Customize the marker icon for mosques
        final markerIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5),
          'assets/images/pin.png', // Replace with your mosque marker image path
        );

        final marker = Marker(
          markerId: MarkerId(place['place_id']),
          position: LatLng(lat, lng),
          icon: markerIcon,
          infoWindow: InfoWindow(
            title: place['name'],
            snippet: place['mosques'],
          ),
        );

        setState(() {
          markers[MarkerId(marker.markerId.toString())] = marker;
        });
      }
    }
  }

  Future<Uint8List> getImage(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    search = 'masjid';

    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    userLocation = LatLng(widget.lat!, widget.long!);
    String jsonString = DataSharedPrefrences.getMarkers();
    print(jsonString);
    // final Uint8List markIcon =
    //     getImage("assets/images/pin.png", 80) as Uint8List;
    if (jsonString.isNotEmpty) {
      List<dynamic> markerDataList = jsonDecode(jsonString);
      for (var markerData in markerDataList) {
        MarkerId markerId = MarkerId(markerData['markerId']);
        Marker marker = Marker(
          markerId: markerId,
          position: LatLng(markerData['position']['latitude'],
              markerData['position']['longitude']),
          infoWindow: InfoWindow(
              title: markerData['infoWindow']['title'],
              snippet: markerData['infoWindow']['snippet']),
          icon: BitmapDescriptor.defaultMarker,
          alpha: markerData['alpha'],
          anchor: Offset(double.parse(markerData['anchor'].split(',').first),
              double.parse(markerData['anchor'].split(',').last)),
          consumeTapEvents: markerData['consumeTapEvents'],
          flat: markerData['flat'],
          rotation: markerData['rotation'],
          zIndex: markerData['zIndex'],
          // onTap: () {print(markerData['onTap']);},
          // onDragStart: (LatLng pos){print('onDragStart');},
          // onDrag: (LatLng pos){print(markerData['onDrag']);},
          // onDragEnd: (LatLng pos){print(markerData['onDragEnd']);}
        );
        markers[markerId] = marker;
      }
    }

    getMosques();
    super.initState();
  }

  late StreamSubscription<String> _onUrlChanged;
  var currentUrl;

  @override
  Widget build(BuildContext context) {
    // _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
    //   if (mounted) {
    //     setState(() {
    //       currentUrl = url;
    //     });
    //   }
    // });

    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      //Color(0xFF174EA6),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark),
        title: const Text("Mosque Locator",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            )),
        centerTitle: true,
        elevation: 20,
        backgroundColor: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
      ),
      body: GoogleMap(
        mapToolbarEnabled: true,
        myLocationEnabled: true,
        compassEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: userLocation!,
          zoom: 15,
        ),
        markers: markers.values.toSet(),
        onLongPress: (coordinate) {
          test = '${coordinate.latitude} - ${coordinate.longitude}';
          print(test);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                title: const Text("Add Pin 📌"),
                content: SizedBox(
                  // height: 50,
                  child: TextField(
                    controller: placeController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        filled: true,
                        hintStyle:
                            TextStyle(color: Colors.grey[600], fontSize: 15),
                        hintText: "Title for Pin",
                        fillColor: Colors.white70),
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text("CANCEL"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: const Text("PIN"),
                    onPressed: () async {
                      final Uint8List markIcon =
                          await getImage("assets/images/pin.png", 80);
                      final marker = Marker(
                          markerId: MarkerId(placeController.text),
                          position:
                              LatLng(coordinate.latitude, coordinate.longitude),
                          // icon: BitmapDescriptor.,
                          infoWindow: InfoWindow(
                            title: placeController.text,
                          ),
                          icon: BitmapDescriptor
                              .defaultMarker); //BitmapDescriptor.fromBytes(markIcon));
                      setState(() {
                        markers[MarkerId(placeController.text)] = marker;
                      });
                      List<Map<String, dynamic>> markerDataList = [];
                      markers.forEach((markerId, marker) {
                        markerDataList.add({
                          "markerId": markerId.value,
                          "position": {
                            "latitude": marker.position.latitude,
                            "longitude": marker.position.longitude
                          },
                          "infoWindow": {
                            "title": marker.infoWindow.title,
                            "snippet": marker.infoWindow.snippet
                          },
                          "icon": "assets/images/pin.png",
                          "alpha": marker.alpha,
                          "anchor": "${marker.anchor.dx},${marker.anchor.dy}",
                          "consumeTapEvents": marker.consumeTapEvents,
                          "flat": marker.flat,
                          "rotation": marker.rotation,
                          "zIndex": marker.zIndex,
                          // "onTap": marker.onTap,
                          // "onDragStart": marker.onDragStart,
                          // "onDrag": marker.onDrag,
                          // "onDragEnd": marker.onDragEnd,
                        });
                      });
                      print(markerDataList[0]);
                      String jsonString = jsonEncode(markerDataList);
                      await DataSharedPrefrences.setMarkers(jsonString);
                      placeController.clear();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),

      // body: WebView(
      //   javascriptMode: JavascriptMode.unrestricted,
      //   initialUrl:
      //   'https://www.google.com/maps/search/$search/@${widget.lat},${widget
      //       .long},15z',
      //   onWebViewCreated: (controller) {
      //     this.controller = controller;
      //     controller.runJavascript(
      //         "document.getElementsByTagName('input')[0].style.display='none'");
      //   },
      //   onPageStarted: (url) async {
      //     controller.runJavascript(
      //         "document.getElementsByTagName('input')[0].style.display='none'");
      //   },
      //   onProgress: (i) async{
      //     currentUrl = await controller.currentUrl();
      //     print(currentUrl);
      //   },
      //geolocationEnabled: true,

      // ),
      // floatingActionButton: Row(
      //   children: [
      //     SizedBox(width: 35),
      //     SizedBox(
      //       height: 38,
      //       width: 180,
      //       child: FloatingActionButton.extended(
      //         elevation: 0.0,
      //         backgroundColor: const Color(0xFF174EA6),
      //         foregroundColor: Colors.white,
      //         label: const Text("Navigate in app",
      //             style: TextStyle(
      //               fontSize: 13,
      //             )),
      //         icon: const Icon(Icons.navigation_outlined, size: 18),
      //         onPressed: () async {
      //           var uri = Uri.parse(
      //               "google.navigation:q=${widget.lat},${widget.long}&mode=d");
      //           if (await canLaunchUrl(uri)) {
      //             await launchUrl(uri);
      //           } else {
      //             throw 'Could not launch ${uri.toString()}';
      //           }
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      persistentFooterButtons: [
        SizedBox(
          height: 38,
          width: 170,
          child: FloatingActionButton.extended(
            elevation: 0.0,
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            label: const Text("Navigate in app",
                style: TextStyle(
                  fontSize: 13,
                )),
            icon: const Icon(Icons.navigation_outlined, size: 18),
            onPressed: () async {
              var uri = Uri.parse("google.navigation:q=$currentUrl&mode=d");
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                throw 'Could not launch ${uri.toString()}';
              }
            },
          ),
        ),
      ],
    );
  }
}
