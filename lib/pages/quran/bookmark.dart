// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran/quran.dart' as quran;

import '../../../shared_prefs/shared_prefs.dart';
import 'surah/surah.dart';
import 'surah/surahDetail.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({Key? key}) : super(key: key);

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  bool _showBackToTopButton = false;

  late ScrollController _scrollController;

  @override
  void initState() {
    bookmarkList = DataSharedPrefrences.getBookmarkList();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            _showBackToTopButton = true;
          } else {
            _showBackToTopButton = false;
          }
        });
      });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 3), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark),
        title: const Text('Bookmarks',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Comfortaa',
            )),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
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
      body: bookmarkList.isEmpty
          ? const Center(child: Text("Nothing to show here"))
          : Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: bookmarkList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              leading: Container(
                                height: 43,
                                width: 43,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("${bookmarkList[index]}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Comfortaa',
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                      "${quran.getSurahName(bookmarkList[index] as int)}",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Comfortaa',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                              subtitle: Text(
                                  "${quran.getPlaceOfRevelation(bookmarkList[index] as int)} - Verses: ${quran.getVerseCount(bookmarkList[index] as int)}",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Comfortaa',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -1,
                                  )),
                              trailing: Text(
                                  "${quran.getSurahNameArabic(bookmarkList[index] as int)}",
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    // fontFamily: ArabicFonts.Amiri,
                                    // package: 'google_fonts_arabic',
                                    fontWeight: FontWeight.w800,
                                  )),
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SurahDetail(number: index)),
                                  );
                                });
                              },
                              dense: true,
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton.small(
              onPressed: _scrollToTop,
              child: const Icon(Icons.keyboard_arrow_up),
            ),
    );
  }
}
