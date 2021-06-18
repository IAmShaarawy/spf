import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String title;

  Home(this.title);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final counterCollection = FirebaseFirestore.instance.collection("test");

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
            Text("You have pushed the button:"),
            StreamBuilder<DocumentSnapshot>(
                stream: counterCollection.doc("counter").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading");
                  }
                  return Text(
                    "${snapshot.data.get("value")}",
                    style: Theme.of(context).textTheme.headline4,
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onFABPressed,
        child: Icon(Icons.add),
        tooltip: "Increment",
      ),
    );
  }

  void onFABPressed() async {
    final counter = counterCollection.doc("counter");
    final counterDocData = await counter.get();
    final counterValue = (counterDocData.get("value") as int);
    await counter.set({"value": counterValue + 1});
  }
}
