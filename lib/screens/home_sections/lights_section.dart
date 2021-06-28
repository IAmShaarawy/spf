import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LightsSection extends StatelessWidget {
  final DatabaseReference lightsRef;

  const LightsSection(this.lightsRef);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 200,
        child: Center(
          child: StreamBuilder<Event>(
            stream: lightsRef.child("brightness").onValue,
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Text("Loading...");
              }
              final brightness = (snapshot.data.snapshot.value as double)*100;
              return Text("Lights brightness is $brightness %");
            }
          ),
        ),
      ),
    );
  }
}
