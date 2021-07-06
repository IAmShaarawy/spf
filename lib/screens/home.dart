import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_poultry_farm/screens/home_sections/cleaning_section.dart';
import 'package:smart_poultry_farm/screens/home_sections/hydration_section.dart';
import 'package:smart_poultry_farm/screens/home_sections/lights_section.dart';
import 'package:smart_poultry_farm/screens/home_sections/nutrition_section.dart';
import 'package:smart_poultry_farm/screens/home_sections/ventilation_section.dart';

class Home extends StatefulWidget {
  final DatabaseReference ventilationRef;
  final DatabaseReference lightsRef;
  final DatabaseReference cleaningRef;
  final DatabaseReference nutritionRef;
  final DatabaseReference hydrationRef;

  Home(
      {this.ventilationRef,
      this.lightsRef,
      this.cleaningRef,
      this.nutritionRef,
      this.hydrationRef});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to SPF"),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          children: [
            VentilationSection(widget.ventilationRef),
            LightsSection(widget.lightsRef),
            CleaningSection(widget.cleaningRef),
            NutritionSection(widget.nutritionRef),
            HydrationSection(widget.hydrationRef),
          ],
        ),
      ),
    );
  }
}
