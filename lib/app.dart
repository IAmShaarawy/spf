import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_poultry_farm/screens/home.dart';
import 'package:smart_poultry_farm/screens/splash.dart';

class SPFApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String title ;
    if(kIsWeb){
      title = "SPF From Web";
    }else{
      title = "SPF From Mobile";
    }
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Splash(),
    );
  }
}