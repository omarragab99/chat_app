import 'package:chatme/screans/chatscreen.dart';
import 'package:chatme/screans/registeration.dart';
import 'package:chatme/screans/signin.dart';
import 'package:chatme/screans/welcomesccreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _auth = FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: ChatScreen(),
      initialRoute: _auth.currentUser != null
          ? ChatScreen.screanroute
          : Welcomescreen.screanroute,
      routes: {
        Welcomescreen.screanroute: (context) => Welcomescreen(),
        Signin.screanroute: (context) => Signin(),
        Regestration.screanroute: (context) => Regestration(),
        ChatScreen.screanroute: (context) => ChatScreen(),
      },
    );
  }
}
