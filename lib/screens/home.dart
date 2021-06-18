import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String title;

  Home(this.title);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int count = 0;

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
            Text(
              "$count",
              style: Theme.of(context).textTheme.headline4,
            ),
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

  void onFABPressed() {
    setState(() {
      count+=2;
    });
  }
}