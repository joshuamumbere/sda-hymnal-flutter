/// Data models for the SDA Hymnal.
library;

/// A single section of a hymn's lyrics — either a verse or a refrain.
class LyricSection {
  /// Creates a lyric section.
  const LyricSection({
    required this.type,
    required this.index,
    required this.lines,
  });

  /// Deserializes a lyric section from the hymnal database JSON.
  factory LyricSection.fromJson(Map<String, dynamic> json) {
    return LyricSection(
      type: json['type'] as String,
      index: json['index'] as int,
      lines: (json['lines'] as List<dynamic>).cast<String>(),
    );
  }

  /// `"verse"` or `"refrain"`.
  final String type;

  /// 1-based verse index; refrains use `0`.
  final int index;

  /// The individual text lines of this section.
  final List<String> lines;

  /// The full text of this section, lines joined with newlines.
  String get text => lines.join('\n');

  @override
  String toString() => 'LyricSection(${type}_$index)';
}

/// A hymn from the Seventh-Day Adventist Hymnal.
class Hymn {
  /// Creates a hymn.
  const Hymn({
    required this.index,
    required this.number,
    required this.title,
    required this.lyrics,
  });

  /// Deserializes a hymn from the hymnal database JSON.
  factory Hymn.fromJson(Map<String, dynamic> json) {
    return Hymn(
      index: json['index'] as String,
      number: json['number'] as int,
      title: json['title'] as String,
      lyrics: (json['lyrics'] as List<dynamic>)
          .map((e) => LyricSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Zero-padded hymn number as used in the database, e.g. `"001"`.
  final String index;

  /// The hymn number, e.g. `1`.
  final int number;

  /// The hymn title, e.g. `"Praise to the Lord"`.
  final String title;

  /// The verses and refrains of the hymn, in order.
  final List<LyricSection> lyrics;

  /// All lyric sections of type `"verse"`.
  Iterable<LyricSection> get verses =>
      lyrics.where((s) => s.type == 'verse');

  /// All lyric sections of type `"refrain"`.
  Iterable<LyricSection> get refrains =>
      lyrics.where((s) => s.type == 'refrain');

  /// The full text of the hymn, sections separated by blank lines.
  String get text => lyrics.map((s) => s.text).join('\n\n');

  @override
  String toString() => 'Hymn($number: $title)';
}
