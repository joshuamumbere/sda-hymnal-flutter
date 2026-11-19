import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sda_hymnal/sda_hymnal.dart';

void main() {
  final file = File('assets/sda-hymnal-db.json');

  test('database contains all 695 hymns', () {
    final data = jsonDecode(file.readAsStringSync()) as List<dynamic>;
    expect(data.length, 695);
  });

  test('every hymn has a number, title and non-empty lyrics', () {
    final data = jsonDecode(file.readAsStringSync()) as List<dynamic>;
    for (final entry in data) {
      final hymn = Hymn.fromJson(entry as Map<String, dynamic>);
      expect(hymn.number, inInclusiveRange(1, 695));
      expect(hymn.title, isNotEmpty);
      expect(hymn.lyrics, isNotEmpty);
      for (final section in hymn.lyrics) {
        expect(section.type, anyOf('verse', 'refrain'));
        expect(section.lines, isNotEmpty);
      }
    }
  });

  test('hymn 1 is Praise to the Lord', () {
    final data = jsonDecode(file.readAsStringSync()) as List<dynamic>;
    final hymn = Hymn.fromJson(data.first as Map<String, dynamic>);
    expect(hymn.number, 1);
    expect(hymn.title, 'Praise to the Lord');
    expect(hymn.verses, isNotEmpty);
    expect(hymn.verses.first.text, startsWith('Praise to the Lord'));
  });
}
