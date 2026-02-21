import 'package:flutter/material.dart';
import 'package:flash_card/screens/welcome_screen.dart';
import 'package:flash_card/screens/login_screen.dart';
import 'package:flash_card/screens/registration_screen.dart';
import 'package:flash_card/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

// void main() => runApp(FlashChat());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/registration': (context) => RegistrationScreen(),
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}