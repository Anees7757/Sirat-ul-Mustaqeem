import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

class PrayerTime extends StatefulWidget {
  PrayerTimes? pt;
  String? npt;

  PrayerTime({Key? key, required this.pt, required this.npt}) : super(key: key);

  @override
  State<PrayerTime> createState() => _PrayerTimeState();
}

class _PrayerTimeState extends State<PrayerTime> {
  List<String> prayers = [
    'Fajr',
    'Sunrise',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  final List<IconData> _icons = [
    Icons.nights_stay,
    Icons.wb_twilight,
    Icons.sunny,
    Icons.wb_sunny,
    Icons.sunny_snowing,
    Icons.nightlight
  ];

  //${widget.prayerTimes!.fajr}

  List<String>? prayerTimes;

  int i = 0;

  getIndex() {
    while (widget.npt != prayerTimes![i] && i != 5) {
      i++;
    }
    if (widget.npt == prayerTimes![0] ||
        widget.npt ==
            DateFormat("hh : mm a").format(widget.pt!.fajrafter!.toLocal())) {
      return 5;
    } else if(widget.npt == prayerTimes![5]){
      i--;
      return i;
    }
    else {
      i--;
      return i;
    }
  }

  @override
  void initState() {
    prayerTimes = [
      (DateFormat("hh : mm a").format(widget.pt!.fajr!.toLocal())),
      (DateFormat("hh : mm a").format(widget.pt!.sunrise!.toLocal())),
      (DateFormat("hh : mm a").format(widget.pt!.dhuhr!.toLocal())),
      (DateFormat("hh : mm a").format(widget.pt!.asr!.toLocal())),
      (DateFormat("hh : mm a").format(widget.pt!.maghrib!.toLocal())),
      (DateFormat("hh : mm a").format(widget.pt!.isha!.toLocal())),
    ];
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
        title: const Text('Prayers Time',
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
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(15.0),
          //   child: Container(
          //         alignment: Alignment.topCenter,
          //         child: SizedBox(
          //           height: 100,
          //           width: double.infinity,
          //           child: Card(
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(20.0),
          //             ),
          //             color: Colors.teal.shade400,
          //             shadowColor: Colors.teal,
          //             elevation: 10.0,
          //             child: Container(
          //               margin: const EdgeInsets.all(17.0),
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   const Text("Today",
          //                     textAlign: TextAlign.center,
          //                     style: TextStyle(
          //                         color: Colors.white,
          //                         fontSize: 16,
          //                     ),
          //                   ),
          //                   const SizedBox(height: 4),
          //                   Text("${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
          //                     textAlign: TextAlign.center,
          //                     style: const TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 20,
          //                       fontWeight: FontWeight.bold
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          // ),
          Expanded(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: prayers.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 70,
                    child: Card(
                      color: (index == getIndex()) ? Colors.teal : Colors.white,
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                              child: Icon(
                                _icons[index],
                                color: (index != getIndex())
                                    ? Colors.teal
                                    : Colors.white,
                              ),
                            ),
                            Text(
                              prayers[index],
                              style: TextStyle(
                                fontSize: 18,
                                color: (index != getIndex())
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              prayerTimes![index],
                              style: TextStyle(
                                color: (index != getIndex())
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
