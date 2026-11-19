import 'package:flutter/material.dart';

import 'package:sda_hymnal/sda_hymnal.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SDA Hymnal Example',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HymnListPage(),
    );
  }
}

class HymnListPage extends StatefulWidget {
  const HymnListPage({super.key});

  @override
  State<HymnListPage> createState() => _HymnListPageState();
}

class _HymnListPageState extends State<HymnListPage> {
  List<Hymn> _hymns = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    SdaHymnal.load().then((hymns) {
      setState(() {
        _hymns = hymns;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SDA Hymnal — 695 hymns')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _hymns.length,
              itemBuilder: (context, i) {
                final hymn = _hymns[i];
                return ListTile(
                  leading: Text('${hymn.number}'),
                  title: Text(hymn.title),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => HymnPage(hymn: hymn),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class HymnPage extends StatelessWidget {
  const HymnPage({super.key, required this.hymn});

  final Hymn hymn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${hymn.number}. ${hymn.title}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final section in hymn.lyrics) ...[
            Text(
              section.text,
              style: section.type == 'refrain'
                  ? const TextStyle(fontStyle: FontStyle.italic)
                  : null,
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
