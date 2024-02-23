import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:islamic_application/pages/qibla_direction/qibla_compas.dart';
import 'dart:async';

class QiblaDirection extends StatefulWidget {
  double? lat;
  double? long;

  QiblaDirection({Key? key, required this.lat, required this.long})
      : super(key: key);

  @override
  State<QiblaDirection> createState() => _QiblaDirectionState();
}

class _QiblaDirectionState extends State<QiblaDirection> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  Future<void> _showMyDialog() async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("For better result",
              style: TextStyle(
                  fontWeight: FontWeight.bold
              )),
          content: const Text(
              "Keep away your Phone from metal objects"),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(15.0))),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    Timer.run(() => _showMyDialog());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark),
        title: const Text('Qibla Finder'),
        centerTitle: true,
        elevation: 0.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _deviceSupport,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          }
          if (snapshot.hasData) {
            return QiblaCompass(lat: widget.lat, long: widget.long);
          } else {
            return const Text('Error');
          }
        },
      ),
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     Stack(
      //       children: [
      //         Image.asset("assets/images/qibla_direction/compass_5.png"),
      //         Image.asset("assets/images/qibla_direction/compass_5_k.png"),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
