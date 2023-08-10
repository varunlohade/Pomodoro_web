import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:uilearning/screens/HomeScreen.dart';
import 'package:page_transition/page_transition.dart';

const colorizeColors = [
  Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,
];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(seconds: 5, milliseconds: 500),
    ).then((value) {
      Navigator.pushReplacement(
          context,
          PageTransition(
            alignment: Alignment.bottomCenter,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 600),
            reverseDuration: Duration(milliseconds: 600),
            type: PageTransitionType.bottomToTop,
            child: HomeScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
                child: AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText("Pomodoro",
                    textStyle:
                        GoogleFonts.poppins(fontSize: 30, color: Colors.white),
                    duration: const Duration(seconds: 4)),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 10),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            )),
            Center(
                child: AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText("Minimal, Modern and Ad free",
                    textStyle: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.white60),
                    duration: const Duration(seconds: 4)),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 3000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            )),
            const SizedBox(
              height: 30,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
