import 'package:flutter/material.dart';
import 'package:mathtarea/pages/QuestionSBS.dart';
import 'package:mathtarea/pages/QuestionFlip.dart';
import 'package:mathtarea/pages/QuestionEnglish.dart';
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

class ViewModesPage extends StatelessWidget {
  final int levelIndex;

  const ViewModesPage({
    super.key,
    required this.levelIndex,
  });

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
                      "Choose Mode",
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
                          elevatedButton(
                              "English Only", 0, levelIndex, context),
                          SizedBox(height: 20),
                          elevatedButton(
                              "Side By Side", 1, levelIndex, context),
                          SizedBox(height: 20),
                          elevatedButton("Flip", 2, levelIndex, context),
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

  Widget elevatedButton(
      String modeName, int modesIndex, int levelsIndex, BuildContext context) {
    return ElevatedButton(
      child: Text(
        modeName,
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
        if (modesIndex == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionEnglishPage(
                currentQuestionIndex: 0,
                mode: 'Mode_English',
                levelIndex: levelIndex,
              ),
            ),
          );
        } else if (modesIndex == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuestionSBSPage(
                    currentQuestionIndex: 0,
                    mode: 'Mode_SBS',
                    levelIndex: levelsIndex)),
          );
        } else if (modesIndex == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuestionFlipPage(
                      currentQuestionIndex: 0,
                      mode: 'Mode_Flip',
                      levelIndex: levelIndex,
                    )),
          );
        }
      },
    );
  }
}
