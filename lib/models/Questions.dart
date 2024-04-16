import 'dart:math';

class Questions {
  List<String> questions = [
    'This is a normal question',
    'This is an imposter question',
    'This is question 3',
    'This is question 4',
    'This is question 5',
    'This is question 6',
    'This is question 7',
    'This is question 8',
    'This is question 9',
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