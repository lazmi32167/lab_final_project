import 'dart:convert';

import 'package:http/http.dart' as http;

import 'category_model.dart';

class CategoryServiceException implements Exception {
  const CategoryServiceException(this.message);

  final String message;

  @override
  String toString() => 'CategoryServiceException: $message';
}

class CategoryService {
  CategoryService({http.Client? client}) : _client = client ?? http.Client();

  static final Uri _categoriesUri = Uri.parse(
    'https://opentdb.com/api_category.php',
  );

  final http.Client _client;

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _client.get(_categoriesUri);

      if (response.statusCode != 200) {
        throw CategoryServiceException(
          'The categories request failed with HTTP status '
          '${response.statusCode}.',
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final categories = decoded['trivia_categories'] as List<dynamic>?;

      if (categories == null) {
        throw const CategoryServiceException(
          'The categories response did not contain trivia_categories.',
        );
      }

      return categories
          .map(
            (category) =>
                CategoryModel.fromJson(category as Map<String, dynamic>),
          )
          .toList();
    } on CategoryServiceException {
      rethrow;
    } on FormatException catch (error) {
      throw CategoryServiceException(
        'The categories response was invalid: ${error.message}',
      );
    } on TypeError catch (error) {
      throw CategoryServiceException(
        'The categories response had an unexpected format: $error',
      );
    } catch (error) {
      throw CategoryServiceException(
        'Unable to load categories because of a network error: $error',
      );
    }
  }
}
