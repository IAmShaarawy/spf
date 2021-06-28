import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class VentilationSection extends StatelessWidget {
  final DatabaseReference ventilationRef;

  const VentilationSection(this.ventilationRef);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 200,
        child: Center(
          child: StreamBuilder<Event>(
              stream: ventilationRef.child("temperature").onValue,
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return Text("Loading...");
                }
                final temp = (snapshot.data.snapshot.value as double);
                return Text("Current temperature is $temp°C");
              }
          ),
        ),
      ),
    );
  }
}
