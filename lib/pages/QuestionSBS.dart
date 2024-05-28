import 'package:flutter/material.dart';
import 'package:mathtarea/widgets/appbar.dart';
import 'package:mathtarea/models/quiz_questions.dart';
import 'package:flutter_tts/flutter_tts.dart';
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

class QuestionSBSPage extends StatelessWidget {
  final int currentQuestionIndex;
  final String mode;
  final int levelIndex;
  final FlutterTts flutterTts = FlutterTts();

  static int score = 0;

  QuestionSBSPage({
    super.key,
    required this.currentQuestionIndex,
    required this.mode,
    required this.levelIndex,
  });

  // Callback function to reset the score
  static void resetScore() {
    score = 0;
  }

  int userAnswer = 0;

  // Speak method with language option
  Future<void> speak(String text, {String language = 'en-US'}) async {
    await flutterTts.setLanguage(language);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QuizQuestion>>(
      future: fetchQuestions(
          levelIndex, mode), // Make sure this method is implemented and correct
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<QuizQuestion> questions = snapshot.data!;
          return Scaffold(
              appBar: appBar(context), // Ensure this is implemented correctly
              body: Stack(children: [
                CustomPaint(
                  painter: MathSymbolsBackgroundPainter(),
                  size: Size.infinite,
                ),
                ListView(
                  children: [
                    const SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.volume_up),
                          onPressed: () => speak(
                              questions[currentQuestionIndex].questionText),
                          tooltip: 'Listen in English',
                        ),
                        SizedBox(width: 20), // Spacing between buttons
                        IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.volume_up),
                          onPressed: () => speak(
                              questions[currentQuestionIndex].translatedText,
                              language: 'es-ES'),
                          tooltip: 'Listen in Spanish',
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.all(16),
                              color: Color.fromARGB(128, 186, 222, 217),
                              child: Text(
                                "Question ${currentQuestionIndex + 1}: ${questions[currentQuestionIndex].questionText}",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Comic Neue',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.all(16),
                              color: Color.fromARGB(128, 80, 165, 157),
                              child: Text(
                                "Translated Text: ${questions[currentQuestionIndex].translatedText}",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Comic Neue',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                            userAnswer = int.tryParse(value) ?? 0,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your answer',
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            bool isCorrect = userAnswer ==
                                questions[currentQuestionIndex].answer;
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                content: Icon(
                                  isCorrect ? Icons.check : Icons.close,
                                  color: isCorrect ? Colors.green : Colors.red,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(191, 173, 135, 194),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Check Answer',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Comic Neue',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.green,
                            backgroundColor:
                                Colors.white, // Text and icon color
                            padding: const EdgeInsets.all(8.0),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Comic Neue',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text("Back"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            bool isCorrect = userAnswer ==
                                questions[currentQuestionIndex].answer;
                            if (isCorrect) {
                              score++;
                            }
                            if (currentQuestionIndex == questions.length - 1) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ScorePage(score: score)),
                              ).then((_) => resetScore());
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuestionSBSPage(
                                      currentQuestionIndex:
                                          currentQuestionIndex + 1,
                                      mode: mode,
                                      levelIndex: levelIndex),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.green,
                            backgroundColor:
                                Colors.white, // Text and icon color
                            padding: const EdgeInsets.all(8.0),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Comic Neue',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text("Next"),
                        ),
                      ],
                    )
                  ],
                ),
              ]));
        }
      },
    );
  }
}

class ScorePage extends StatelessWidget {
  final int score;

  ScorePage({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Center(
        child: Text(
          'Your Score: $score',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
