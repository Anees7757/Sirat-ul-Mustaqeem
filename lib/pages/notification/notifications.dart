import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../quran/audio_player.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification(context) async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        // ignore: prefer_const_constructors
        AndroidInitializationSettings('@drawable/notification_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (notificationResponse.payload != null) {
        debugPrint('notification payload: $payload');
      }
      await Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => SurahAudioPlayer()),
      );
    });

    // AwesomeNotifications().initialize(
    //   // set the icon to null if you want to use the default app icon
    //     'resource://drawable/notification_icon',
    //     [
    //       NotificationChannel(
    //           channelGroupKey: 'basic_channel_group',
    //           channelKey: 'basic_channel',
    //           channelName: 'Basic notifications',
    //           channelDescription: 'Notification channel for basic tests',
    //         importance: NotificationImportance.High,
    //         channelShowBadge: true,
    //       ),
    //     ],
    //     // Channel groups are only visual and are not required
    //     channelGroups: [
    //       NotificationChannelGroup(
    //           channelGroupKey: 'basic_channel_group',
    //           channelGroupName: 'Basic group')
    //     ],
    //     debug: true
    // );
  }

//
  Future<void> showNotification(int id, String title, String body, bool cancel, String channel) async {
    // final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    // return awesomeNotifications.createNotification(
    //     content: NotificationContent(
    //         id: 1,
    //       title: "test",
    //       body: "test body",
    //       channelKey: 'Quran Notifications',
    //         largeIcon: '@drawable/large_icon',
    //     ),
    //     actionButtons: [
    //       NotificationActionButton(
    //         key: "pre",
    //         icon: "skip_previous",
    //         label: "Previous",
    //       ),
    //
    //       NotificationActionButton(
    //         key: "pause",
    //         icon: "pause",
    //         label: "Pause",
    //       ),
    //
    //       NotificationActionButton(
    //         key: "nex",
    //         icon: "skip_next",
    //         label: "Next",
    //       )
    //     ]
    // );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'Islamic Application',
          channel,
          enableVibration: false,
          importance: Importance.max,
          priority: Priority.max,
          icon: '@drawable/notification_icon',
          playSound: false,
          ongoing: true,
          autoCancel: cancel,
          //largeIcon: DrawableResourceAndroidBitmap('large_icon'),
          color: Colors.white,
          // actions: <AndroidNotificationAction>[
          //   AndroidNotificationAction('id_1', 'Previous', titleColor: Colors.grey.shade100,),
          //   AndroidNotificationAction('id_2', player.playing ? 'Pause' : 'Play', titleColor:Colors.grey.shade100),
          //   AndroidNotificationAction('id_3', 'Next', titleColor: Colors.grey.shade100),
          // ],
          //sound: RawResourceAndroidNotificationSound('adhan_madina'),
        ),
      ),
      payload: "navigate"
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
