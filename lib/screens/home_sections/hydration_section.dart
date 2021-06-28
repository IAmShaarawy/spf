import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HydrationSection extends StatelessWidget {
  final DatabaseReference hydrationRef;

  const HydrationSection(this.hydrationRef);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 200,
        child: Center(
          child: StreamBuilder<Event>(
              stream: hydrationRef.child("water_level").onValue,
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return Text("Loading...");
                }
                final waterLevel = (snapshot.data.snapshot.value as double)*100;
                return Text("Water level is $waterLevel %");
              }
          ),
        ),
      ),
    );
  }
}