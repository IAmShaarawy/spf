import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NutritionSection extends StatelessWidget {
  final DatabaseReference nutritionRef;

  const NutritionSection(this.nutritionRef);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 200,
        child: Center(
          child: StreamBuilder<Event>(
              stream: nutritionRef.child("food_level").onValue,
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return Text("Loading...");
                }
                final foodLevel = (snapshot.data.snapshot.value as double)*100;
                return Text("Food level is $foodLevel %");
              }
          ),
        ),
      ),
    );
  }
}