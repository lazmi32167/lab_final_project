# Quizzical

Quizzical is a Flutter quiz application built as a final project for mobile app development. The app lets users browse trivia categories, customize their quiz, answer timed questions, and see a complete result summary at the end of each session.

## Project Overview

This project is a complete trivia game experience with a polished UI and data-driven question flow. It pulls categories and questions from the Open Trivia Database (OpenTDB), stores user preferences locally, and provides a smooth quiz interaction from start to finish.

## Features

- Welcome screen with branded app introduction
- Category selection screen with grid layout and category-specific visuals
- Quiz configuration for:
  - question count
  - difficulty level
  - question type
- Timed quiz flow with 20-second countdown per question
- Shuffled answer choices
- Immediate feedback for correct, incorrect, and timed-out answers
- Progress tracking across the quiz
- Score calculation and result summary
- Play again flow to restart from category selection
- API error handling and retry states
- Persistent configuration using SharedPreferences
- Responsive design for different screen sizes
- State management with GetX

## Main Screens

1. Welcome Screen
2. Category Selection Screen
3. Quiz Setup Screen
4. Quiz Play Screen
5. Result Screen

## Tech Stack

- Flutter
- Dart
- GetX
- HTTP
- SharedPreferences
- OpenTDb API

## App Flow

- User opens the app and lands on the Welcome screen.
- The app loads available categories from the OpenTDB API.
- The user selects a category and configures quiz preferences.
- The app fetches quiz questions based on the selected settings.
- Questions are shown one at a time with countdown timing.
- The user answers each question and receives feedback.
- Final score, accuracy, and total time are displayed at the end.

## API Integration

The app uses the Open Trivia Database API for both category and question data.

### Category endpoint

```text
https://opentdb.com/api_category.php
```

### Questions endpoint

```text
https://opentdb.com/api.php
```

The service layer validates response codes, handles invalid data formats, retries transient rate-limit issues, and presents user-friendly messages when a quiz configuration is not possible.

## Project Structure

```text
lib/
├── categories/
│   ├── category_model.dart
│   └── category_service.dart
├── controllers/
│   ├── category_controller.dart
│   ├── quiz_config_controller.dart
│   └── quiz_controller.dart
├── helpers/
│   └── category_asset_helper.dart
├── questions/
│   ├── question_model.dart
│   └── question_service.dart
├── screens/
│   ├── category_screen.dart
│   ├── quiz_config_screen.dart
│   ├── quiz_screen.dart
│   ├── result_screen.dart
│   └── welcome_screen.dart
├── theme/
│   └── app_theme.dart
├── widgets/
│   ├── answer_button.dart
│   ├── category_card.dart
│   ├── error_retry_widget.dart
│   ├── loading_widget.dart
│   ├── primary_button.dart
│   └── stat_card.dart
├── main.dart
└── ...
```

## State and Data Management

- `CategoryController` loads and tracks categories
- `QuizConfigController` stores selected category and user quiz settings
- `QuizController` handles question loading, answer flow, timer logic, scoring, and navigation
- Persistent settings are saved locally using SharedPreferences

## Getting Started

### Prerequisites

- Flutter SDK installed
- Android emulator, iOS simulator, or physical device
- VS Code or Android Studio

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

### Run tests

```bash
flutter test
```

## Notes

- The quiz uses the default app theme with a clean teal/neutral look.
- Category and quiz settings are saved for later use.
- If a selected configuration does not have enough available questions, the app shows a clear error and suggests trying another configuration.
- The project includes unit tests for the quiz question service logic.

## License

This project is for educational and personal use as part of a Flutter final project.