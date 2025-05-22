import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube/firebase_options.dart';
import 'package:youtube/responsive_changes.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(ProviderScope(child: Youtube()));
}

class Youtube extends StatelessWidget {
  const Youtube({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Youtube",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Responsivechanges(),
    );
  }
}
