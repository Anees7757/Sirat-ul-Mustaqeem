import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data.dart';
import '../ad/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AsmaEMuhammad extends StatefulWidget {
  const AsmaEMuhammad({Key? key}) : super(key: key);

  @override
  State<AsmaEMuhammad> createState() => _AsmaEMuhammadState();
}

class _AsmaEMuhammadState extends State<AsmaEMuhammad> {
  bool autoPlay = false;
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
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark),
        title: const Text('Asma e Muhammad SAW',
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
              : const SizedBox(),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  // height: MediaQuery.of(context).size.height * 0.49,
                  height: 380.0,
                  autoPlay: autoPlay,
                  enlargeCenterPage: true,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  scrollDirection: Axis.horizontal,
                ),
                itemCount: AsmaEMuhammadData().names.length,
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
                          "${itemIndex + 1} of 99 names of\nProphet Muhammad SAW",
                          textAlign: TextAlign.center,
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
                              AsmaEMuhammadData().englishNames[itemIndex],
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
                            Text(AsmaEMuhammadData().names[itemIndex],
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                    color: Colors.black,
                                    // fontFamily: GoogleFonts.El_Messiri,
                                    // package: 'google_fonts_arabic',
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.095),
                            Text(
                              AsmaEMuhammadData().meaning[itemIndex],
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
