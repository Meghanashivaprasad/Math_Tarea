import 'package:flutter/material.dart';
import 'package:mathtarea/firebase_apis.dart'; // Replace with the correct import
import 'GradeLevels.dart';
import 'package:mathtarea/widgets/appbar.dart';
import 'dart:math' as math;

class MathSymbolsBackgroundPainter extends CustomPainter {
  final math.Random random = math.Random();
  final List<String> symbols = ['+', '-', '×', '÷', '='];

  @override
  void paint(Canvas canvas, Size size) {
    double cellSize =
        50.0; // Adjust this value to change the density of symbols
    int cols = (size.width / cellSize).ceil();
    int rows = (size.height / cellSize).ceil();

    var textStyle = TextStyle(
      color: Colors.black.withOpacity(0.1),
      fontSize: 20,
    );

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        String symbol = symbols[random.nextInt(symbols.length)];
        var textSpan = TextSpan(text: symbol, style: textStyle);
        var textPainter = TextPainter(
          text: textSpan,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        double x = (i + random.nextDouble() * 0.8 + 0.1) * cellSize;
        double y = (j + random.nextDouble() * 0.8 + 0.1) * cellSize;
        textPainter.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StudentNamePage extends StatefulWidget {
  const StudentNamePage({Key? key}) : super(key: key);

  @override
  _StudentNamePageState createState() => _StudentNamePageState();
}

class _StudentNamePageState extends State<StudentNamePage> {
  TextEditingController nameController = TextEditingController();
  bool showSuccessMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: Stack(children: [
          CustomPaint(
            painter: MathSymbolsBackgroundPainter(),
            size: Size.infinite,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  'Student Name',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontFamily: 'Comic Neue',
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 80),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 155, 247, 230),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          hintStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          minimumSize: Size(400, 80),
                        ),
                        onPressed: () async {
                          String studentName = nameController.text;
                          if (studentName.isNotEmpty) {
                            String studentId =
                                await addStudentName(studentName, 0);
                            if (studentId.isNotEmpty) {
                              setState(() {
                                showSuccessMessage = true;
                              });

                              // Navigate to HomePage on success
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GradeLevelsPage(),
                                ),
                              );
                            } else {
                              // Handle the case where studentId is empty (API call failed)
                            }
                          } else {
                            // Handle the case where studentName is empty
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Comic Neue',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (showSuccessMessage)
                        Text(
                          'Student added successfully!',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
