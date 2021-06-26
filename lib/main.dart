
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuickmeat_admin_app/screens/category_screen.dart';
import 'package:kuickmeat_admin_app/screens/delivery_boy_screen.dart';
import 'package:kuickmeat_admin_app/screens/splash_screen.dart';
import 'package:kuickmeat_admin_app/screens/vendor_screen.dart';
import 'screens/login_screen.dart';
import 'screens/manage_banners.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kuick Meat App Admin Dashboard',
      theme: ThemeData(
        primaryColor: Colors.redAccent.shade200,
      ),
      home: SplashScreen(),
      routes: {
        SplashScreen.id:(context)=> SplashScreen(),
        LoginScreen.id:(context)=> LoginScreen(),
        BannerScreen.id:(context)=> BannerScreen(),
        CategoryScreen.id:(context)=> CategoryScreen(),
        VendorScreen.id:(context)=> VendorScreen(),
        DeliveryBoyScreen.id:(context)=> DeliveryBoyScreen(),
      },
    );
  }
}


