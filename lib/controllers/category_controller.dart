import 'package:get/get.dart';

import '../categories/category_model.dart';
import '../categories/category_service.dart';

class CategoryController extends GetxController {
  final CategoryService _categoryService = CategoryService();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  bool _hasLoadedOnce = false;

  Future<void> loadCategories() async {
    if (_hasLoadedOnce && categories.isNotEmpty) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final loadedCategories = await _categoryService.getCategories();
      categories.assignAll(loadedCategories);
      _hasLoadedOnce = true;
    } on CategoryServiceException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = 'Unable to load categories right now.';
    } finally {
      isLoading.value = false;
    }
  }

  void retry() {
    _hasLoadedOnce = false;
    loadCategories();
  }
}
