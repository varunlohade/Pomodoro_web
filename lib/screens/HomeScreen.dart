import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'dart:async';
import 'dart:html';

import 'package:uilearning/constants/image_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFullScreenLandScape = false;
  int minutes = 20;
  int seconds = 00;
  int timerTimeSeconds = 1200;
  bool isTimerRunning = false;
  bool isHovering = false;
  bool enteredFullScreenRegion = false;
  bool isFullScreen = false;
  bool isStartSlideShow = false;
  int selectedIndex = 0;
  String slideShowImagePath = ImageConstants.image0;
  Offset boxshadowValues = const Offset(4, 5.5);
  final int _duration = 1200;
  final CountDownController _controller = CountDownController();
  List imagePath = [
    ImageConstants.image0,
    ImageConstants.image1,
    ImageConstants.image2,
    ImageConstants.image3,
    ImageConstants.image4,
    ImageConstants.image5
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isPaused = false;
  late Timer timer;
  convertSeconds(int totalSeconds) {
    int minutes = totalSeconds ~/ 60; // Divide by 60 to get minutes
    int seconds = totalSeconds % 60; // Remainder gives seconds

    if (seconds >= 60) {
      seconds = 0;
      minutes++; // Increment minutes if seconds exceed 59
    }

    return "$minutes : $seconds";
  }

  void startTimer(int totalSeconds) {
    int secondsRemaining = isPaused ? timerTimeSeconds : totalSeconds;

    setState(() {
      isTimerRunning = true;
      if (isPaused) (isPaused = false);
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        minutes = secondsRemaining ~/ 60;
        seconds = secondsRemaining % 60;
        setState(() {
          timerTimeSeconds = secondsRemaining;
        });

        secondsRemaining--;
      } else {
        print('Timer finished!');
        timer.cancel();
        setState(() {
          isTimerRunning = false;
        });
      }
    });
  }

  void pauseTimer() {
    if (timer != null) timer.cancel();
    setState(() {
      isPaused = true;
      isTimerRunning = !isTimerRunning;
    });
  }

  void rotateScreenTolandscape() {
    if (!isFullScreenLandScape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      print("object");
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    setState(() {
      isFullScreenLandScape = !isFullScreenLandScape;
    });
  }

  double getDecimalPart(String numb) {
    var number = double.parse(numb);
    String numberString = number.toString();
    int decimalIndex = numberString.indexOf('.');

    if (decimalIndex == -1) {
      return 0.0; // No decimal part
    }

    String decimalPart = numberString.substring(decimalIndex + 1);
    double decimalValue = double.parse('$decimalPart');
    return decimalValue;
  }

  BoxDecoration slideShowboxDecoration() {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              slideShowImagePath,
            ),
            fit: BoxFit.fill));
  }

  void changeBackgroundImage() {
    Timer.periodic(const Duration(seconds: 20), (value) {
      Random random = Random();
      int randomNumber = random.nextInt(5); // from 0 upto 99 included

      setState(() {
        slideShowImagePath = imagePath[randomNumber];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: (!kIsWeb)
            ? FloatingActionButton(
                onPressed: () {
                  if (!kIsWeb) rotateScreenTolandscape();
                },
                backgroundColor: Colors.transparent,
                child: const Icon(
                  Icons.fullscreen,
                  color: Colors.white,
                  size: 30,
                ),
              )
            : FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: floatingFullScreen()),
        backgroundColor: Colors.black,
        body: Container(
          decoration: isStartSlideShow?slideShowboxDecoration(): null,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Pomodoro",
                              style: GoogleFonts.spaceGrotesk(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 60,
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: "by",
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w200,
                                      ),
                                      children: [
                                    TextSpan(
                                      text: " Invofinity",
                                      style: GoogleFonts.spaceGrotesk(
                                          fontSize: 11,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 3),
                                    ),
                                  ])),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 130,
                  ),
                  Wrap(
                    runSpacing: 10,
                    runAlignment: WrapAlignment.center,
                    children: [
                      buildButtons("Pomodoro", 0),
                      const SizedBox(
                        width: 20,
                      ),
                      buildButtons("Short Break", 1),
                      const SizedBox(
                        width: 20,
                      ),
                      buildButtons("Long break", 2),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$minutes",
                        style: GoogleFonts.spaceGrotesk(
                            fontSize: 140, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(":",
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 140, color: Colors.white)),
                      ),
                      Text(
                        "$seconds",
                        style: GoogleFonts.spaceGrotesk(
                            fontSize: 140, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildStartButton(),
                      const SizedBox(width: 10),
                      buildResetButton(),
                      const SizedBox(width: 10),
                      buildSettingButton(),
                    ],
                  ),
                  const SizedBox(
                    height: double.maxFinite,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget floatingFullScreen() {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          enteredFullScreenRegion = true;
        });
      },
      onExit: (event) {
        setState(() {
          enteredFullScreenRegion = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          isFullScreen = !isFullScreen;

          isFullScreen
              ? document.documentElement!.requestFullscreen()
              : document.exitFullscreen();
        },
        child: const SizedBox(
          height: 300,
          width: double.maxFinite,
          child: Icon(
            Icons.fullscreen,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildResetButton() {
    return GestureDetector(
      onTap: () {
        timer.cancel();
        setTime(selectedIndex);
      },
      child: const Icon(
        Icons.refresh,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget buildSettingButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isStartSlideShow = !isStartSlideShow;

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(isStartSlideShow
                  ? "SlideShow Initiated"
                  : "SlideShow Stopped")));
        });
        isStartSlideShow ? changeBackgroundImage() : null;
      },
      child: const Icon(
        Icons.slideshow,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget buildStartButton() {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovering = false;
        });
      },
      child: InkWell(
        onTap: () {
          isTimerRunning ? pauseTimer() : startTimer(timerTimeSeconds);
        },
        focusColor: Colors.black,
        child: Container(
          height: 50,
          width: 120,
          decoration: BoxDecoration(
              color: isHovering ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white, width: 1.2)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Center(
              child: Text(
                isTimerRunning ? "Pause" : "Start",
                style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w700,
                    fontSize: 23,
                    color: isHovering ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  setTime(int index) {
    setState(() {
      switch (index) {
        case 0:
          timerTimeSeconds = 1200;
          minutes = 20;
          seconds = 0;
          break;
        case 1:
          timerTimeSeconds = 300;
          minutes = 5;
          seconds = 0;
          break;
        case 2:
          timerTimeSeconds = 600;
          minutes = 10;
          seconds = 0;
          break;
      }
    });
  }

  Widget buildButtons(String title, int index) {
    return GestureDetector(
      onTap: () {
        timer.cancel();
        setTime(index);
        isTimerRunning = false;
        selectedIndex = index;
      },
      child: Container(
        height: 45,
        width: 160,
        decoration: BoxDecoration(
            color: selectedIndex != index ? Colors.transparent : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white, width: 1.2)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: selectedIndex != index ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
