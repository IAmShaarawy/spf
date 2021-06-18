import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_poultry_farm/home.dart';

class SPFApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String title ;
    if(kIsWeb){
      title = "Flutter Demo From Web";
    }else{
      title = "Flutter Demo From Mobile";
    }
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Home(title),
    );
  }
}