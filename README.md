# Quizzical

A Flutter quiz application that lets users explore categories, answer questions, and view results in a polished mobile-friendly interface.

## Project Overview

This project is a trivia-style quiz app built with Flutter and GetX. It includes:

- Category selection screen
- Quiz configuration screen
- Question flow with score tracking
- Results summary screen
- Persistent quiz settings using SharedPreferences
- Custom theme and reusable UI components

## Features

- Browse quiz categories such as animals, sports, celebrities, geology, and more
- Start a quiz from a welcome screen
- Configure quiz settings before starting
- Show one question at a time with answer selection
- Calculate score and display final results
- Save and restore the previous quiz configuration

## Tech Stack

- Flutter
- Dart
- GetX for state management
- SharedPreferences for local storage
- Material Design UI

## Project Structure

- `lib/main.dart` — app entry point
- `lib/controllers/` — app logic for categories, quiz config, and quiz flow
- `lib/screens/` — welcome, category, quiz, and result screens
- `lib/models/` and `lib/services/` — quiz and category data handling
- `lib/theme/` — app theme styling
- `lib/widgets/` — reusable UI elements
- `test/` — project tests

## Getting Started

### Prerequisites

Make sure you have Flutter installed on your machine.

- Flutter SDK
- Android Studio / VS Code with Flutter extensions
- Emulator or physical device

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

This project uses local image assets and app-level configuration to create a complete quiz experience. You can extend it by adding new categories, new question sets, or enhanced result animations.

## License

This project is for educational and personal development use.
