import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/quiz_config_controller.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/answer_button.dart';
import '../widgets/loading_widget.dart';
import '../screens/category_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizController quizController = Get.find<QuizController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (quizController.questions.isEmpty && !quizController.isLoading.value) {
        final config = Get.find<QuizConfigController>();
        quizController.loadQuestions(
          amount: config.amount.value,
          categoryId: config.selectedCategoryId.value,
          difficulty: config.difficulty.value,
          type: config.type.value,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        leading: IconButton(
          tooltip: 'Exit quiz',
          icon: const Icon(Icons.exit_to_app_rounded),
          onPressed: _confirmExit,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Obx(
                () => Text(
                  'Score ${quizController.score.value}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C233A),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (quizController.isLoading.value) {
            return const LoadingWidget(message: 'Loading questions...');
          }

          if (quizController.errorMessage.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      quizController.errorMessage.value,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: _retryQuestions,
                          child: const Text('Retry'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => Get.back(),
                          child: const Text('Change Configuration'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          if (!quizController.hasQuestions) {
            return const Center(child: Text('No questions available'));
          }

          final currentQuestion = quizController.currentQuestion;
          final questionNumber = quizController.currentQuestionIndex.value + 1;
          final totalQuestions = quizController.questions.length;

          return Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question $questionNumber of $totalQuestions',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF5B5CE2),
                            ),
                          ),
                          Obx(
                            () => Text(
                              '${quizController.remainingSeconds.value}s',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: quizController.remainingSeconds.value <= 5
                                    ? Colors.red
                                    : const Color(0xFF1C233A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: (questionNumber / totalQuestions).clamp(0.0, 1.0),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: const Color(0xFFE5E7EB),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5B5CE2)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Text(
                            currentQuestion.question,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color(0xFF1C233A),
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...List.generate(
                          quizController.shuffledAnswers.length,
                          (index) {
                            final option = quizController.shuffledAnswers[index];
                            final isSelected = quizController.selectedAnswer.value == option;
                            final isCorrect = option == currentQuestion.correctAnswer;
                            final showFeedback = quizController.isAnswered.value;
                            final isWrong = showFeedback && isSelected && option != currentQuestion.correctAnswer;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AnswerButton(
                                label: option,
                                isSelected: isSelected,
                                isCorrect: showFeedback && isCorrect,
                                isWrong: isWrong,
                                isDisabled: showFeedback,
                                onPressed: () => quizController.selectAnswer(option),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 18),
                        if (quizController.isAnswered.value)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: quizController.selectedAnswer.value == 'TIMEOUT'
                                  ? const Color(0xFFFFF7ED)
                                  : (quizController.selectedAnswer.value == currentQuestion.correctAnswer
                                      ? const Color(0xFFDCFCE7)
                                      : const Color(0xFFFEE2E2)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              quizController.selectedAnswer.value == 'TIMEOUT'
                                  ? 'Time is up! The correct answer is ${currentQuestion.correctAnswer}.'
                                  : (quizController.selectedAnswer.value == currentQuestion.correctAnswer
                                      ? 'Correct! Great job.'
                                      : 'Incorrect. The correct answer is ${currentQuestion.correctAnswer}.'),
                              style: TextStyle(
                                color: quizController.selectedAnswer.value == 'TIMEOUT'
                                    ? const Color(0xFF9A5B00)
                                    : (quizController.selectedAnswer.value == currentQuestion.correctAnswer
                                        ? const Color(0xFF166534)
                                        : const Color(0xFF991B1B)),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        const SizedBox(height: 18),
                        if (quizController.isAnswered.value)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: quizController.nextQuestion,
                              child: Text(
                                quizController.currentQuestionIndex.value < quizController.questions.length - 1
                                    ? 'Next'
                                    : 'View Results',
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<void> _retryQuestions() async {
    final config = Get.find<QuizConfigController>();
    await quizController.loadQuestions(
      amount: config.amount.value,
      categoryId: config.selectedCategoryId.value,
      difficulty: config.difficulty.value,
      type: config.type.value,
    );
  }

  Future<void> _confirmExit() async {
    final shouldExit = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Exit quiz?'),
        content: const Text('Are you sure you want to exit the quiz?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      quizController.resetQuiz();
      Get.offAll(() => const CategoryScreen());
    }
  }
}
