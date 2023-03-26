import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatbotflutter/provider/messagesprovider.dart';
import 'package:chatbotflutter/texttospeech/TextToSpeechAPI.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:math' as math;
import 'package:animated_button/animated_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  String? _path;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  synthesizeText(String text) async {
    final String audioContent = await TextToSpeechAPI().synthesizeText(
      text,
      context.read<MessagesNotifier>().voicename,
      context.read<MessagesNotifier>().gender,
    );
    if (audioContent == null) return;

    final bytes = Base64Decoder().convert(audioContent, 0, audioContent.length);
    final dir = await getTemporaryDirectory();
    // Generate a unique file name by including a timestamp.
    final file = File(
        '${dir.path}/wavenet_${DateTime.now().millisecondsSinceEpoch}.mp3');
    await file.writeAsBytes(bytes);
    if (file.existsSync()) {
      // The file exists.
      setState(() {
        _path = file.path;
        _audioPlayer.play(_path!);
      });
    } else {
      // The file does not exist.
      print("File not found: ${file.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final CarouselController _controller = CarouselController();
    bool isVoiceMale = true;
    int _current = 0;

    final List<Widget> imageSliders = [
      Image(
        image: AssetImage('assets/boyavatar.webp'),
        height: 500,
      ),
      Image(
        image: AssetImage('assets/girlavatar.webp'),
        height: 500,
      ),
    ];

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff2f8f6a),
            Color(0xff193e36),
            Color.fromARGB(255, 13, 33, 29),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: kToolbarHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 8,
                    left: 8,
                    top: 8,
                    bottom: 8,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: NeumorphicIcon(
                            Icons.menu,
                            size: 30,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/malayprologo.webp',
                            height: 400,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: NeumorphicIcon(
                            Icons.settings,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CarouselSlider(
                items: imageSliders,
                carouselController: _controller,
                options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                        context.read<MessagesNotifier>().selectvoice(
                              _current == 0
                                  ? "ms-MY-Wavenet-D"
                                  : "ms-MY-Wavenet-C",
                              _current == 0 ? "MALE" : "FEMALE",
                              _current == 0 ? "Adam" : "Eve",
                            );
                      });
                      synthesizeText(
                          "Assalamualaikum, Hi! Saya ${context.read<MessagesNotifier>().avatar}! Selamat berkenalan!");
                    }),
              ),
            ),
            AnimatedButton(
              width: 300,
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        "Welcome to MalayPro!",
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TypewriterAnimatedText(
                        "Saya ${context.watch<MessagesNotifier>().avatar}, selamat berkenalan!",
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TypewriterAnimatedText(
                        "Lets learn to speak Malay!",
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontFamily: "Helvetica",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onPressed: () {},
              shadowDegree: ShadowDegree.light,
              color: Color(0xffff9333),
              //  color: Color(0xffff9333),
            ),
            Expanded(
              child: FractionallySizedBox(
                widthFactor: 0.7, // 90% width of its parent
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 100.0,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.3,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.vertical,
                  ),
                  items: [1, 2, 3, 4].map((i) {
                    String _getButtonText(int i) {
                      switch (i) {
                        case 1:
                          return "Open Mode";
                        case 2:
                          return "Verb Mode";
                        case 3:
                          return "Vocab Mode";
                        case 4:
                          return "Dialogue Mode";

                        default:
                          return "Button";
                      }
                    }

                    String _getButtonRoute(int i) {
                      switch (i) {
                        case 1:
                          return '/firstmode';
                        case 2:
                          return '/secondmode';
                        case 3:
                          return '/thirdmode';
                        case 4:
                          return '/fourthmode';

                        default:
                          return '/';
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Builder(
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: NeumorphicButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, _getButtonRoute(i));
                              },
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(16)),
                                depth: 10,
                                lightSource: LightSource.topLeft,
                                color: Color.fromARGB(255, 23, 58, 49),
                                shadowLightColor:
                                    Color.fromARGB(255, 43, 99, 83),
                                shadowDarkColor: Color.fromARGB(255, 9, 22, 19),
                              ),
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                child: Center(
                                  child: NeumorphicText(
                                    _getButtonText(i),
                                    style: NeumorphicStyle(
                                      depth: 4, //customize depth here
                                      color:
                                          Colors.white, //customize color here
                                    ),
                                    textStyle: NeumorphicTextStyle(
                                      fontSize: 18, //customize size here
                                      // AND others usual text style properties (fontFamily, fontWeight, ...)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }
}
