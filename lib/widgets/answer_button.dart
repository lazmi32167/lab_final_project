import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isSelected = false,
    this.isCorrect = false,
    this.isWrong = false,
    this.isDisabled = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color textColor = const Color(0xFF1C233A);
    Color borderColor = const Color(0xFFE8ECF7);

    if (isCorrect) {
      backgroundColor = const Color(0xFFDCFCE7);
      textColor = const Color(0xFF166534);
      borderColor = const Color(0xFF22C55E);
    } else if (isWrong) {
      backgroundColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFF991B1B);
      borderColor = const Color(0xFFEF4444);
    } else if (isSelected) {
      backgroundColor = const Color(0xFFD5EEEB);
      textColor = const Color(0xFF005C59);
      borderColor = const Color(0xFF0B817A);
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          minimumSize: const Size.fromHeight(58),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: borderColor, width: 1.7),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
