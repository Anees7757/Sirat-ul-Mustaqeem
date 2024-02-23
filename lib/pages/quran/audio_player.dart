import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran/quran.dart' as quran;
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '/pages/notification/notifications.dart';
import '../ad/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

late AudioPlayer player;
late String url;
int? s;

class SurahAudioPlayer extends StatefulWidget {
  int? surahNumber;

  SurahAudioPlayer({Key? key, this.surahNumber}) : super(key: key);

  @override
  State<SurahAudioPlayer> createState() => _SurahAudioPlayerState();
}

class _SurahAudioPlayerState extends State<SurahAudioPlayer> {
  late final PageManager _pageManager;

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

  @override
  void initState() {
    url = quran.getAudioURLBySurah(widget.surahNumber!);
    _pageManager = PageManager();
    _pageManager.buttonNotifier.value = ButtonState.loading;
    s = widget.surahNumber!;
    _loadInterstitialAd();
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
    _pageManager.dispose();
    NotificationService().cancelAllNotifications();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Now Playing',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Comfortaa',
            )),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark),
        elevation: 0,
        backgroundColor: Colors.teal,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        actions: [
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.cloud_download),
            onPressed: () {},
          ),
          const SizedBox(width: 5),
        ],
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.ac_unit),
        //     onPressed:(){
        //       NotificationService().showNotification(
        //           1, "Now Playing • Surah ${quran.getSurahName(s!)}", "Mashary Rashid Al-Afassy");
        //     },
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.access_alarm),
        //     onPressed:(){
        //       NotificationService().cancelAllNotifications();
        //     },
        //   ),
        // ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            SizedBox(
              height: 270,
              width: 270,
              child: CircleAvatar(
                child: Card(
                  elevation: 15,
                  shadowColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Image.asset("assets/images/player_image2.jpg",
                      fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Text(
              quran.getSurahName(widget.surahNumber!),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
            const Text(
              "Mashary Rashid Al-Afassy",
            ),
            const SizedBox(height: 15),
            ValueListenableBuilder<ProgressBarState>(
              valueListenable: _pageManager.progressNotifier,
              builder: (_, value, __) {
                return ProgressBar(
                  onSeek: _pageManager.seek,
                  progress: value.current,
                  buffered: value.buffered,
                  total: value.total,
                  thumbRadius: 7,
                  barHeight: 4,
                  thumbGlowRadius: 20,
                );
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  splashRadius: 30,
                  icon: Icon(Icons.skip_previous,
                      size: 35,
                      color:
                          widget.surahNumber != 1 ? Colors.black : Colors.grey),
                  onPressed: () async {
                    if (widget.surahNumber! > 1) {
                      setState(() {
                        player.stop();
                        _pageManager.dispose();
                        url = quran.getAudioURLBySurah(widget.surahNumber!);
                        _pageManager._init();
                        _pageManager.buttonNotifier.value = ButtonState.loading;
                        widget.surahNumber = widget.surahNumber! - 1;
                      });
                      _interstitialAd?.show();
                      _loadInterstitialAd();
                    }
                  },
                ),
                const SizedBox(width: 10),
                Container(
                  height: 55,
                  width: 55,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal,
                  ),
                  child: ValueListenableBuilder<ButtonState>(
                    valueListenable: _pageManager.buttonNotifier,
                    builder: (_, value, __) {
                      switch (value) {
                        case ButtonState.loading:
                          return Container(
                            margin: const EdgeInsets.all(15.0),
                            width: 20.0,
                            height: 20.0,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        case ButtonState.paused:
                          return IconButton(
                            icon: const Icon(Icons.play_arrow,
                                size: 35, color: Colors.white),
                            onPressed: _pageManager.play,
                          );
                        case ButtonState.playing:
                          return IconButton(
                            icon: const Icon(Icons.pause,
                                size: 35, color: Colors.white),
                            onPressed: _pageManager.pause,
                          );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  splashRadius: 30,
                  icon: Icon(Icons.skip_next,
                      size: 35,
                      color: widget.surahNumber != 113
                          ? Colors.black
                          : Colors.grey),
                  onPressed: () {
                    if (widget.surahNumber! < 113) {
                      setState(() {
                        widget.surahNumber = widget.surahNumber! + 1;
                        player.stop();
                        _pageManager.dispose();
                        url = quran.getAudioURLBySurah(widget.surahNumber!);
                        _pageManager._init();
                        _pageManager.buttonNotifier.value = ButtonState.loading;
                      });
                      _interstitialAd?.show();
                      _loadInterstitialAd();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PageManager {
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  void dispose() {
    player.dispose();
  }

  void _init() async {
    player = AudioPlayer();
    await player.setUrl(url);

    player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else {
        buttonNotifier.value = ButtonState.playing;
      }
    });

    player.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    player.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    player.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  PageManager() {
    _init();
  }

  void play() {
    player.play();
    NotificationService().showNotification(
        1,
        "Now Playing • Surah ${quran.getSurahName(s!)}",
        "Mashary Rashid Al-Afassy",
        false,
        'Quran');
  }

  void pause() {
    player.pause();
    NotificationService().cancelAllNotifications();
  }

  void seek(Duration position) {
    player.seek(position);
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });

  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }
