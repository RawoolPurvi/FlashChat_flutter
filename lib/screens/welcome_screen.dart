import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_card/screens/RoundedButton.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    animation = CurvedAnimation(parent: controller!, curve: Curves.decelerate);

    // FOR THE LOGO ANIMATION TO APPEAR
    controller!.forward();

    // FOR THE LOGO ANIMATION TO REPEAT IN LOOP
    // animation!.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller!.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller!.forward();
    //   }
    // }); 

    // FOR THE LOGO ANIMATION TO DISAPPEAR
    // controller!.reverse(from: 1.0);
    
    controller!.addListener(() {
      setState(() {});
    });

  }
  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 194, 240, 194),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    // height: 60.0,
                    // height: controller!.value * 60,
                    height: animation!.value * 100,
                  ),
                ),
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText('Flash Chat',
                    textStyle: TextStyle(
                      fontSize: 65.0,
                      fontWeight: FontWeight.w900,
                    ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, '/registration');
              },
            )
          ],
        ),
      ),
    );
  }
}