import 'package:mathtarea/pages/GradeLevels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

AppBar appBar(BuildContext context) {
  final FlutterTts flutterTts = FlutterTts();
  String appBarTitle = 'MathTarea'; // Add this line to store the title text
  return AppBar(
    title: Row(
      children: [
        Text(
          appBarTitle, // Use the stored title text here
          style: TextStyle(
              color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold),
        ),
        IconButton(
            onPressed: () {
              flutterTts.speak(appBarTitle);
            },
            icon: Icon(Icons.volume_up),
            color: Color.fromARGB(255, 81, 35, 12)), //(81, 35, 12
      ],
    ),
    // backgroundColor: Color.fromARGB(255, 236, 236, 236),
    backgroundColor: Color.fromARGB(255, 252, 188, 108),
    elevation: 0.0,
    leading: IconButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GradeLevelsPage()));
        },
        icon: Icon(Icons.home),
        color: Color.fromARGB(255, 81, 35, 12)),
  );
}
