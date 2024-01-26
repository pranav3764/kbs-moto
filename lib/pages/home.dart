import 'package:flutter/material.dart';
import 'package:mynotes/functions/buttons.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  final List<Widget> _pages = [
    // Your different pages/screens go here
    // e.g., PageOne(), PageTwo(), PageThree(),
    Placeholder(color: Colors.blue),
    Placeholder(color: Colors.green),
    Placeholder(color: Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),

        child: Center(
          child: customElevatedButton(text: "Allow Location", onPressed: (){
            Navigator.pushNamed(context, "/location");
          }),
        ),
      ),
    );
  }
}
