import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/data.dart';

class LearnWudu extends StatefulWidget {
  const LearnWudu({Key? key}) : super(key: key);

  @override
  State<LearnWudu> createState() => _LearnWuduState();
}

class _LearnWuduState extends State<LearnWudu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark),
        title: const Text('Learn Wudu',
            style: TextStyle(
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
      ),
      body: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: wuduData().wudu_stepsLst.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              "Step ${index+1}:",
                              style: const TextStyle(
                                fontSize: 21,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              wuduData().wudu_stepsLst[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                                child: Image.asset("assets/images/wudu_steps/${index+1}.jpeg")),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
