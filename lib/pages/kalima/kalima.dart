import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data.dart';
import 'KalimaDetail.dart';

class Kalima extends StatefulWidget {
  const Kalima({Key? key}) : super(key: key);

  @override
  State<Kalima> createState() => _KalimaState();
}

class _KalimaState extends State<Kalima> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark),
        title: const Text('Kalimas',
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
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: ListView.builder(
                itemCount: KalimasData().kalimaTitleEng.length,
                itemBuilder: (context, index) {
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
                            Text(KalimasData().kalimaTitleEng[index],
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                        subtitle: Text(KalimasData().kalimaMean[index],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              letterSpacing: -1,
                            )),
                        trailing: Text(KalimasData().kalimaTitleArabic[index],
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
                                      KalimaDetail(number: index)),
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
    );
  }
}
