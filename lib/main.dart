
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuickmeat_admin_app/screens/HomeScreen.dart';
import 'package:kuickmeat_admin_app/screens/admin_users.dart';
import 'package:kuickmeat_admin_app/screens/category_screen.dart';
import 'package:kuickmeat_admin_app/screens/order_screen.dart';
import 'package:kuickmeat_admin_app/screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/manage_banners.dart';
import 'screens/notification_screen.dart';
import 'screens/settings_screen.dart';

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
        HomeScreen.id:(context)=> HomeScreen(),
        SplashScreen.id:(context)=> SplashScreen(),
        LoginScreen.id:(context)=> LoginScreen(),
        BannerScreen.id:(context)=> BannerScreen(),
        CategoryScreen.id:(context)=> CategoryScreen(),
        OrderScreen.id:(context)=> OrderScreen(),
        NotificationScreen.id:(context)=> NotificationScreen(),
        AdminUsers.id:(context)=> AdminUsers(),
        SettingScreen.id:(context)=> SettingScreen(),
      },
    );
  }
}


