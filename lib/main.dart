import 'package:flutter/material.dart';
import 'navigations/nav_tab.dart';
import 'my_currencies/MyCurrencies.dart';
import 'product_details.dart';
import 'home/home.dart';
import 'signin.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EXamen Flutter',
      routes: {
        "/": (context) {
          return const SplashScreen();
          //return const Home();
        },
        "/signin": (context) {
          return const Signin();
        },
        "/myCurrencies": (context) {
          return const MyCurrencies();
        },
        "/home": (context) {
          return const Home();
        },
        "/homeTab": (context) {
          return const NavigationTab();
        },
        "/home/details": (context) {
          return const ProductDetails();
        },
      },
    );
  }
}
