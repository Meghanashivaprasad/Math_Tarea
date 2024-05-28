import 'package:flutter/material.dart';
import 'package:mathtarea/widgets/appbar.dart';
import 'package:mathtarea/models/quiz_questions.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flip_card/flip_card.dart';
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

class QuestionFlipPage extends StatelessWidget {
  final int currentQuestionIndex;
  final String mode;
  final int levelIndex;
  final FlutterTts flutterTts = FlutterTts();
  final GlobalKey<FlipCardState> flipCardKey = GlobalKey<FlipCardState>();

  static int score = 0;

  QuestionFlipPage({
    super.key,
    required this.currentQuestionIndex,
    required this.mode,
    required this.levelIndex,
  });

  static void resetScore() {
    score = 0;
  }

  int userAnswer = 0;

  Future<void> speak(String text, {String language = 'en-US'}) async {
    await flutterTts.setLanguage(language);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QuizQuestion>>(
      future: fetchQuestions(levelIndex, mode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<QuizQuestion> questions = snapshot.data!;
          QuizQuestion question = questions[currentQuestionIndex];

          return Scaffold(
              appBar: appBar(context),
              body: Stack(children: [
                CustomPaint(
                  painter: MathSymbolsBackgroundPainter(),
                  size: Size.infinite,
                ),
                ListView(
                  children: [
                    const SizedBox(height: 80),
                    FlipCard(
                      key: flipCardKey,
                      direction: FlipDirection.HORIZONTAL,
                      front: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(16),
                        color: Color.fromARGB(128, 186, 222, 217),
                        child: Column(
                          children: [
                            Text(
                              "Question ${currentQuestionIndex + 1}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Comic Neue',
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              question.questionText,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Comic Neue',
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.volume_up),
                              onPressed: () => speak(question.questionText,
                                  language: 'en-US'),
                              tooltip: 'Listen in English',
                            ),
                            SizedBox(
                              width: 100, // Adjust width as needed
                              height:
                                  36, // Adjust height as needed, keeping it small
                              child: ElevatedButton(
                                onPressed: () =>
                                    flipCardKey.currentState?.toggleCard(),
                                child: const Text(
                                  'Flip Card',
                                  style: TextStyle(
                                      fontSize:
                                          14), // Adjust font size for smaller button
                                ),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue, // Text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20), // Rounded corners
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8), // Adjust padding
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      back: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(16),
                        color: Color.fromARGB(128, 80, 165, 157),
                        child: Column(
                          children: [
                            Text(
                              "Translated Text",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Comic Neue',
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              question.translatedText,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Comic Neue',
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.volume_up),
                              onPressed: () => speak(question.translatedText,
                                  language: 'es-ES'),
                              tooltip: 'Listen in Spanish',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: SizedBox(
                          width: 150, // Explicitly setting the width
                          height: 50, // Explicitly setting the height
                          child: ElevatedButton(
                            onPressed: () {
                              bool isAnswerCorrect = userAnswer ==
                                  questions[currentQuestionIndex].answer;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  content: Icon(
                                      isAnswerCorrect
                                          ? Icons.check
                                          : Icons.close,
                                      color: isAnswerCorrect
                                          ? Colors.green
                                          : Colors.red),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(
                                  191, 173, 135, 194), // Background color
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              "Check Answer",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16, // Adjust font size if necessary
                                  fontFamily: 'Comic Neue',
                                  fontWeight: FontWeight.bold),
                            ),
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
                            bool isAnswerCorrect = userAnswer ==
                                questions[currentQuestionIndex].answer;
                            if (isAnswerCorrect) {
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
                                  builder: (context) => QuestionFlipPage(
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
