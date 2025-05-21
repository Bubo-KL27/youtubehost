import 'package:flutter/material.dart';

import 'package:youtube/Screens/Android/login_screen.dart';

import 'package:youtube/Widget/responsivelayout.dart';
import 'package:youtube/Screens/web_Screen/login_screen.dart';

class Responsivechanges extends StatelessWidget {
  const Responsivechanges({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsivelayout(
        dekstopbodyscreen:LoginScreenWeb(),
        mobilebodyscreen: LoginScreenAndroid(),
        ),
    );
  }
}