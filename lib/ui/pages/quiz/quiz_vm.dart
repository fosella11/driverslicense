import 'package:flutter/cupertino.dart';

import '../../../models/question.dart';

class QuizVM extends ChangeNotifier {
  List<Question> questions;
  int currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  List<dynamic> options;

  QuizVM(List<Question> questions) {
    this.questions = questions;
    loadOptions();
  }

  Question getCurrentQuestion() {
    return questions[currentIndex];
  }

  dynamic getCurrentAnswers() {
    return _answers[currentIndex];
  }

  void incrementCurrentIndex() {
    currentIndex++;
    loadOptions();

    //esto hace que se refresque la vista
    notifyListeners();
  }

  addAnswer(option) {
    _answers[currentIndex] = option;
    notifyListeners();
  }

  void loadOptions() {
    options = getCurrentQuestion().incorrectAnswers;
    if (!options.contains(getCurrentQuestion().correctAnswer)) {
      options.add(getCurrentQuestion().correctAnswer);
      options.shuffle();
    }
  }
}
