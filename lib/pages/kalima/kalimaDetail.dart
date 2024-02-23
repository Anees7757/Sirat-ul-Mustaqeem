import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data.dart';
import 'package:share_plus/share_plus.dart';

// ignore: must_be_immutable
class KalimaDetail extends StatefulWidget {
  int number;

  KalimaDetail({Key? key, required this.number}) : super(key: key);

  @override
  State<KalimaDetail> createState() => _KalimaDetailState();
}

class _KalimaDetailState extends State<KalimaDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).primaryColor,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark),
          title: Text(KalimasData().kalimaTitleEng[widget.number],
              style: const TextStyle(
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
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () async {
                final box = context.findRenderObject() as RenderBox?;

                await Share.share(
                    "Kalima ${KalimasData().kalimaTitleEng[widget.number]}\n\n${KalimasData().KalimasArabic[widget.number]}",
                    sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size);
              },
            ),
            const SizedBox(width: 5),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Card(
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(KalimasData().KalimasArabic[widget.number],
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 31,
                            fontWeight: FontWeight.w500,
                            // fontFamily: ArabicFonts.Lateef,
                            // package: 'google_fonts_arabic',
                          )),
                      // SizedBox(
                      //     width: 200,
                      //     child: const Divider(height: 30, thickness: 2)),
                      // Text(KalimasData().KalimasUrdu[widget.number],
                      //     textDirection: TextDirection.rtl,
                      //     style: TextStyle(
                      //       height: 1.3,
                      //       fontSize: 26,
                      //       color: Colors.grey.shade600,
                      //       fontFamily: ArabicFonts.Amiri,
                      //       package: 'google_fonts_arabic',
                      //     )),
                    ],
                  ),
                ),
              )),
        ));
  }
}
