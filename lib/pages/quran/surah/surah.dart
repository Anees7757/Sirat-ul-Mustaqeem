import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;

import '../../../shared_prefs/shared_prefs.dart';
import 'surahDetail.dart';

List<String> bookmarkList = [];
List<int> surahNumberList = [];

class Surah extends StatefulWidget {
  const Surah({Key? key}) : super(key: key);

  @override
  State<Surah> createState() => _SurahState();
}

class _SurahState extends State<Surah> {
  bool _showBackToTopButton = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _showBackToTopButton = _scrollController.offset >= 400;
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

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: TextField(
              autofocus: false,
              controller: _searchController,
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 15.0, top: 12),
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Search by name/number',
                suffixIcon: GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  child: const Icon(Icons.close),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: quran.totalSurahCount,
                itemBuilder: (context, index) {
                  String surahName = quran.getSurahName(index + 1);
                  String surahNumber = (index + 1).toString();

                  // Check if the search query matches the surah name or number
                  bool matchesSearch = surahName
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()) ||
                      surahNumber.contains(_searchController.text);

                  // Display only the surahs that match the search query
                  if (_searchController.text.isEmpty || matchesSearch) {
                    return Column(
                      children: [
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
                              Text(surahName,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                          subtitle: Text(
                              "${quran.getPlaceOfRevelation(index + 1)} - Verses: ${quran.getVerseCount(index + 1)}",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                letterSpacing: -1,
                              )),
                          trailing: Text(
                            quran.getSurahNameArabic(index + 1),
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
                  } else {
                    // Return an empty container for surahs that do not match the search query
                    return Container();
                  }
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
