import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/category_controller.dart';
import 'controllers/quiz_config_controller.dart';
import 'controllers/quiz_controller.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  Get.put(CategoryController(), permanent: true);
  final configController = Get.put(
    QuizConfigController(prefs: sharedPreferences),
    permanent: true,
  );
  Get.put(QuizController(), permanent: true);
  await configController.loadSavedConfig();

  runApp(const QuizzicalApp());
}

class QuizzicalApp extends StatelessWidget {
  const QuizzicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quizzical',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
    );
  }
}
