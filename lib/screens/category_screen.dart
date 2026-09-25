import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/category_controller.dart';
import '../controllers/quiz_config_controller.dart';
import '../helpers/category_asset_helper.dart';
import '../widgets/category_card.dart';
import '../widgets/error_retry_widget.dart';
import '../widgets/loading_widget.dart';
import 'quiz_config_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryController.loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a category'),
      ),
      body: SafeArea(
        child: Obx(() {
          if (categoryController.isLoading.value) {
            return const LoadingWidget(message: 'Loading categories...');
          }

          if (categoryController.errorMessage.value.isNotEmpty) {
            return ErrorRetryWidget(
              message: categoryController.errorMessage.value,
              onRetry: categoryController.retry,
            );
          }

          if (categoryController.categories.isEmpty) {
            return ErrorRetryWidget(
              message: 'No categories are available right now.',
              onRetry: categoryController.retry,
            );
          }

          final crossAxisCount = MediaQuery.sizeOf(context).width < 420 ? 2 : 3;

          return Padding(
            padding: const EdgeInsets.all(18),
            child: GridView.builder(
              itemCount: categoryController.categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.9,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (context, index) {
                final category = categoryController.categories[index];
                final accentColors = const [
                  Color(0xFF5B5CE2),
                  Color(0xFF7C4DFF),
                  Color(0xFF0EA5E9),
                  Color(0xFF22C55E),
                  Color(0xFFF59E0B),
                  Color(0xFFEF4444),
                  Color(0xFF10B981),
                  Color(0xFFEC4899),
                ];

                final accent = accentColors[index % accentColors.length];
                final icon = _categoryIcon(category.name);
                final imagePath = CategoryAssetHelper.getCategoryImage(
                  category.name,
                );

                return CategoryCard(
                  name: category.name,
                  icon: icon,
                  accentColor: accent,
                  imagePath: imagePath,
                  onTap: () {
                    final configController = Get.find<QuizConfigController>();
                    configController.saveSelectedCategory(
                      id: category.id,
                      name: category.name,
                    );
                    Get.to(() => const QuizConfigScreen());
                  },
                );
              },
            ),
          );
        }),
      ),
    );
  }

  IconData _categoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('science')) return Icons.science_rounded;
    if (name.contains('film')) return Icons.movie_rounded;
    if (name.contains('music')) return Icons.music_note_rounded;
    if (name.contains('sport')) return Icons.sports_soccer_rounded;
    if (name.contains('geography')) return Icons.public_rounded;
    if (name.contains('history')) return Icons.history_edu_rounded;
    if (name.contains('computer')) return Icons.computer_rounded;
    if (name.contains('art')) return Icons.palette_rounded;
    if (name.contains('animal')) return Icons.pets_rounded;
    return Icons.category_rounded;
  }
}
