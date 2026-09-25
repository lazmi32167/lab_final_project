import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/quiz_config_controller.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/loading_widget.dart';
import '../widgets/primary_button.dart';
import 'quiz_screen.dart';

class QuizConfigScreen extends StatelessWidget {
  const QuizConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final configController = Get.find<QuizConfigController>();
    final quizController = Get.find<QuizController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz setup')),
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  configController.selectedCategoryName.value.isNotEmpty
                      ? configController.selectedCategoryName.value
                      : 'Selected category',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1C233A),
                  ),
                ),
                const SizedBox(height: 28),
                _buildSliderCard(
                  context,
                  title: 'Amount',
                  value: configController.amount.value.toDouble(),
                  min: 1,
                  max: 50,
                  onChanged: (value) {
                    configController.amount.value = value.round();
                  },
                ),
                const SizedBox(height: 18),
                _buildDropdownCard(
                  context,
                  title: 'Difficulty',
                  value: configController.difficulty.value,
                  options: const ['Any', 'Easy', 'Medium', 'Hard'],
                  onChanged: (value) {
                    if (value != null) configController.difficulty.value = value;
                  },
                ),
                const SizedBox(height: 18),
                _buildDropdownCard(
                  context,
                  title: 'Type',
                  value: configController.type.value,
                  options: const ['Multiple Choice', 'True / False'],
                  onChanged: (value) {
                    if (value != null) configController.type.value = value;
                  },
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: 'Start Quiz',
                  isLoading: quizController.isLoading.value,
                  onPressed: () async {
                    final amount = configController.amount.value;
                    if (!configController.hasSelectedCategory) {
                      Get.snackbar(
                        'Select a category',
                        'Please choose a category before starting the quiz.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    if (amount < 1 || amount > 50) {
                      Get.snackbar(
                        'Invalid amount',
                        'Question amount must be between 1 and 50.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    await configController.saveConfig();
                    try {
                      await quizController.loadQuestions(
                        amount: amount,
                        categoryId: configController.selectedCategoryId.value,
                        difficulty: configController.difficulty.value,
                        type: configController.type.value,
                      );

                      if (quizController.errorMessage.value.isNotEmpty) {
                        Get.snackbar(
                          'Change configuration',
                          quizController.errorMessage.value,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      if (quizController.questions.isEmpty) {
                        Get.snackbar(
                          'No questions',
                          'This category does not have enough questions for the current settings.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      Get.to(() => const QuizScreen());
                    } finally {
                      quizController.isLoading.value = false;
                    }
                  },
                ),
                if (quizController.isLoading.value)
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: LoadingWidget(message: 'Preparing quiz...'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderCard(
    BuildContext context, {
    required String title,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1C233A),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value.round().toString(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF5B5CE2),
            ),
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: 49,
            label: value.round().toString(),
            activeColor: const Color(0xFF5B5CE2),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownCard(
    BuildContext context, {
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1C233A),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: options.contains(value) ? value : options.first,
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
            items: options
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
