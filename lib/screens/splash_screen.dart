import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kuickmeat_admin_app/screens/login_screen.dart';
import 'package:kuickmeat_admin_app/screens/manage_banners.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(
        Duration(seconds: 2),(){
      FirebaseAuth.instance
          .authStateChanges()
          .listen((User user) {
        if (user == null) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BannerScreen()));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Center(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
