import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // Code smell: mutable field in StatelessWidget
  String title = "SonarQube Demo App";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Code smell: public mutable variables
  int counter = 0;
  String unusedVariable = "I am never used";

  @override
  void initState() {
    super.initState();

    // Bug: pointless condition
    if (counter == counter) {
      print("Always true condition");
    }
  }

  void incrementCounter() {
    setState(() {
      counter = counter + 1;
      counter = counter; // Code smell: useless assignment
    });
  }

  void veryLongMethodNameThatDoesTooManyThingsAndViolatesCleanCodePrinciples() {
    print("Bad method name");
    print("Doing many things");
    print("Still doing more things");
    print("No clear responsibility");
  }

  @override
  Widget build(BuildContext context) {

    // Code smell: deeply nested widgets
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("You pressed the button this many times:"),
            Text(
              "$counter",
              style: TextStyle(fontSize: 32),
            ),
            ElevatedButton(
              onPressed: () {
                incrementCounter();
                veryLongMethodNameThatDoesTooManyThingsAndViolatesCleanCodePrinciples();
              },
              child: Text("Increment"),
            ),
            ElevatedButton(
              onPressed: null, // Bug: disabled button
              child: Text("Disabled Button"),
            )
          ],
        ),
      ),
    );
  }
}

