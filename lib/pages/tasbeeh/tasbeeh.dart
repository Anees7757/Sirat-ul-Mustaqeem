import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_sequence_animator/image_sequence_animator.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import '../../shared_prefs/shared_prefs.dart';
import 'package:just_audio/just_audio.dart';
import '../ad/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Tasbeeh extends StatefulWidget {
  const Tasbeeh({Key? key}) : super(key: key);

  @override
  State<Tasbeeh> createState() => _TasbeehState();
}

class _TasbeehState extends State<Tasbeeh> {
  ImageSequenceAnimatorState? get imageSequenceAnimator =>
      offlineImageSequenceAnimator;
  ImageSequenceAnimatorState? offlineImageSequenceAnimator;

  final bool _useFullPaths = false;
  List<String>? _fullPathsOffline;
  late AudioPlayer player;

  void onOfflineReadyToPlay(ImageSequenceAnimatorState imageSequenceAnimator) {
    offlineImageSequenceAnimator = imageSequenceAnimator;
  }

  void onOfflinePlaying(ImageSequenceAnimatorState imageSequenceAnimator) {
    setState(() {});
  }

  bool _canVibrate = true;
  InterstitialAd? _interstitialAd;
  BannerAd? _bannerAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              this;
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  int counter = 0;
  int total = 0;
  int limit = 33;

  bool isVibrate = false;
  bool isSound = true;
  bool isMute = false;

  @override
  void initState() {
    counter = DataSharedPrefrences.getCounter();
    total = DataSharedPrefrences.getTotal();
    limit = DataSharedPrefrences.getLimit();
    _init();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  IconData _icon() {
    IconData icon = Icons.volume_up;
    if (isVibrate == true) {
    icon = Icons.vibration;
    } else if (isSound == true) {
    icon = Icons.volume_up;
    } else if (isMute == true) {
    icon = Icons.volume_off;
    }
    return icon;
  }

  Future<void> _init() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
      _canVibrate
          ? debugPrint('This device can vibrate')
          : debugPrint('This device cannot vibrate');
    });

    player = AudioPlayer();
    player.setAsset("assets/sound/tasbeeh_sound.mp3");
  }

  @override
  Widget build(BuildContext context) {
    _fullPathsOffline = [];
    for (int i = 1; i < 8; i++) {
      _fullPathsOffline!.add("assets/images/tasbeeh/tasbeeh_$i.png");
    }

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme
                .of(context)
                .primaryColor,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark),
        title: const Text('Tasbeeh Counter'),
        titleSpacing: 0,
        //centerTitle: true,
        elevation: 0.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        actions: [
          IconButton(
            splashRadius: 22,
            onPressed: () async {
              setState(() {
                if (_icon() == Icons.vibration) {
                  isVibrate = false;
                  isSound = true;
                } else if (_icon() == Icons.volume_up) {
                  isSound = false;
                  isMute = true;
                } else if (_icon() == Icons.volume_off) {
                  isMute = false;
                  isVibrate = true;
                }
              });
            },
            icon: Icon(_icon(), size: 24),
            tooltip: (_icon() == Icons.vibration) ?
            'Vibrate' : (_icon() == Icons.volume_up) ?
            'Sound' : 'Mute',
          ),
          GestureDetector(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text("$limit",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900)),
                IconButton(
                  splashRadius: 22,
                  onPressed: () async {
                    setState(() {
                      if (limit == 33) {
                        limit = 99;
                      } else if (limit == 99) {
                        limit = 33;
                      }
                    });
                    await DataSharedPrefrences.setLimit(limit);
                  },
                  icon: const Icon(Icons.circle_outlined, size: 28,),
                  tooltip: 'Limit',
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text(
                          "Reset your current and total tasbeeh counts to zero?"),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(15.0))),
                      actions: [
                        TextButton(
                          child: const Text("CANCEL"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text("RESET"),
                          onPressed: () async {
                            setState(() {
                              counter = 0;
                              total = 0;
                              Navigator.pop(context);
                            });
                            await DataSharedPrefrences.setCounter(counter);
                            await DataSharedPrefrences.setTotal(total);
                            _interstitialAd?.show();
                            _loadInterstitialAd();
                          },
                        ),
                      ],
                    );
                  },
                );
              });
            },
            icon: const Icon(Icons.refresh, size: 24),
            tooltip: 'Reset',
            splashRadius: 22,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () async {
          imageSequenceAnimator!.rewind(from: 5);
          // imageSequenceAnimator!.play(from:5);
          if (isVibrate == true) {
            if (_canVibrate) {
              Vibrate.feedback(FeedbackType.heavy);
            }
          } else if (isSound == true) {
            await player.setAsset("assets/sound/tasbeeh_sound.mp3");
            await player.play();
          } else if (isMute == true) {}
          if (limit == 33) {
            if (counter < 33) {
              counter++;
            } else {
              counter = 1;
              if (_canVibrate) {
                Vibrate.feedback(FeedbackType.heavy);
              }
            }
          } else {
            if (counter < 99) {
              counter++;
            } else {
              counter = 1;
              if (_canVibrate) {
                Vibrate.feedback(FeedbackType.heavy);
              }
            }
          }
          total++;
          await DataSharedPrefrences.setCounter(counter);
          await DataSharedPrefrences.setTotal(total);
          //player.dispose();
          setState(() {
            _loadInterstitialAd();
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 60),
            Text(
              "Total : $total",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Container(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 100,
                  width: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Colors.teal.shade400,
                    shadowColor: Colors.teal,
                    elevation: 10.0,
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$counter",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 39,
                            ),
                          ),
                          Text(
                            "/$limit",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ImageSequenceAnimator(
                "assets/images/tasbeeh", //folderName
                "tasbeeh_", //fileName
                1, //suffixStart
                1, //suffixCount
                "png", //fileFormat
                7,
                fps: 25,
                key: const Key("offline"),
                isLooping: false,
                isOnline: false,
                isBoomerang: false,
                isAutoPlay: false,
                fullPaths: _useFullPaths ? _fullPathsOffline : null,
                onReadyToPlay: onOfflineReadyToPlay,
                onPlaying: onOfflinePlaying,
              ),
            ),
            _bannerAd != null ?
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: Colors.transparent,
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ) : SizedBox(),
          ],
        ),
      ),
    );
  }
}
