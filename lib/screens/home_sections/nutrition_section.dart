import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NutritionSection extends StatelessWidget {
  final DatabaseReference nutritionRef;

  const NutritionSection(this.nutritionRef);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Nutrition",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildHydrationSensors(context),
                buildHydrationController(context)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHydrationSensors(BuildContext context) {
    return StreamBuilder<Event>(
        stream: nutritionRef.child("food_level").onValue,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Text("Loading...");
          }
          final brightness = double.parse(snapshot.data.snapshot.value as String)*100;
          return Row(
            children: [
              Image.asset(
                "images/feed_tank.png",
                width: 32,
              ),
              SizedBox(
                width: 4,
              ),
              Text("$brightness %")
            ],
          );
        }
    );
  }

  Widget buildHydrationController(BuildContext context) {
    final fanRef = nutritionRef.child("is_tank_open");
    return StreamBuilder<Event>(
        stream: fanRef.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading...");
          final isFanOn = (snapshot.data.snapshot.value as bool);
          return Column(
            children: [
              Switch(
                value: isFanOn,
                onChanged: (isOn) async {
                  await fanRef.set(isOn);
                },
              ),
              Text("Feed Tank"),
            ],
          );
        });
  }
}