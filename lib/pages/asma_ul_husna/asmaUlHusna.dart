import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data.dart';
import 'package:just_audio/just_audio.dart';
import '../ad/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AsmaUlHusna extends StatefulWidget {
  const AsmaUlHusna({Key? key}) : super(key: key);

  @override
  State<AsmaUlHusna> createState() => _AsmaUlHusnaState();
}

class _AsmaUlHusnaState extends State<AsmaUlHusna> {
  bool autoPlay = false;
  late AudioPlayer player;
  BannerAd? _bannerAd;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Narrated Abu Huraira:",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Text(
                    '    Prophet Muhammad SAW said, “Allah has ninety-nine names, i.e. one-hundred minus one, and whoever knows them will go to Paradise.”'),
                SizedBox(height: 10),
                Text('Sahih Bukhari – Hadith 7392',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // player = AudioPlayer();
    // for(int i=1; i<=100; i++) {
    //   player.setAsset("assets/sound/asmaUlHusna/a_$i.mp3");
    // }
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
    Timer.run(() => _showMyDialog());
  }

  // @override
  // void dispose() {
  //   player.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark),
        title: const Text('Asma Ul Husna',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _bannerAd != null
              ? Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Colors.transparent,
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                )
              : SizedBox(),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  //height: MediaQuery.of(context).size.height * 0.49,
                  height: 380.0,
                  autoPlay: autoPlay,
                  enlargeCenterPage: true,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  scrollDirection: Axis.horizontal,
                ),
                itemCount: DataModel().asmaArab.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                        Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    image: const DecorationImage(
                        image: AssetImage("assets/images/background2.jpg"),
                        fit: BoxFit.fill,
                        colorFilter: ColorFilter.mode(
                            Colors.white, BlendMode.softLight)),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 10,
                        color: Colors.grey.shade400,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          itemIndex == 0
                              ? ""
                              : "$itemIndex of 99 names of Allah",
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.09),
                            Text(
                              DataModel().asmaEn[itemIndex],
                              style: GoogleFonts.alata(
                                textStyle: const TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Text(DataModel().asmaArab[itemIndex],
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: Colors.black,
                                    // fontFamily: ArabicFonts.El_Messiri,
                                    // package: 'google_fonts_arabic',
                                    fontSize: DataModel().asmaArab[itemIndex] ==
                                            "اللّٰه"
                                        ? 45
                                        : 32,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.095),
                            Text(
                              DataModel().meaning[itemIndex],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.architectsDaughter(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            if (autoPlay == true) {
              autoPlay = false;
              const snackBar = SnackBar(
                content: Text('AutoPlay OFF'),
                duration: Duration(seconds: 2),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (autoPlay == false) {
              autoPlay = true;
              // for(int i=1; i<=100; i++) {
              //   await player.setAsset("assets/sound/asmaUlHusna/a_$i.mp3");
              // }
              //await player.play();
              const snackBar = SnackBar(
                content: Text('AutoPlay ON'),
                duration: Duration(seconds: 2),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          });
        },
        label: autoPlay ? const Text('Stop') : const Text('Play'),
        icon: Icon(autoPlay ? Icons.stop : Icons.play_arrow),
        foregroundColor: Colors.white,
        backgroundColor: autoPlay ? Colors.red : Colors.green,
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
