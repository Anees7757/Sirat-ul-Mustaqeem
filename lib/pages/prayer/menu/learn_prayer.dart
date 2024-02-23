import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/data.dart';

class LearnPrayer extends StatefulWidget {
  const LearnPrayer({Key? key}) : super(key: key);

  @override
  State<LearnPrayer> createState() => _LearnPrayerState();
}

class _LearnPrayerState extends State<LearnPrayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark),
        title: const Text('Learn Prayer',
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
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: PrayerData().prayerMethodImagesLst.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              PrayerData().prayerMethodImagesLst[index],
                              style: const TextStyle(
                                fontSize: 21,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              PrayerData().prayerMethodDetailLst[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            (PrayerData().prayerMethodImagesLst[index] == "Step-12")
                                ? Image.asset("assets/images/prayer/Step-9.jpg")
                                : Image.asset("assets/images/prayer/${PrayerData().prayerMethodImagesLst[index]}.jpg"),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
