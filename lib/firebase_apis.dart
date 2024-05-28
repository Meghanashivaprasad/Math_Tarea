import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mathtarea/models/quiz_questions.dart';

class QuizDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QuizQuestion>> getQuestionsForLevelAndMode(
      int levelIndex, String mode) async {
    List<QuizQuestion> questions = [];

    try {
      // Retrieve documents for the specified level
      QuerySnapshot querySnapshot = await _firestore
          .collection('Level_$levelIndex')
          .doc(mode)
          .collection('Questions')
          .get();

      // Get the number of questions for the level
      int numOfQuestions = querySnapshot.docs.length;

      // Populate the QuizQuestion list
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // Creating a Question object and adding it to the list
        QuizQuestion question = QuizQuestion(
          doc['question_text_english'],
          doc['question_text_spanish'],
          doc['answer'],
        );
        questions.add(question);
      }

      print('Number of questions in Level $levelIndex: $numOfQuestions');
    } catch (e) {
      print('Error retrieving questions: $e');
    }

    return questions;
  }
}

Future<String?> getQuestionTextEnglish(
    String levelNumber, String documentId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(levelNumber)
        .doc(documentId)
        .get();

    if (snapshot.exists) {
      return snapshot.data()?['question_text_english'];
    } else {
      return null; // Document with the given ID does not exist
    }
  } catch (e) {
    print('Error getting question text in English: $e');
    return null;
  }
}

Future<String?> getQuestionTextSpanish(
    String levelNumber, String documentId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(levelNumber)
        .doc(documentId)
        .get();

    if (snapshot.exists) {
      return snapshot.data()?['question_text_spanish'];
    } else {
      return null; // Document with the given ID does not exist
    }
  } catch (e) {
    print('Error getting question text in Spanish: $e');
    return null;
  }
}

Future<bool> checkAnswer(
    String levelNumber, String documentId, int userAnswer) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(levelNumber)
        .doc(documentId)
        .get();

    if (snapshot.exists) {
      int correctAnswer = snapshot.data()?['answer'];
      return userAnswer == correctAnswer;
    } else {
      return false; // Document with the given ID does not exist
    }
  } catch (e) {
    print('Error checking answer: $e');
    return false;
  }
}

Future<String> addStudentName(String studentName, int numberOfLevels) async {
  try {
    DocumentReference<Map<String, dynamic>> docRef =
        await FirebaseFirestore.instance.collection('Student').add({
      'Student_name': studentName,
      'Number_of_levels': numberOfLevels,
      'Student_score': 0,
    });

    return docRef.id; // Return the generated studentId
  } catch (e) {
    print('Error adding student name to Firestore: $e');
    return ''; // Return an empty string or handle the error as needed
  }
}

Future<String?> getStudentIdByName(String studentName) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('Student')
        .where('Student_name', isEqualTo: studentName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null; // Student with the given name not found
    }
  } catch (e) {
    print('Error getting student ID by name: $e');
    return null;
  }
}

Future<bool> addScoreDB(String studentId, int newScore) async {
  try {
    await FirebaseFirestore.instance
        .collection('Student')
        .doc(studentId)
        .update({
      'Student_score': FieldValue.increment(newScore),
    });
    return true;
  } catch (e) {
    print('Error updating student score in Firestore: $e');
    return false;
  }
}
