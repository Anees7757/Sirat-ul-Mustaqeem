// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:share_plus/share_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../audio_player.dart';
import 'surah.dart';

class SurahDetail extends StatefulWidget {
  int number;

  SurahDetail({Key? key, required this.number}) : super(key: key);

  @override
  State<SurahDetail> createState() => _SurahDetailState();
}

class _SurahDetailState extends State<SurahDetail> {
  bool isBookmark = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  TextEditingController ayahNumberIndex = TextEditingController();
  int Pindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        title: const Text("Al-Quran",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            )),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.directions_outlined),
          //   tooltip: 'Goto',
          //   splashRadius: 20,
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return Dialog(
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(20),
          //           ),
          //           child: Container(
          //             padding: const EdgeInsets.all(20),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(20),
          //               color: Colors.white,
          //             ),
          //             child: Column(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 TextField(
          //                   autofocus: true,
          //                   controller: ayahNumberIndex,
          //                   keyboardType: TextInputType.number,
          //                   decoration: InputDecoration(
          //                     border: OutlineInputBorder(
          //                       borderRadius: BorderRadius.circular(
          //                           20), // Set the border radius here
          //                       borderSide: BorderSide.none,
          //                     ),
          //                     contentPadding:
          //                         const EdgeInsets.only(left: 15.0, top: 12),
          //                     hintText: 'Enter Ayah number',
          //                     filled: true,
          //                     fillColor: Colors.grey[
          //                         200], // Customize the fill color as needed
          //                   ),
          //                 ),
          //                 const SizedBox(height: 10),
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.end,
          //                   children: [
          //                     TextButton(
          //                       child: const Text("CANCEL"),
          //                       onPressed: () {
          //                         Navigator.pop(context);
          //                       },
          //                     ),
          //                     TextButton(
          //                       child: const Text("Go"),
          //                       onPressed: () async {
          //                         await _scrollController.animateTo(
          //                           (int.parse(ayahNumberIndex.text)) *
          //                               quran
          //                                   .getVerseCount(widget.number + 1)
          //                                   .toDouble(),
          //                           duration: const Duration(seconds: 1),
          //                           curve: Curves.bounceInOut,
          //                         );
          //                         Navigator.pop(context);
          //                         ayahNumberIndex.clear();
          //                       },
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       },
          //     );
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.play_arrow_outlined, size: 35),
            tooltip: 'Play',
            splashRadius: 20,
            onPressed: () async {
              await InternetConnectionChecker().hasConnection
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SurahAudioPlayer(surahNumber: widget.number + 1)),
                    )
                  : showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Internet Error"),
                          content: const Text(
                              "Make sure you're connected to the internet"),
                          actions: [
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
            },
          ),
          // IconButton(
          //     icon: Icon(isBookmark == true ? Icons.bookmark : Icons.bookmark_outline),
          //     onPressed: () async {
          //       if (isBookmark == true) {
          //         isBookmark = false;
          //         //await DataSharedPrefrences.setBookmark(isBookmark);
          //         //icon = Icons.bookmark_outline;
          //         //int index = 0;
          //         // if(!bookmarkList[index].contains("${widget.number + 1}")){
          //         bookmarkList.remove(widget.number+1);
          //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //           content: Text("Surah ${quran.getSurahNameEnglish(widget.number+1)} removed from Bookmark"),
          //         ))
          //          }
          //       } else {
          //         isBookmark = true;
          //         //await DataSharedPrefrences.setBookmark(isBookmark);
          //        // icon = Icons.bookmark;
          //         // int index = 0;
          //         // bool isFound = false;
          //         // while (index < bookmarkList.length) {
          //         //   if (int.parse(bookmarkList[index]) == widget.number + 1) {
          //         //     isFound = true;
          //         //   }
          //         //   index++;
          //         // }
          //         // if (isFound == false) {
          //           bookmarkList.add((widget.number += 1) as String);
          //
          //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //           content: Text("Surah ${quran.getSurahNameEnglish(widget.number+1)} Bookmarked"),
          //         ));
          //           // await DataSharedPrefrences.setBookmarkList(bookmarkList);
          //       //   }
          //        }
          //     }),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share',
            splashRadius: 20,
            onPressed: () async {
              final box = context.findRenderObject() as RenderBox?;

              await Share.share(
                  "Surah ${quran.getSurahName(widget.number + 1)}\n\nLink:\n${quran.getSurahURL(widget.number + 1)}\n\nAudio Link:\n${quran.getAudioURLBySurah(widget.number + 1)}",
                  sharePositionOrigin:
                      box!.localToGlobal(Offset.zero) & box.size);
            },
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.teal.shade400,
                        shadowColor: Colors.teal,
                        elevation: 10.0,
                        child: Container(
                          margin: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                quran.getSurahNameArabic(widget.number + 1),
                                textDirection: TextDirection.rtl,
                                style: GoogleFonts.reemKufi(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: SizedBox(
                  //     height: 100,
                  //     child: Image.asset(
                  //       "assets/images/outline_icons/quran.png",
                  //       color: Colors.teal.shade500,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            ((widget.number + 1) != 1 && (widget.number + 1) != 9 && Pindex > 3)
                ? const SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 1,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(quran.basmala,
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 28,
                              fontFamily: 'Uthmanic',
                            )),
                      ),
                    ),
                  )
                : const SizedBox(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: quran.getVerseCount(widget.number + 1),
                itemBuilder: (context, index) {
                  Pindex = index;
                  return Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: quran.getVerse(
                                        widget.number + 1, index + 1),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 28,
                                      color: Color.fromARGB(255, 36, 26, 26),
                                      fontFamily: 'Uthmanic',
                                    ),
                                  ),
                                  quran.isSajdahVerse(
                                          widget.number + 1, index + 1)
                                      ? WidgetSpan(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, right: 5),
                                            child: Text(
                                              quran.sajdah,
                                              textDirection: TextDirection.rtl,
                                              style: GoogleFonts.amiri(
                                                  textStyle: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.red,
                                                fontWeight: FontWeight.w800,
                                              )),
                                            ),
                                          ),
                                        )
                                      : TextSpan(),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                quran.getVerseTranslation(
                                    widget.number + 1, index + 1),
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 15,
                                )),
                          ),
                          const SizedBox(height: 35),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SizedBox(
                              //   width: MediaQuery.of(context).size.width * 0.26, //100
                              //   child: const Divider(color: Colors.grey),
                              // ),
                              // const SizedBox(width: 12),
                              Text(
                                "${index + 1} آية نمبر",
                                style: GoogleFonts.amiri(),
                              ),
                              //const SizedBox(width: 12),
                              // SizedBox(
                              //   width: MediaQuery.of(context).size.width * 0.26, //100
                              //   child: const Divider(color: Colors.grey),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Row(
                          //   children: [
                          //     IconButton(
                          //       splashRadius: 20,
                          //       icon: Icon(Icons.volume_up,
                          //           color: Colors.grey.shade600),
                          //       onPressed: () async {
                          //         await InternetConnectionChecker()
                          //                 .hasConnection
                          //             ? {
                          //                 await player.setUrl(
                          //                     quran.getAudioURLByVerse(
                          //                         widget.number + 1, index + 1)),
                          //                 await player.play()
                          //               }
                          //             : showDialog(
                          //                 context: context,
                          //                 builder: (BuildContext context) {
                          //                   return AlertDialog(
                          //                     title:
                          //                         const Text("Internet Error"),
                          //                     content: const Text(
                          //                         "Make sure you're connected to the internet"),
                          //                     actions: [
                          //                       TextButton(
                          //                         child: const Text("OK"),
                          //                         onPressed: () {
                          //                           Navigator.pop(context);
                          //                         },
                          //                       ),
                          //                     ],
                          //                   );
                          //                 },
                          //               );
                          //       },
                          //     ),
                          //     IconButton(
                          //       splashRadius: 20,
                          //       icon: Icon(Icons.share,
                          //           color: Colors.grey.shade600),
                          //       onPressed: () async {
                          //         final box =
                          //             context.findRenderObject() as RenderBox?;
                          //
                          //         await Share.share(
                          //             "Surah ${quran.getSurahName(widget.number + 1)}\n${quran.getVerse(widget.number + 1, index + 1)}\n${quran.getVerseTranslation(widget.number + 1, index + 1)}",
                          //             sharePositionOrigin:
                          //                 box!.localToGlobal(Offset.zero) &
                          //                     box.size);
                          //       },
                          //     ),
                          //     Text("${quran.getVerseCount(widget.number+1)} : ${index+1}",
                          //         textAlign: TextAlign.start,
                          //         style: TextStyle(
                          //           color: Colors.grey.shade800,
                          //           fontWeight: FontWeight.w600,
                          //           fontSize: 13,
                          //         )),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class Detail {
//   Widget surahDetails(int widget.number, BuildContext context) {
//
//   }
// }
