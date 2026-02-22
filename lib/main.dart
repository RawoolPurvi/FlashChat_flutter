import 'package:flutter/material.dart';
import 'package:flash_card/screens/welcome_screen.dart';
import 'package:flash_card/screens/login_screen.dart';
import 'package:flash_card/screens/registration_screen.dart';
import 'package:flash_card/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// REQUIRED for background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message: ${message.messageId}");
}
void main() async {
  // initializing firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Register background handler BEFORE runApp
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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