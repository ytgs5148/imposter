import 'dart:math';

class Questions {
  List<String> questions = [
    'This is a normal question',
    'This is an imposter question'
  ];

  getQuestions() {
    int randomIndexForQuestion = new Random().nextInt(questions.length);
    int randomIndexForImposterQuestion = new Random().nextInt(questions.length);

    if (randomIndexForQuestion == randomIndexForImposterQuestion) {
      if (randomIndexForImposterQuestion == questions.length - 1) {
        randomIndexForImposterQuestion--;
      } else {
        randomIndexForImposterQuestion++;
      }
    }

    return [questions[randomIndexForQuestion], questions[randomIndexForImposterQuestion]];
  }
}