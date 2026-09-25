import 'dart:convert';

import 'package:http/http.dart' as http;

import 'question_model.dart';

class QuestionServiceException implements Exception {
  const QuestionServiceException(this.message, {this.responseCode});

  final String message;
  final int? responseCode;

  @override
  String toString() => 'QuestionServiceException: $message';
}

class QuestionService {
  QuestionService({http.Client? client}) : _client = client ?? http.Client();

  static final Uri _questionsUri = Uri.parse('https://opentdb.com/api.php');

  final http.Client _client;

  static const _maxTransientRetries = 2;

  Future<List<QuestionModel>> getQuestions({
    required int amount,
    required int categoryId,
    required String difficulty,
    required String type,
  }) async {
    if (amount < 1 || amount > 50) {
      throw const QuestionServiceException('amount must be between 1 and 50.');
    }

    final queryParameters = <String, String>{
      'amount': '$amount',
      'category': '$categoryId',
      'type': _normalizeType(type),
    };

    if (difficulty.trim().isNotEmpty && difficulty.toLowerCase() != 'any') {
      queryParameters['difficulty'] = difficulty.toLowerCase();
    }

    final requestUri = _questionsUri.replace(
      queryParameters: queryParameters,
    );

    try {
      final response = await _getWithRetry(requestUri);

      if (response.statusCode != 200) {
        if (response.statusCode == 429) {
          throw const QuestionServiceException(
            'OpenTDB is temporarily rate-limiting requests. Please wait a moment and retry.',
          );
        }
        throw QuestionServiceException(
          'The questions request failed with HTTP status '
          '${response.statusCode}.',
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final responseCode = decoded['response_code'] as int?;

      if (responseCode != 0) {
        throw QuestionServiceException(
          _responseCodeMessage(responseCode),
          responseCode: responseCode,
        );
      }

      final results = decoded['results'] as List<dynamic>?;
      if (results == null) {
        throw const QuestionServiceException(
          'The questions response did not contain results.',
        );
      }

      return results
          .map(
            (question) =>
                QuestionModel.fromJson(question as Map<String, dynamic>),
          )
          .toList();
    } on QuestionServiceException {
      rethrow;
    } on FormatException catch (error) {
      throw QuestionServiceException(
        'The questions response was invalid: ${error.message}',
      );
    } on TypeError catch (error) {
      throw QuestionServiceException(
        'The questions response had an unexpected format: $error',
      );
    } on http.ClientException {
      throw const QuestionServiceException(
        'Unable to load questions because the network connection was interrupted. Please retry.',
      );
    } catch (_) {
      throw QuestionServiceException(
        'Unable to load questions right now. Please retry.',
      );
    }
  }

  Future<http.Response> _getWithRetry(Uri requestUri) async {
    for (var attempt = 0; attempt <= _maxTransientRetries; attempt++) {
      try {
        final response = await _client.get(requestUri);
        if (response.statusCode != 429 || attempt == _maxTransientRetries) {
          return response;
        }
        await Future<void>.delayed(Duration(milliseconds: 500 * (attempt + 1)));
      } on http.ClientException {
        if (attempt == _maxTransientRetries) {
          rethrow;
        }
        await Future<void>.delayed(Duration(milliseconds: 500 * (attempt + 1)));
      }
    }

    throw const QuestionServiceException(
      'Unable to load questions right now. Please retry.',
    );
  }

  String _responseCodeMessage(int? responseCode) {
    switch (responseCode) {
      case 1:
        return 'Not enough questions are available for this configuration. Reduce the amount or choose another difficulty.';
      case 2:
        return 'The quiz settings are invalid. Please check the amount, difficulty, and question type.';
      case 3:
        return 'The OpenTDB session expired. Please try again.';
      case 4:
        return 'The OpenTDB session is unavailable. Please try again.';
      case 5:
        return 'Too many quiz requests were made. Please try again later.';
      default:
        return 'OpenTDB returned an unknown response code: $responseCode.';
    }
  }

  String _normalizeType(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'boolean' || normalized == 'true / false') {
      return 'boolean';
    }
    return 'multiple';
  }
}
