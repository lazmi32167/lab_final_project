class QuestionModel {
  const QuestionModel({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  final String type;
  final String difficulty;
  final String category;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      type: _decodeHtml(json['type'] as String),
      difficulty: _decodeHtml(json['difficulty'] as String),
      category: _decodeHtml(json['category'] as String),
      question: _decodeHtml(json['question'] as String),
      correctAnswer: _decodeHtml(json['correct_answer'] as String),
      incorrectAnswers: (json['incorrect_answers'] as List<dynamic>)
          .map((answer) => _decodeHtml(answer as String))
          .toList(),
    );
  }

  static String _decodeHtml(String input) {
    return input
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&rsquo;', '’')
        .replaceAll('&lsquo;', '‘')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x2F;', '/')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&ndash;', '–')
        .replaceAll('&mdash;', '—');
  }
}
