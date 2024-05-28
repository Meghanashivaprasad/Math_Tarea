import 'package:flutter/material.dart';
import 'package:mathtarea/pages/ViewModes.dart';
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

class GradeLevelsPage extends StatelessWidget {
  const GradeLevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Stack(
        children: [
          CustomPaint(
            painter: MathSymbolsBackgroundPainter(),
            size: Size.infinite,
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 120.0),
                child: Column(
                  children: [
                    Text(
                      "Choose Level",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: 'Comic Neue',
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      color: Color.fromARGB(255, 155, 247, 230),
                      child: Column(
                        children: [
                          elevatedButton("Pre-Kindergarten", 1, context),
                          SizedBox(height: 20),
                          elevatedButton("Kindergarten", 2, context),
                          SizedBox(height: 20),
                          elevatedButton("Grade 1", 3, context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget elevatedButton(String grade, int levelIndex, BuildContext context) {
    return ElevatedButton(
      child: Text(
        grade,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Comic Neue',
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        minimumSize: Size(400, 80),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewModesPage(
              levelIndex: levelIndex,
            ),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GradeLevelsPage(),
  ));
}
