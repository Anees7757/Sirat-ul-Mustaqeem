import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bookmark.dart';
import 'surah/surah.dart';
import 'surah/juz.dart';

class Quran extends StatefulWidget {
  const Quran({Key? key}) : super(key: key);

  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).primaryColor,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark),
          title: const Text('Al-Quran',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Comfortaa',
              )),
          // actions: [
          //   IconButton(
          //       icon: const Icon(Icons.bookmarks),
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => const Bookmark()),
          //         );
          //       }),
          // ],
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          bottom: const TabBar(
            indicatorWeight: 4,
            indicatorPadding: EdgeInsets.only(left: 20, right: 20),
            tabs: [
              Tab(text: "Surah"),
              Tab(text: "Parah"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Surah(),
            Juz(),
          ],
        ),
      ),
    );
  }
}
