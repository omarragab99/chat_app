import 'package:chatme/screans/registeration.dart';
import 'package:chatme/screans/signin.dart';
import 'package:chatme/widgets/bottum.dart';
import 'package:flutter/material.dart';

class Welcomescreen extends StatefulWidget {
  static const String screanroute = 'welcome_screen';
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                height: 180,
                child: Image.asset("images/logo.png"),
              ),
              Text(
                "MassageMe",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff2e386b)),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          MyButton(
            color: Colors.yellow[900]!,
            onPressed: () {
              Navigator.pushNamed(context, Signin.screanroute);
            },
            title: "Sign In",
          ),
          MyButton(
            color: Colors.blue[800]!,
            onPressed: () {
              Navigator.pushNamed(context, Regestration.screanroute);
            },
            title: "register",
          ),
        ],
      ),
    );
  }
}
