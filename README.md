# sda_hymnal

The complete **Seventh-Day Adventist Hymnal** for Flutter — all **695 hymns** with
structured lyrics (verses and refrains), shipped as a package asset so it works
out of the box with no setup.

## Features

- Full SDA Hymnal: 695 hymns, hymns 1–695
- Structured lyrics: verses and refrains as separate sections
- Simple async API with in-memory caching
- Search by title and lookup by hymn number

## Installation

```sh
flutter pub add sda_hymnal
```

## Usage

```dart
import 'package:sda_hymnal/sda_hymnal.dart';

final hymns = await SdaHymnal.load();          // all 695 hymns
final hymn = await SdaHymnal.byNumber(1);      // Hymn 1: Praise to the Lord
final results = await SdaHymnal.search('amazing');
```

Rendering a hymn:

```dart
final hymn = await SdaHymnal.byNumber(19);

Text(hymn!.title, style: Theme.of(context).textTheme.headlineSmall);

for (final section in hymn.lyrics) {
  if (section.type == 'refrain') {
    Text(section.text, style: const TextStyle(fontStyle: FontStyle.italic));
  } else {
    Text(section.text);
  }
}
```

## Data model

| Model | Fields |
|---|---|
| `Hymn` | `index` (`"001"`), `number` (`1`), `title`, `lyrics` |
| `LyricSection` | `type` (`"verse"` / `"refrain"`), `index`, `lines` |

## Related projects

The source hymnal data was extracted in the
[sda-hymnal](https://github.com/joshuamumbere/sda-hymnal) web project
(Vue 3 + Vite).

## License

MIT — see [LICENSE](LICENSE).
