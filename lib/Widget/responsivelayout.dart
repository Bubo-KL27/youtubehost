import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Responsivelayout extends StatelessWidget {
  final Widget mobilebodyscreen;
  final Widget dekstopbodyscreen;

  const Responsivelayout({super.key, required this.dekstopbodyscreen, required this.mobilebodyscreen});

  @override
  Widget build(BuildContext context) {
    
    if (kIsWeb) {
      // This is web
      return dekstopbodyscreen;
    } else if (Platform.isAndroid) {
      // This is Android
      return mobilebodyscreen;
    } else if (Platform.isIOS) {
      // This is iOS
      return mobilebodyscreen;
    } else {
      // Other platforms (desktop, etc.)
      return dekstopbodyscreen;
    }
  }
}

  
const mobilewidth = 600;