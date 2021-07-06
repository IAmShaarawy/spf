import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CleaningSection extends StatelessWidget {
  final DatabaseReference cleaningRef;

  const CleaningSection(this.cleaningRef);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Cleaning",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 16,
            ),
            buildControllersSection(context),
          ],
        ),
      ),
    );
  }

  Widget buildControllersSection(BuildContext context) {
    return StreamBuilder<Event>(
        stream: cleaningRef.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text("Loading...");
          final flag = snapshot.data.snapshot.value as int;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: flag == -1 ? null : moveBackward,
                icon: Icon(Icons.fast_rewind_rounded),
              ),
              IconButton(
                onPressed: flag == 0 ? null : stop,
                icon: Icon(Icons.pause_rounded),
              ),
              IconButton(
                onPressed: flag == 1 ? null : moveForward,
                icon: Icon(Icons.fast_forward_rounded),
              ),
            ],
          );
        });
  }

  void moveBackward() async {
    await cleaningRef.set(-1);
  }

  void moveForward() async {
    await cleaningRef.set(1);
  }

  void stop() async {
    await cleaningRef.set(0);
  }
}
