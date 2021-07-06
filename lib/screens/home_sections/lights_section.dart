import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LightsSection extends StatelessWidget {
  final DatabaseReference lightsRef;

  const LightsSection(this.lightsRef);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Lightning",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildBrightnessSensor(context),
                buildBrightnessController(context)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBrightnessSensor(BuildContext context) {
    return StreamBuilder<Event>(
        stream: lightsRef.child("brightness").onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading...");
          }
          final brightness =
              double.parse(snapshot.data.snapshot.value as String) * 100;
          return Row(
            children: [
              Image.asset(
                "images/brightness.png",
                width: 32,
              ),
              SizedBox(
                width: 4,
              ),
              Text("$brightness %")
            ],
          );
        });
  }

  Widget buildBrightnessController(BuildContext context) {
    final fanRef = lightsRef.child("is_lights_on");
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
              Text("Lamp"),
            ],
          );
        });
  }
}
