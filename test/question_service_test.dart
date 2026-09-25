import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:lab_final_project/questions/question_service.dart';

class _FakeClient extends http.BaseClient {
  _FakeClient(this.body, {this.statusCode = 200});

  final String body;
  final int statusCode;
  Uri? requestedUri;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requestedUri = request.url;
    return http.StreamedResponse(
      Stream.value(utf8.encode(body)),
      statusCode,
      headers: const {'content-type': 'application/json'},
    );
  }
}

void main() {
  test('omits Any difficulty and maps Multiple Choice', () async {
    final client = _FakeClient('''
      {"response_code":0,"results":[{
        "type":"multiple","difficulty":"easy","category":"General Knowledge",
        "question":"How many colors are there in a rainbow?",
        "correct_answer":"7","incorrect_answers":["8","9","10"]
      }]}
    ''');

    final questions = await QuestionService(client: client).getQuestions(
      amount: 10,
      categoryId: 9,
      difficulty: 'Any',
      type: 'Multiple Choice',
    );

    expect(client.requestedUri?.queryParameters, {
      'amount': '10',
      'category': '9',
      'type': 'multiple',
    });
    expect(questions.single.question, 'How many colors are there in a rainbow?');
    expect(questions.single.incorrectAnswers, ['8', '9', '10']);
  });

  test('maps True / False and lowercase difficulty', () async {
    final client = _FakeClient('{"response_code":0,"results":[]}');

    await QuestionService(client: client).getQuestions(
      amount: 1,
      categoryId: 9,
      difficulty: 'Easy',
      type: 'True / False',
    );

    expect(client.requestedUri?.queryParameters, {
      'amount': '1',
      'category': '9',
      'difficulty': 'easy',
      'type': 'boolean',
    });
  });

  test('converts OpenTDB response codes to an exception', () async {
    final client = _FakeClient('{"response_code":1,"results":[]}');

    expect(
      () => QuestionService(client: client).getQuestions(
        amount: 10,
        categoryId: 9,
        difficulty: 'Any',
        type: 'Multiple Choice',
      ),
      throwsA(
        isA<QuestionServiceException>().having(
          (error) => error.message,
          'message',
          contains('Not enough questions'),
        ),
      ),
    );
  });

  test('gives a retryable message after rate limiting', () async {
    final client = _FakeClient('', statusCode: 429);

    expect(
      () => QuestionService(client: client).getQuestions(
        amount: 1,
        categoryId: 9,
        difficulty: 'Any',
        type: 'Multiple Choice',
      ),
      throwsA(
        isA<QuestionServiceException>().having(
          (error) => error.message,
          'message',
          contains('rate-limiting'),
        ),
      ),
    );
  });
}
