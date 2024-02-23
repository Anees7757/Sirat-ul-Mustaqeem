import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran/quran.dart' as quran;

class JuzDetail extends StatefulWidget {
  final int juzNumber;

  JuzDetail({Key? key, required this.juzNumber}) : super(key: key);

  @override
  State<JuzDetail> createState() => _JuzDetailState();
}

class _JuzDetailState extends State<JuzDetail> {
  List<int> ayahNumbers = [];

  @override
  void initState() {
    super.initState();
    ayahNumbers = quran
        .getSurahAndVersesFromJuz(widget.juzNumber)
        .values
        .expand((numbers) => numbers)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).primaryColor,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Al-Quran",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: quran.totalPagesCount,
              itemBuilder: (context, index) {
                // final ayahNumber = ayahNumbers[index + 1];
                print(quran.getVersesTextByPage(index));
                // final verseText = quran.getVerse(
                //   quran
                //       .getSurahAndVersesFromJuz(widget.juzNumber)
                //       .keys
                //       .elementAt(index + 1),
                //   ayahNumber,
                // );

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Text(
                    quran.getVersesTextByPage(index)[0],
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
