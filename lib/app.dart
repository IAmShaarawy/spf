import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
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
    await Firebase.initializeApp();
    await Future.delayed(Duration(seconds: 3));
    final dbRef = FirebaseDatabase(
        databaseURL:
        "https://fir-p-f-b0543-default-rtdb.europe-west1.firebasedatabase.app/")
        .reference();

    return Home(
      ventilationRef: dbRef.child("ventilation"),
      lightsRef: dbRef.child("lights"),
      nutritionRef: dbRef.child("nutrition"),
      hydrationRef: dbRef.child("hydration"),
    );
  }
}
