import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/quiz_controller.dart';
import '../screens/category_screen.dart';
import '../widgets/primary_button.dart';
import '../widgets/stat_card.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizController = Get.find<QuizController>();
    final totalQuestions = quizController.questions.length;
    final correct = quizController.score.value;
    final wrong = totalQuestions - correct;
    final accuracy = totalQuestions == 0 ? 0 : ((correct / totalQuestions) * 100).round();
    final isSuccessful = accuracy >= 70;
    final totalSeconds = quizController.totalTimeSpent;
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: isSuccessful
                    ? Image.asset(
                        'images/congratulations.avif',
                        width: 180,
                        height: 180,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.celebration_rounded,
                          size: 72,
                          color: Color(0xFF0B817A),
                        ),
                      )
                    : const Icon(
                        Icons.auto_awesome_rounded,
                        size: 72,
                        color: Color(0xFFFF7043),
                      ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  isSuccessful ? 'Congratulations' : 'Keep Trying!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1C233A),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'You scored $correct/$totalQuestions!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1C233A),
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.35,
                children: [
                  StatCard(label: 'Score', value: '$correct / $totalQuestions', highlight: true),
                  StatCard(label: 'Accuracy', value: '$accuracy%'),
                  StatCard(label: 'Correct', value: '$correct'),
                  StatCard(label: 'Wrong', value: '$wrong'),
                ],
              ),
              const SizedBox(height: 18),
              StatCard(label: 'Total Time', value: '$minutes:$seconds'),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  isSuccessful
                      ? 'You have a great foundation. Try a different category next.'
                      : 'Keep practicing and try again to improve your score.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'PLAY AGAIN',
                onPressed: () {
                  quizController.resetQuiz();
                  Get.offAll(() => const CategoryScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
