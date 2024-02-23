import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'shared_prefs/shared_prefs.dart';
import '/pages/notification/notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataSharedPrefrences.init();
  NotificationService().initNotification(BuildContext);
  MobileAds.instance.initialize();

  runApp(BetterFeedback(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Islamic Application',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.teal,
      ),
      home: const HomePage(),
    );
  }
}
