import 'package:flutter/material.dart';
import 'package:flutterappbookstore/module/checkout/checkout_page.dart';
import 'package:flutterappbookstore/module/home/home_page.dart';
import 'package:flutterappbookstore/module/signin/signin_page.dart';
import 'package:flutterappbookstore/module/signup/signup_page.dart';
import 'package:flutterappbookstore/module/splash/splash.dart';
import 'package:flutterappbookstore/shared/app_color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Book Store',
      theme: ThemeData(
        primarySwatch: AppColor.yellow,
      ),
      initialRoute: '/',
      routes:<String,WidgetBuilder>{
        '/' : (context) => SplashPage(),
        '/sign-in' : (context) => SignInPage(),
        '/sign-up' : (context) => SignUpPage(),
        '/home' : (context) => HomePage(),
        '/checkout' : (context) => CheckoutPage(),
      }
    );
  }
}
