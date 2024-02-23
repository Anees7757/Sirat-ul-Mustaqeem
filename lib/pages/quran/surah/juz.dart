import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'data.dart';
import '../../../shared_prefs/shared_prefs.dart';
import 'juzDetail.dart';

List<String> bookmarkList = [];
List<int> surahNumberList = [];

class Juz extends StatefulWidget {
  const Juz({Key? key}) : super(key: key);

  @override
  State<Juz> createState() => _JuzState();
}

class _JuzState extends State<Juz> {
  bool _showBackToTopButton = false;

  late ScrollController _scrollController;

  @override
  void initState() {
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
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    int getverseCountByJuz(int juz) {
      Map<int, List<int>> data = quran.getSurahAndVersesFromJuz(juz);
      int totalVerses = 0;

      data.values.forEach((verses) {
        int start = verses[0];
        int end = verses[1];
        totalVerses += end - start + 1;
      });
      return totalVerses;
    }

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: quran.totalJuzCount,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(height: 5),
                      ListTile(
                        leading: Stack(
                          children: [
                            RotationTransition(
                              turns: const AlwaysStoppedAnimation(45 / 360),
                              child: Container(
                                height: 39,
                                width: 39,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: Colors.black, width: 1.5),
                                ),
                              ),
                            ),
                            Container(
                              height: 39,
                              width: 39,
                              decoration: const BoxDecoration(
                                color: Colors.teal,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text("${index + 1}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        title: Row(
                          children: [
                            Text(JuzData().JuzEnglish[index],
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                        subtitle:
                            Text("Verses: ${getverseCountByJuz(index + 1)}",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  letterSpacing: -1,
                                )),
                        trailing: Text(
                          JuzData().JuzArabic[index],
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.amiri(
                            textStyle: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JuzDetail(
                                        juzNumber: index + 1,
                                      )),
                            );
                          });
                        },
                        dense: true,
                      ),
                      const SizedBox(height: 5),
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
