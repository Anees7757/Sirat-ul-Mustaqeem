import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'menu/learn_prayer.dart';
import 'menu/prayer_time.dart';
import 'menu/learn_wudu.dart';

class PrayerMenu extends StatefulWidget {
  PrayerTimes? pt;
  String? npt;
  PrayerMenu({Key? key, required this.pt, required this.npt}) : super(key: key);

  @override
  State<PrayerMenu> createState() => _PrayerMenuState();
}

class _PrayerMenuState extends State<PrayerMenu> {

  List<String> titleLst = [
    "Prayers Time",
    "Learn Prayer",
    "Learn Wudu",
  ];

  List<String> iconsUrl = [
    "prayer_time.png",
    "learn_prayer.png",
    "learn_wudu.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark),
        title: const Text('Prayer',
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
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: GridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(titleLst.length, (index) {
            return InkWell(
              onTap: () {
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrayerTime(
                          pt: widget.pt,
                          npt: widget.npt,
                        )),
                  );
                } else if (index == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LearnPrayer()),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LearnWudu()),
                  );
                }
              },
              child: Card(
                elevation: 5,
                color: Colors.teal,
                shadowColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      child: Image.asset(
                        "assets/images/outline_icons/${iconsUrl[index]}",
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      titleLst[index],
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          ),
        ),
      ),
    );
  }
}
