import 'package:mathtarea/firebase_apis.dart';

class QuizQuestion {
  final String questionText;
  final String translatedText;
  final int answer;

  QuizQuestion(this.questionText, this.translatedText, this.answer);
}

Future<List<QuizQuestion>> fetchQuestions(int levelIndex, String mode) async {
  QuizDatabase quizDatabase = QuizDatabase();
  List<QuizQuestion> questions =
      await quizDatabase.getQuestionsForLevelAndMode(levelIndex, mode);
  return questions;
}
