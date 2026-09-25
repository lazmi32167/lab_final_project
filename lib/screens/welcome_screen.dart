import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/category_asset_helper.dart';
import 'category_screen.dart';
import '../widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: Image.asset(
                    CategoryAssetHelper.welcomeAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF005C59),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Icon(
                        Icons.quiz_rounded,
                        color: Colors.white,
                        size: 54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Quizzical',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: const Color(0xFF1C233A),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your_Name',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF6B7280),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: 240,
                  child: PrimaryButton(
                    label: 'GET STARTED',
                    onPressed: () => Get.to(() => const CategoryScreen()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
