import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.message = 'Loading...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 18),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }
}
