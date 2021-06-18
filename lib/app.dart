import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_poultry_farm/screens/home.dart';
import 'package:smart_poultry_farm/screens/splash.dart';

class SPFApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FutureBuilder<Widget>(
        initialData: Splash(),
        future: findHome(),
        builder: (context, ss) => ss.data,
      ),
    );
  }

  Future<Widget> findHome() async {
    String title;
    if (kIsWeb) {
      title = "SPF From Web";
    } else {
      title = "SPF From Mobile";
    }
    await Firebase.initializeApp();
    await Future.delayed(Duration(seconds: 3));
    return Home(title);
  }
}
