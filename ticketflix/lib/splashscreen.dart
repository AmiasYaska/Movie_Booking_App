import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketflix/confirm_page.dart';


class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _splashscreen();
  }
}

class _splashscreen extends State<splashscreen> {
  int splashtime = 5;

  @override
  void initState() {
    Future.delayed(Duration(seconds: splashtime), () async {
      checkloginstatus();
    });

    super.initState();
  }

  void checkloginstatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var loggedin = prefs.getBool('loggedin');
    if (loggedin != null && loggedin) {
      Navigator.pushNamed(context, '/HomeScreen');
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return  const ConfirmPage();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Container(
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(),
                  AnimatedTextKit(
                    animatedTexts: [
                      FlickerAnimatedText(
                        'TICKETFLIX',
                        textStyle: const TextStyle(
                          fontSize: 60.0,
                          fontFamily: 'bebas',
                          color: Color(0xffDB202C),
                          // fontWeight: FontWeight.bold,
                        ),
                        // speed: const Duration(milliseconds: 1000),
                      ),
                    ],
                    repeatForever: true,
                    // totalRepeatCount: 4,
                    // pause: const Duration(milliseconds: 1000),
                    // displayFullTextOnTap: false,
                    // stopPauseOnTap: true,
                  ),
                  // SizedBox(
                  //     height: 200,
                  //     width: 200,
                  //     child: Image.asset("assets/images/logo.png")),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: const Text("Version: 1.0.0",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'cera',
                          fontSize: 14,
                        )),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ])));
  }
}
