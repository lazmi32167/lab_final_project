import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizConfigController extends GetxController {
  QuizConfigController({required this._prefs});

  final SharedPreferences _prefs;

  static const _selectedCategoryIdKey = 'selected_category_id';
  static const _selectedCategoryNameKey = 'selected_category_name';
  static const _amountKey = 'quiz_amount';
  static const _difficultyKey = 'quiz_difficulty';
  static const _typeKey = 'quiz_type';

  final RxInt selectedCategoryId = (-1).obs;
  final RxString selectedCategoryName = ''.obs;
  final RxInt amount = 10.obs;
  final RxString difficulty = 'Any'.obs;
  final RxString type = 'Multiple Choice'.obs;

  Future<void> loadSavedConfig() async {
    selectedCategoryId.value = _prefs.getInt(_selectedCategoryIdKey) ?? -1;
    selectedCategoryName.value =
        _prefs.getString(_selectedCategoryNameKey) ?? 'General Knowledge';
    amount.value = _prefs.getInt(_amountKey) ?? 10;
    difficulty.value = _prefs.getString(_difficultyKey) ?? 'Any';
    type.value = _prefs.getString(_typeKey) ?? 'Multiple Choice';

    if (amount.value < 1 || amount.value > 50) {
      amount.value = 10;
    }

    if (difficulty.value.trim().isEmpty) {
      difficulty.value = 'Any';
    }

    if (type.value.trim().isEmpty) {
      type.value = 'Multiple Choice';
    }
  }

  Future<void> saveSelectedCategory({
    required int id,
    required String name,
  }) async {
    selectedCategoryId.value = id;
    selectedCategoryName.value = name;
    await _prefs.setInt(_selectedCategoryIdKey, id);
    await _prefs.setString(_selectedCategoryNameKey, name);
  }

  Future<void> saveConfig() async {
    await _prefs.setInt(_amountKey, amount.value);
    await _prefs.setString(_difficultyKey, difficulty.value);
    await _prefs.setString(_typeKey, type.value);

    if (selectedCategoryId.value > 0) {
      await _prefs.setInt(_selectedCategoryIdKey, selectedCategoryId.value);
    }

    if (selectedCategoryName.value.isNotEmpty) {
      await _prefs.setString(
        _selectedCategoryNameKey,
        selectedCategoryName.value,
      );
    }
  }

  bool get hasSelectedCategory => selectedCategoryId.value > 0;
}
