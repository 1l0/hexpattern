import 'dart:math';

import 'package:flutter/material.dart' hide Card;

// import 'package:google_fonts/google_fonts.dart';

import 'card.dart';

const sampleText =
    "t is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', \nmaking it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).";
const columnWidth = 640;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: NosutaTheme.light(),
      darkTheme: NosutaTheme.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const MockPage(),
    );
  }
}

class MockPage extends StatefulWidget {
  const MockPage({super.key});

  @override
  State<MockPage> createState() => _MockPageState();
}

class _MockPageState extends State<MockPage> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollToTop() {
    debugPrint('tapped');
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutBack,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: LayoutBuilder(builder: (context, constraints) {
        return CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              title: GestureDetector(
                onTap: scrollToTop,
                child: const Text('Title'),
              ),
              floating: true,
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth > 640
                      ? max(constraints.maxWidth - 640, 0) / 2
                      : 0),
              sliver: const SliverList(
                  delegate: SliverChildListDelegate.fixed([
                Card(
                  top: true,
                  name: 'reishisaza',
                  pubkeyHex:
                      '3c7d12a6c2f71fe9ca2527216f529a137bb0f2eb018b18f30003933b9532013e',
                  imageUrl:
                      'https://image.nostr.build/nostr.build_011c3ed72e650b3a46e4d8cc78bdebbe0d2267ff18ff534380c501adba07db7b.png',
                  text: 'テスト　テスト。',
                ),
                Card(
                  name: 'fiatjaf',
                  pubkeyHex:
                      '3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d',
                  imageUrl: 'https://fiatjaf.com/static/favicon.jpg',
                  text: '@sepehr does osty.dev come with built-in components?',
                ),
                Card(
                  name: 'jack',
                  pubkeyHex:
                      '82341f882b6eabcd2ba7f1ef90aad961cf074af15b9ef44a09f9d2a8fbfbe6a2',
                  imageUrl:
                      'https://pfp.nostr.build/nostr.build_6b9909bccf0f4fdaf7aacd9bc01e4ce70dab86f7d90395f2ce925e6ea06ed7cd.jpeg',
                  text: 'yes',
                ),
                Card(
                  name: 'サンプルユーザー🥹サンプルユーザー サンプルユーザー サンプルユーザ',
                  // name: 'サンプルユーザー🥹',
                  pubkeyHex:
                      'ae6df144a3c0f76abf304a786663b2e7d2a14942e08e7ddc04f7ebff0d7add2a',
                  imageUrl:
                      'https://cdn.zebedee.io/uploads/3dd3eab9-80db-4bf3-b02e-40c1a53df2d3_0c94b03c-af87-465c-ac9c-5b43c18e6351.png',
                  text: sampleText,
                ),
                Card(
                  name: 'reishisaza',
                  pubkeyHex:
                      '3c7d12a6c2f71fe9ca2527216f529a137bb0f2eb018b18f30003933b9532013e',
                  imageUrl:
                      'https://image.nostr.build/nostr.build_011c3ed72e650b3a46e4d8cc78bdebbe0d2267ff18ff534380c501adba07db7b.png',
                  text: 'テスト　テスト。',
                ),
                Card(
                  name: 'fiatjaf',
                  pubkeyHex:
                      '3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d',
                  imageUrl: 'https://fiatjaf.com/static/favicon.jpg',
                  text: '@sepehr does osty.dev come with built-in components?',
                ),
                Card(
                  name: 'jack',
                  pubkeyHex:
                      '82341f882b6eabcd2ba7f1ef90aad961cf074af15b9ef44a09f9d2a8fbfbe6a2',
                  imageUrl:
                      'https://pfp.nostr.build/nostr.build_6b9909bccf0f4fdaf7aacd9bc01e4ce70dab86f7d90395f2ce925e6ea06ed7cd.jpeg',
                  text: 'yes',
                ),
                Card(
                  name: 'サンプルユーザー🥹サンプルユーザー サンプルユーザー サンプルユーザ',
                  // name: 'サンプルユーザー🥹',
                  pubkeyHex:
                      'ae6df144a3c0f76abf304a786663b2e7d2a14942e08e7ddc04f7ebff0d7add2a',
                  imageUrl:
                      'https://cdn.zebedee.io/uploads/3dd3eab9-80db-4bf3-b02e-40c1a53df2d3_0c94b03c-af87-465c-ac9c-5b43c18e6351.png',
                  text: sampleText,
                ),
                Card(
                  name: 'reishisaza',
                  pubkeyHex:
                      '3c7d12a6c2f71fe9ca2527216f529a137bb0f2eb018b18f30003933b9532013e',
                  imageUrl:
                      'https://image.nostr.build/nostr.build_011c3ed72e650b3a46e4d8cc78bdebbe0d2267ff18ff534380c501adba07db7b.png',
                  text: 'テスト　テスト。',
                ),
                Card(
                  name: 'fiatjaf',
                  pubkeyHex:
                      '3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d',
                  imageUrl: 'https://fiatjaf.com/static/favicon.jpg',
                  text: '@sepehr does osty.dev come with built-in components?',
                ),
                Card(
                  name: 'jack',
                  pubkeyHex:
                      '82341f882b6eabcd2ba7f1ef90aad961cf074af15b9ef44a09f9d2a8fbfbe6a2',
                  imageUrl:
                      'https://pfp.nostr.build/nostr.build_6b9909bccf0f4fdaf7aacd9bc01e4ce70dab86f7d90395f2ce925e6ea06ed7cd.jpeg',
                  text: 'yes',
                ),
                Card(
                  name: 'サンプルユーザー🥹サンプルユーザー サンプルユーザー サンプルユーザ',
                  // name: 'サンプルユーザー🥹',
                  pubkeyHex:
                      'ae6df144a3c0f76abf304a786663b2e7d2a14942e08e7ddc04f7ebff0d7add2a',
                  imageUrl:
                      'https://cdn.zebedee.io/uploads/3dd3eab9-80db-4bf3-b02e-40c1a53df2d3_0c94b03c-af87-465c-ac9c-5b43c18e6351.png',
                  text: sampleText,
                ),
              ])),
            ),
          ],
        );
      }),
    );
  }
}

class NosutaTheme {
  static ThemeData dark() {
    final td = ThemeData.from(
      colorScheme: const ColorScheme.dark(
        primary: Color.fromARGB(255, 255, 255, 255),
        secondary: Color.fromARGB(255, 110, 184, 221),
        onSecondaryContainer: Color.fromARGB(255, 255, 255, 255),
        surface: Color.fromARGB(255, 29, 29, 29),
        onSurface: Color.fromARGB(255, 207, 207, 207),
        onSurfaceVariant: Color.fromARGB(255, 137, 137, 137),
        outlineVariant: Color.fromARGB(255, 66, 66, 66),
      ),
    );
    return td;
    // return td.copyWith(
    //     textTheme: GoogleFonts.notoSansJpTextTheme(td.textTheme));
  }

  static ThemeData light() {
    // final tdo = ThemeData(fontFamily: 'Toppan Bunkyu Gothic Regular');
    final td = ThemeData.from(
      colorScheme: const ColorScheme.light(
        primary: Color.fromARGB(255, 0, 0, 0),
        secondary: Color.fromARGB(255, 0, 170, 255),
        onSecondaryContainer: Color.fromARGB(255, 0, 0, 0),
        surface: Color.fromARGB(255, 255, 255, 255),
        onSurface: Color.fromARGB(255, 0, 0, 0),
        onSurfaceVariant: Color.fromARGB(255, 128, 128, 128),
        surfaceContainer: Color.fromARGB(255, 255, 255, 255),
        outlineVariant: Color.fromARGB(255, 229, 229, 229),
      ),
    );
    return td;
    // return td.copyWith(
    //     textTheme: GoogleFonts.notoSansJpTextTheme(td.textTheme));
  }
}
