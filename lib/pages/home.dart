import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:islamic_application/pages/asma_ul_husna/asmaUlHusna.dart';
import 'package:islamic_application/pages/prayer/menu/prayer_time.dart';
import 'package:islamic_application/pages/qibla_direction/qibla_direction.dart';
import 'package:islamic_application/pages/quran/quran.dart';
import 'package:islamic_application/pages/settings/settings.dart';
import 'package:islamic_application/pages/tasbeeh/tasbeeh.dart';
import 'package:islamic_application/shared_prefs/shared_prefs.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'kalima/kalima.dart';
import '../pages/prayer/prayer.dart';
import '../pages/asma_ul_husna/data.dart';
import 'package:islamic_application/pages/asma_e_muhammad/asmaeMuhammad.dart';
import '../pages/asma_e_muhammad/data.dart';
import 'mosque_locator/mosque_locate.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad/ad_helper.dart';
import 'package:quran/quran.dart' as quran;
import '/pages/notification/notifications.dart';

Coordinates? _currentPosition;
String? _currentAddress;

List<dynamic> prayerTimeCon = [
  CalculationMethod.MuslimWorldLeague(),
  CalculationMethod.Karachi(),
  CalculationMethod.Dubai(),
  CalculationMethod.Egyptian(),
  CalculationMethod.Kuwait(),
  CalculationMethod.MoonsightingCommittee(),
  CalculationMethod.Morocco(),
  CalculationMethod.NorthAmerica(),
  CalculationMethod.Qatar(),
  CalculationMethod.Singapore(),
  CalculationMethod.Tehran(),
  CalculationMethod.Turkey(),
  CalculationMethod.UmmAlQura(),
  CalculationMethod.Other(),
];

CalculationParameters params = prayerTimeCon[0];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InterstitialAd? _interstitialAd;
  BannerAd? _bannerAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const Tasbeeh()),
              // );
              _loadInterstitialAd();
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  List<String> imagesUrl = [
    'allah_wrtn.png',
    'muhammad_wrtn.png',
    'qibla-direction.png',
    'quran.png',
    'kalima.png',
    'tasbeeh.png',
    'prayer.png',
    'mosque.png',
    'settings.png'
  ];

  List<String> titleList = [
    'Asma ul\nHusna',
    'Asma e\nMuhammad',
    'Qibla\nCompass',
    'Al Quran',
    'Kalima',
    'Tasbeeh',
    'Prayer',
    'Mosque\nLocator',
    'Settings'
  ];

  String randomAyat = "";
  int surahNumber = Random().nextInt(114);

  final _today = HijriCalendar.now();

  final Geolocator geolocator = Geolocator();

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      setState(() {
        _currentPosition = Coordinates(position.latitude, position.longitude);
      });
      await DataSharedPrefrences.setCurrentLocation(
          "${_currentPosition?.latitude},${_currentPosition?.longitude}");
      prayerTimeSet(_currentPosition?.latitude, _currentPosition?.longitude);
      await _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress = "${place.locality}";
      });
      await DataSharedPrefrences.setCurrentAddress(_currentAddress!);
    } catch (e) {
      print(e);
    }
  }

  Coordinates? coordinates;

  DateTime date = DateTime.now();

  PrayerTimes? _prayerTimes;
  String? current;
  String? next;
  DateTime? nextPrayerTime;

  //int verseNumber = Random().nextInt(286);
  int randomAsmaulHusna = 0;

  String? _nptime;

  bool isLocationEnabled = false;

  Future locationCheck() async {
    isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    print(isLocationEnabled);
  }

  bool isFirstTime = true;

  @override
  void initState() {
    params = prayerTimeCon[DataSharedPrefrences.getPrayerTC()];
    if (DataSharedPrefrences.getAsrTC() == "SHAFI") {
      params.madhab = Madhab.Shafi;
    } else {
      params.madhab = Madhab.Hanafi;
    }

    while (DataModel().asmaEn[randomAsmaulHusna].length > 12 ||
        randomAsmaulHusna == 0) {
      randomAsmaulHusna = Random().nextInt(99);
    }
    // while (surahNumber <= 0) {
    //   surahNumber = Random().nextInt(114);
    // }
    // while (verseNumber > quran.getVerseCount(surahNumber) || verseNumber <= 0) {
    //   verseNumber = Random().nextInt(286);
    // }
    // randomAyat = quran.getVerse(surahNumber, verseNumber);
    //
    // NotificationService().showNotification(
    //     1,
    //     "Ayah of the Moment",
    //     "$randomAyat\nSurah ${quran.getSurahName(surahNumber)}", true, 'Ayat of the Moment');

    isFirstTime = DataSharedPrefrences.getIsFirstTime();

    locationCheck();

    if (isLocationEnabled == true) {
      DataSharedPrefrences.setIsFirstTime(true);
    }

    if (isFirstTime == false) {
      if (DataSharedPrefrences.getCurrentLocation() != "" &&
          DataSharedPrefrences.getCurrentAddress() != "") {
        List<String> lst = DataSharedPrefrences.getCurrentLocation().split(',');

        _currentPosition =
            Coordinates(double.parse(lst[0]), double.parse(lst[1]));
        _currentAddress = DataSharedPrefrences.getCurrentAddress();
        prayerTimeSet(double.parse(lst[0]), double.parse(lst[1]));
      }
    } else {
      if (_currentAddress == null && _currentPosition == null) {
        _getCurrentLocation();
        DataSharedPrefrences.setIsFirstTime(false);
      }
    }

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
    _loadInterstitialAd();
    super.initState();
  }

  void prayerTimeSet(dynamic lat, dynamic long) {
    setState(() {
      coordinates = Coordinates(lat, long);

      _prayerTimes = PrayerTimes(coordinates!, date, params, precision: true);

      current = _prayerTimes!.currentPrayer(date: DateTime.now());

      next = _prayerTimes!.nextPrayer();

      nextPrayerTime = _prayerTimes!.timeForPrayer(next!);

      _nptime = DateFormat("hh : mm a").format(nextPrayerTime!.toLocal());

      if (next!.toUpperCase() == "FAJRAFTER") {
        next = "FAJR";
      } else if (next!.toUpperCase() == "ISHABEFORE") {
        next = "ISHA";
      } else if (current!.toUpperCase() == "FAJRAFTER") {
        current = "FAJR";
      } else if (current!.toUpperCase() == "ISHABEFORE") {
        next = "ISHA";
      }

      //Time hour = _prayerTimes!.timeForPrayer(current!)!.hour as Time;

      // String currentPrayer = DateFormat("h : mm a").format(_prayerTimes!.timeForPrayer(current!)!.toLocal());

      // NotificationService().showNotification(1,
      //     '${current!.toUpperCase()} Time', "Don't forget us in your Prayers");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).primaryColor,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 220,
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                            Colors.teal, BlendMode.multiply),
                        child: Image.asset(
                          "assets/images/mosque.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: Text("${_today.hDay}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text(_today.toFormat("MMMM, yyyy"),
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 15, 0),
                    child: Column(
                      children: [
                        const Align(
                            alignment: Alignment.topRight,
                            child: Text("Now",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12))),
                        Align(
                            alignment: Alignment.topRight,
                            child: Text("${current?.toUpperCase()}",
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                        const SizedBox(height: 28),
                        const Align(
                            alignment: Alignment.topRight,
                            child: Text("Upcoming",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Container(
                            //   height: 30,
                            //   width: 110,
                            //   decoration: BoxDecoration(
                            //     color: Colors.white70,
                            //     borderRadius: BorderRadius.circular(50.0),
                            //   ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.white),
                                if (_currentPosition != null &&
                                    _currentAddress != null)
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Text("$_currentAddress",
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14))),
                              ],
                            ),
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PrayerTime(
                                                pt: _prayerTimes,
                                                npt: _nptime,
                                              )),
                                    );
                                  },
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(next!.toUpperCase(),
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16))),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PrayerTime(
                                                pt: _prayerTimes,
                                                npt: _nptime,
                                              )),
                                    );
                                  },
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text("$_nptime",
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    margin: const EdgeInsets.fromLTRB(15, 170, 15, 0),
                    height: 360,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 10,
                          color: Colors.grey.shade400,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: GridView.count(
                      padding: EdgeInsets.zero,
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 1,
                      childAspectRatio: 0.91,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(titleList.length, (index) {
                        return InkWell(
                          onTap: () async {
                            if (index == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AsmaUlHusna()),
                              );
                            } else if (index == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AsmaEMuhammad()),
                              );
                            } else if (index == 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QiblaDirection(
                                        lat: _currentPosition!.latitude,
                                        long: _currentPosition!.longitude)),
                              );
                            } else if (index == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Quran()),
                              );
                            } else if (index == 4) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Kalima()),
                              );
                            } else if (index == 5) {
                              _interstitialAd?.show();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Tasbeeh()),
                              );
                            } else if (index == 6) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PrayerMenu(
                                          pt: _prayerTimes,
                                          npt: _nptime,
                                        )),
                              );
                            } else if (index == 7) {
                              await InternetConnectionChecker().hasConnection
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MosqueLocator(
                                              lat: _currentPosition!.latitude,
                                              long:
                                                  _currentPosition!.longitude)),
                                    )
                                  : showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Internet Error"),
                                          content: const Text(
                                              "Make sure you're connected to the internet"),
                                          actions: [
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
                            } else if (index == 8) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Settings(location: _currentAddress)),
                              );
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 60,
                                width: 70,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Image.asset(
                                  "assets/images/filled_icons/${imagesUrl[index]}",
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                titleList[index],
                                style: const TextStyle(
                                    height: 0.95,
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 15),
              // Row(mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       height: 10,
              //       width: 10,
              //       decoration: BoxDecoration(
              //         color: Colors.teal,
              //         borderRadius: BorderRadius.circular(50),
              //       ),
              //     ),
              //     SizedBox(width: 5),
              //     Container(
              //       height: 10,
              //       width: 10,
              //       decoration: BoxDecoration(
              //         color: Colors.teal.shade100,
              //         borderRadius: BorderRadius.circular(50),
              //       ),
              //     ),
              //   ],
              //),
              Container(
                margin: const EdgeInsets.fromLTRB(25, 25, 20, 0),
                child: Row(
                  children: [
                    const Text("Asma ul Husna"),
                    const SizedBox(width: 7),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.26, //100
                      child: const Divider(color: Colors.black),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AsmaUlHusna()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 0,
                        blurRadius: 10,
                        color: Colors.grey.shade400,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(15),
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 100,
                          width: 100,
                          child: Center(
                            child: Text(
                              DataModel().asmaArab[randomAsmaulHusna],
                              // textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.reemKufi(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DataModel().asmaEn[randomAsmaulHusna],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 2),
                          SizedBox(
                            width: 220,
                            child: Text(
                              DataModel().meaning[randomAsmaulHusna],
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(25, 5, 20, 0),
                child: Row(
                  children: [
                    const Text("Asma e Muhammad SAW"),
                    const SizedBox(width: 7),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.26, //100
                      child: const Divider(color: Colors.black),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AsmaEMuhammad()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 0,
                        blurRadius: 10,
                        color: Colors.grey.shade400,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(15),
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 100,
                          width: 100,
                          child: Center(
                            child: Text(
                              AsmaEMuhammadData().names[randomAsmaulHusna],
                              // textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.reemKufi(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AsmaEMuhammadData().englishNames[randomAsmaulHusna],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 2),
                          SizedBox(
                            width: 220,
                            child: Text(
                              AsmaEMuhammadData().meaning[randomAsmaulHusna],
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
