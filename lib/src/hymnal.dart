import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'models.dart';

/// Loader and search helpers for the Seventh-Day Adventist Hymnal.
///
/// The full 695-hymn database ships as an asset inside the package, so
/// no extra configuration is needed by consuming apps:
///
/// ```dart
/// final hymns = await SdaHymnal.load();
/// final hymn = await SdaHymnal.byNumber(1); // Praise to the Lord
/// final results = await SdaHymnal.search('amazing');
/// ```
abstract final class SdaHymnal {
  static List<Hymn>? _cache;

  /// Loads all 695 hymns from the bundled database.
  ///
  /// The result is cached after the first call.
  static Future<List<Hymn>> load() async {
    final cached = _cache;
    if (cached != null) return cached;

    final raw = await rootBundle
        .loadString('packages/sda_hymnal/assets/sda-hymnal-db.json');
    final List<dynamic> data = jsonDecode(raw) as List<dynamic>;
    final hymns = data
        .map((e) => Hymn.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    _cache = hymns;
    return hymns;
  }

  /// Returns the hymn with the given [number], or `null` if not found.
  static Future<Hymn?> byNumber(int number) async {
    final hymns = await load();
    for (final hymn in hymns) {
      if (hymn.number == number) return hymn;
    }
    return null;
  }

  /// Returns hymns whose title contains [query] (case-insensitive).
  static Future<List<Hymn>> search(String query) async {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return const [];
    final hymns = await load();
    return hymns
        .where((hymn) => hymn.title.toLowerCase().contains(needle))
        .toList(growable: false);
  }
}
