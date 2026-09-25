import 'dart:async';

import 'package:get/get.dart';

import '../questions/question_model.dart';
import '../questions/question_service.dart';
import '../screens/result_screen.dart';

class QuizController extends GetxController {
  final QuestionService _questionService = QuestionService();

  final RxList<QuestionModel> questions = <QuestionModel>[].obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxInt score = 0.obs;
  final RxInt remainingSeconds = 20.obs;
  final RxBool isAnswered = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedAnswer = ''.obs;
  final RxList<String> shuffledAnswers = <String>[].obs;

  Timer? _timer;
  int totalTimeSpent = 0;

  QuestionModel get currentQuestion => questions[currentQuestionIndex.value];

  bool get hasQuestions => questions.isNotEmpty;

  int get totalQuestions => questions.length;

  Future<void> loadQuestions({
    required int amount,
    required int categoryId,
    required String difficulty,
    required String type,
  }) async {
    stopTimer();
    isLoading.value = true;
    errorMessage.value = '';
    questions.clear();
    score.value = 0;
    currentQuestionIndex.value = 0;
    totalTimeSpent = 0;
    selectedAnswer.value = '';
    isAnswered.value = false;

    try {
      QuestionServiceException? lastNotEnoughQuestionsError;

      for (final attemptAmount in _fallbackAmounts(amount)) {
        try {
          final loadedQuestions = await _questionService.getQuestions(
            amount: attemptAmount,
            categoryId: categoryId,
            difficulty: difficulty,
            type: type,
          );

          if (loadedQuestions.isEmpty) {
            throw const QuestionServiceException(
              'No questions were returned for the selected quiz settings.',
            );
          }

          questions.assignAll(loadedQuestions);
          prepareCurrentQuestion();
          return;
        } on QuestionServiceException catch (error) {
          if (error.responseCode != 1) {
            rethrow;
          }
          lastNotEnoughQuestionsError = error;
        }
      }

      throw QuestionServiceException(
        _fallbackFailureMessage(difficulty, type),
        responseCode: lastNotEnoughQuestionsError?.responseCode,
      );
    } on QuestionServiceException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = 'Unable to load questions right now.';
    } finally {
      isLoading.value = false;
    }
  }

  List<int> _fallbackAmounts(int requestedAmount) {
    final candidates = <int>[
      requestedAmount,
      requestedAmount ~/ 2,
      3,
      1,
    ];

    return candidates
        .where((candidate) => candidate >= 1 && candidate <= requestedAmount)
        .toSet()
        .toList();
  }

  String _fallbackFailureMessage(String difficulty, String type) {
    final selectedDifficulty = difficulty.trim().toLowerCase();
    final selectedType = type.trim().toLowerCase();

    if (selectedDifficulty != 'any') {
      return 'Not enough questions are available for this difficulty. Try Any Difficulty or choose another category.';
    }

    if (selectedType == 'boolean' || selectedType == 'true / false') {
      return 'Not enough questions are available for this question type. Try Multiple Choice or choose another category.';
    }

    return 'No questions are available for this configuration. Try changing the amount, difficulty, or category.';
  }

  void prepareCurrentQuestion() {
    if (!hasQuestions || currentQuestionIndex.value >= questions.length) {
      return;
    }

    stopTimer();
    selectedAnswer.value = '';
    isAnswered.value = false;
    remainingSeconds.value = 20;

    final current = questions[currentQuestionIndex.value];

    if (current.type.toLowerCase() == 'boolean') {
      shuffledAnswers.assignAll(['True', 'False']);
    } else {
      final options = <String>[...current.incorrectAnswers, current.correctAnswer];
      options.shuffle();
      shuffledAnswers.assignAll(options);
    }

    startTimer();
  }

  void startTimer() {
    stopTimer();
    if (isAnswered.value || !hasQuestions) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isAnswered.value) {
        stopTimer();
        return;
      }

      if (remainingSeconds.value <= 1) {
        remainingSeconds.value = 0;
        totalTimeSpent += 1;
        handleTimeout();
        return;
      }

      remainingSeconds.value -= 1;
      totalTimeSpent += 1;
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void selectAnswer(String answer) {
    if (isAnswered.value || !hasQuestions) {
      return;
    }

    selectedAnswer.value = answer;
    isAnswered.value = true;
    stopTimer();

    if (answer == currentQuestion.correctAnswer) {
      score.value += 1;
    }
  }

  void handleTimeout() {
    if (isAnswered.value) {
      return;
    }

    isAnswered.value = true;
    selectedAnswer.value = 'TIMEOUT';
    stopTimer();
  }

  void nextQuestion() {
    stopTimer();
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value += 1;
      prepareCurrentQuestion();
      return;
    }

    finishQuiz();
  }

  void finishQuiz() {
    stopTimer();
    Get.offAll(() => const ResultScreen());
  }

  void resetQuiz() {
    stopTimer();
    questions.clear();
    currentQuestionIndex.value = 0;
    score.value = 0;
    remainingSeconds.value = 20;
    isAnswered.value = false;
    selectedAnswer.value = '';
    shuffledAnswers.clear();
    isLoading.value = false;
    errorMessage.value = '';
    totalTimeSpent = 0;
  }

  @override
  void onClose() {
    stopTimer();
    super.onClose();
  }
}
