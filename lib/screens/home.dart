import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String title;

  Home(this.title);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ledReference = FirebaseDatabase(
          databaseURL:
              "https://fir-p-f-b0543-default-rtdb.europe-west1.firebasedatabase.app/")
      .reference()
      .child("is_led_on");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ESP8266 Built in LED Status"),
            StreamBuilder<Event>(
                stream: ledReference.onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading...");
                  }
                  bool isLedOn = (snapshot.data.snapshot.value as bool);
                  return Text(
                    "${isLedOn ? "On" : "Off"}",
                    style: Theme.of(context).textTheme.headline4,
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onFABPressed,
        child: Icon(Icons.power_settings_new),
        tooltip: "Toggle LED",
      ),
    );
  }

  void onFABPressed() async {
    final ledSS = await ledReference.get();
    final isLedOn = (ledSS.value as bool);
    await ledReference.set(!isLedOn);
  }
}
