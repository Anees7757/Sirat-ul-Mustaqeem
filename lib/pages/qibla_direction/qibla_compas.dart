import 'dart:async';
import 'dart:math' show pi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import '../ad/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'location_error.dart';


class QiblaCompass extends StatefulWidget {
  double? lat;
  double? long;

  QiblaCompass({Key? key, required this.lat, required this.long})
      : super(key: key);

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();

  get stream => _locationStreamController.stream;


  @override
  void initState() {
    _checkLocationStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoActivityIndicator();
          }
          if (snapshot.data!.enabled == true) {
            switch (snapshot.data!.status) {
              case LocationPermission.always:
              case LocationPermission.whileInUse:
                return QiblahCompassWidget(lat: widget.lat, long: widget.long);

              case LocationPermission.denied:
                return LocationErrorWidget(
                  error: "Location service permission denied",
                  callback: _checkLocationStatus,
                );
              case LocationPermission.deniedForever:
                return LocationErrorWidget(
                  error: "Location service Denied Forever !",
                  callback: _checkLocationStatus,
                );
              default:
                return Container();
            }
          } else {
            return LocationErrorWidget(
              error: "Please enable Location service",
              callback: _checkLocationStatus,
            );
          }
        },
      ),
    );
  }

  Future<void> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else {
      _locationStreamController.sink.add(locationStatus);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _locationStreamController.close();
    FlutterQiblah().dispose();
  }
}

class QiblahCompassWidget extends StatefulWidget {
  double? lat;
  double? long;

  QiblahCompassWidget({Key? key, required this.lat, required this.long}) : super(key: key);

  @override
  State<QiblahCompassWidget> createState() => _QiblahCompassWidgetState();
}

class _QiblahCompassWidgetState extends State<QiblahCompassWidget> {

  BannerAd? _bannerAd;

  @override
  void initState() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator();
        }
        final qiblahDirection = snapshot.data;
        var angle = ((qiblahDirection?.qiblah ?? 0) * (pi / 180) * -1);

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
              height: 250,
              child: _buildCompass(),
            ),
            Transform.rotate(
                angle: angle,
                child: Image.asset(
                    "assets/images/qibla_direction/compass_5_k.png")),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Image.asset(
                //   "assets/compassfix.gif",
                //   height: 120.0,
                //   width: 120.0,
                // ),
                Text(
                  "Your Location: ${widget.lat}, ${widget.long}",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                _bannerAd != null ?
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Colors.transparent,
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ) : SizedBox(),
              ],
            ),
          ],
        );
      },
    );
  }
}

Widget _buildCompass() {
  return StreamBuilder<CompassEvent>(
    stream: FlutterCompass.events,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error reading heading: ${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      }

      double? direction = snapshot.data!.heading;

      // if direction is null, then device does not support this sensor
      // show error message
      if (direction == null) {
        return const Center(
          child: Text("Device does not have sensors !"),
        );
      }

      return Transform.rotate(
        angle: (direction * (pi / 180) * -1),
        child: Image.asset('assets/images/qibla_direction/compass_5.png'),
      );
    },
  );
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
