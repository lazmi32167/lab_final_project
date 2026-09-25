import 'package:flutter/foundation.dart';

class CategoryAssetHelper {
  static const String welcomeAsset = 'images/Home_page_image.png';

  static const Map<String, String> _assetsByCategory = {
    'animals': 'images/animals.avif',
    'art': 'images/art.jpg',
    'celebrities': 'images/celebrities.avif',
    'geography': 'images/geology.avif',
    'sports': 'images/sports.avif',
    'vehicles': 'images/vehicles.jpg',
    'general knowledge': 'images/general_knowledge.jpg',
    'history': 'images/history.jpg',
    'mythology': 'images/mythology.webp',
    'politics': 'images/politics.png',
    'science & nature': 'images/science_and_nature.jpg',
    'science: computers': 'images/science_computer.webp',
    'science: gadgets': 'images/science_gadgets.jpg',
    'science: mathematics': 'images/science_mathematics.jpg',
    'entertainment: board games': 'images/entertainment-board_games.webp',
    'entertainment: books': 'images/entertainment_books.jpg',
    'entertainment: cartoon & animations':
        'images/entertainment_cartoons_animations.jpg',
    'entertainment: comics': 'images/entertainment_comics.png',
    'entertainment: film': 'images/entertainment_film.jpg',
    'entertainment: japanese anime & manga':
        'images/entertainment_japanese_anime_and_manga.webp',
    'entertainment: music': 'images/entertainment_music.png',
    'entertainment: musicals & theatres':
        'images/entertainment_musicals_and_theatres.webp',
    'entertainment: television': 'images/entertainment_television.jpg',
    'entertainment: video games': 'images/entertainment_video_games.jpg',
  };

  static String? getCategoryImage(String categoryName) {
    final normalizedName = _normalize(categoryName);
    final asset = _assetsByCategory[normalizedName];

    if (asset == null) {
      debugPrint('No asset found for category: $categoryName');
    } else {
      debugPrint('Category: $categoryName\nAsset: $asset');
    }

    return asset;
  }

  static String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
