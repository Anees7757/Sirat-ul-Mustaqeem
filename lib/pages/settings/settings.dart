// ignore_for_file: use_build_context_synchronously

import 'package:adhan_dart/adhan_dart.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamic_application/pages/notification/notifications.dart';
import 'package:share_plus/share_plus.dart';
import '../../shared_prefs/shared_prefs.dart';
import '../home.dart';

class Settings extends StatefulWidget {
  String? location;

  Settings({Key? key, required this.location}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSwitched = false;

  List<String> ptCon = [
    'Muslim World League',
    'Karachi',
    'Dubai',
    'Egyptian',
    'Kuwait',
    'Moon Sighting Committee',
    'Morocco',
    'North America',
    'Qatar',
    'Singapore',
    'Tehran',
    'Turkey',
    'Umm Al Qura',
    'Other',
  ];

  List<String> atCal = [
    'HANFI',
    'SHAFI',
  ];

  int? value;
  String atc = "HANAFI";
  int ptc = 0;

  @override
  void initState() {
    atc = DataSharedPrefrences.getAsrTC();
    ptc = DataSharedPrefrences.getPrayerTC();
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
        title: const Text('Settings',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Comfortaa',
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
          ListTile(
            leading: const SizedBox(),
            title: const Text("Location"),
            subtitle: Text(widget.location!),
          ),
          ListTile(
              leading: const SizedBox(),
              title: const Text("Prayer Time Conventions"),
              subtitle: Text(ptCon[ptc]),
              onTap: () {
                setState(() {
                  int selectedRadio = DataSharedPrefrences.getPrayerTC();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          content: StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List<Widget>.generate(ptCon.length,
                                      (int index) {
                                    return RadioListTile(
                                      activeColor: Colors.teal,
                                      value: index,
                                      groupValue: selectedRadio,
                                      onChanged: (value) => setState(
                                          () => selectedRadio = value as int),
                                      title: Text(ptCon[index]),
                                    );
                                  }),
                                ),
                              );
                            },
                          ),
                          actions: [
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () async {
                                params = prayerTimeCon[selectedRadio];
                                await DataSharedPrefrences.setPrayerTC(
                                    selectedRadio);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Settings Updated"),
                                ));
                              },
                            ),
                          ],
                        );
                      }).then((_) => setState(() {}));
                });
              }),
          ListTile(
            leading: const SizedBox(),
            title: const Text("Asr Time Calculation"),
            subtitle: Text(atc),
            onTap: () {
              setState(() {
                showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      int selectedRadio =
                          DataSharedPrefrences.getAsrTC() == "HANFI" ? 0 : 1;
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List<Widget>.generate(atCal.length,
                                  (int index) {
                                return RadioListTile(
                                  title: Text(atCal[index]),
                                  activeColor: Colors.teal,
                                  value: index,
                                  groupValue: selectedRadio,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRadio = value as int;
                                      atc = atCal[selectedRadio];
                                    });
                                  },
                                );
                              }),
                            );
                          },
                        ),
                        actions: [
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () async {
                              if (atc == "SHAFI") {
                                params.madhab = Madhab.Shafi;
                              } else {
                                params.madhab = Madhab.Hanafi;
                              }
                              await DataSharedPrefrences.setAsrTC(atc);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Settings updated"),
                              ));
                            },
                          ),
                        ],
                      );
                    }).then((_) => setState(() {}));
              });
            },
          ),
          ListTile(
            leading: const SizedBox(),
            title: const Text("Feedback"),
            subtitle: const Text("Tell us how your experience is going?"),
            onTap: () {
              // BetterFeedback.of(context).show((UserFeedback feedback) async {
              // });
              setState(() {});
            },
          ),
          ListTile(
            leading: const SizedBox(),
            title: const Text("Share"),
            onTap: () async {
              final box = context.findRenderObject() as RenderBox?;

              await Share.share(
                  "Sirat ul Mustqeem is an Islamic Application with having features Quran, Prayer Times, Qibla Locator, Mosque Locator, and much more.\nDownload now\n",
                  sharePositionOrigin:
                      box!.localToGlobal(Offset.zero) & box.size);
            },
          ),
          // ListTile(
          //   leading: const SizedBox(),
          //   title: const Text("Notifications"),
          //   trailing: Switch(
          //     value: isSwitched,
          //     onChanged: (value) async {
          //       setState(() {
          //         isSwitched = value;
          //         if (isSwitched == true) {
          //           NotificationService().initNotification();
          //           showDialog(
          //             context: context,
          //             builder: (BuildContext context) {
          //               return AlertDialog(
          //                 content: const Text(
          //                     "This will only turn on Prayer Time Notifications!"),
          //                 actions: [
          //                   TextButton(
          //                     child: const Text("OK"),
          //                     onPressed: () {
          //                       Navigator.pop(context);
          //                     },
          //                   ),
          //                 ],
          //               );
          //             },
          //           );
          //         } else {
          //           NotificationService().cancelAllNotifications();
          //         }
          //       });
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
