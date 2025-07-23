import 'dart:async';
import 'dart:math' as math;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:statescope/statescope.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:web/web.dart' as web;

import 'package:hexpattern/hexpattern.dart';

const contentColumnWidth = 620.0;
const title = 'nostr pubkey shape';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    StateScope(
      creator: () => ThemeState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeState>();
    return MaterialApp(
      title: title,
      theme: DemoTheme.light(),
      darkTheme: DemoTheme.dark(),
      themeMode: themeState.themeMode,
      debugShowCheckedModeBanner: false,
      home: const Demo(),
    );
  }
}

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  final scrollController = ScrollController();
  final textEditingController = TextEditingController(text: '');

  String? pubkey;

  @override
  void initState() {
    super.initState();
    validate();
    textEditingController.addListener(() {
      validate();
    });
    unawaited(_getPublicKey());
  }

  @override
  void dispose() {
    scrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  void validate() {
    String? output;
    final input = textEditingController.text.trim();
    if (input.startsWith('npub1')) {
      try {
        final decoded = Nip19.decodePubkey(input);
        if (decoded.isNotEmpty) {
          output = input;
        }
      } catch (_) {
        output = null;
      }
    } else if (input.length == 64 && isHexadecimal(input)) {
      output = input;
    }
    setState(() {
      pubkey = output;
    });
  }

  Future<void> goToRepo() async {
    final parsed = Uri.parse('https://github.com/1l0/hexpattern');
    if (!await launchUrl(parsed)) {
      throw Exception('Could not launch ${parsed.path}');
    }
  }

  Future<void> _getPublicKey() async {
    final n = web.window.getProperty('nostr'.toJS).jsify();
    if (n.isUndefinedOrNull) {
      return;
    }
    final nostr = n as JSObject;
    nostr.callMethod(
      'on'.toJS,
      'accountChanged'.toJS,
      (() {
        final getPublicKey =
            nostr.callMethod<JSPromise<JSString>>('getPublicKey'.toJS);
        if (getPublicKey.isUndefinedOrNull) {
          return;
        }
        getPublicKey.toDart.then((pkjs) {
          if (pkjs.isUndefinedOrNull) {
            return;
          }
          textEditingController.text = pkjs.toDart;
        });
      }).toJS,
    );

    final getPublicKey =
        nostr.callMethod<JSPromise<JSString>>('getPublicKey'.toJS);
    if (getPublicKey.isUndefinedOrNull) {
      return;
    }
    final pkjs = await getPublicKey.toDart;
    if (pkjs.isUndefinedOrNull) {
      return;
    }
    textEditingController.text = pkjs.toDart;
  }

  @override
  Widget build(BuildContext context) {
    final colScheme = Theme.of(context).colorScheme;
    final isDarkMode = colScheme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: colScheme.surface,
      body: Stack(
        children: [
          if (pubkey != null)
            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return HexPattern(
                    hexKey: pubkey!.forceHex(),
                    height:
                        math.min(constraints.maxWidth, constraints.maxHeight) *
                            0.9,
                    start: colScheme.onSurface,
                    end: colScheme.onSurfaceVariant,
                  );
                },
              ),
            ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(
                  title,
                  style: TextStyle(
                    color: colScheme.primary,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      final themeState = context.read<ThemeState>();
                      if (isDarkMode) {
                        themeState.toLight();
                        return;
                      }
                      themeState.toDark();
                    },
                    icon: isDarkMode
                        ? const FaIcon(Icons.light_mode)
                        : const FaIcon(Icons.dark_mode),
                  ),
                  IconButton(
                    onPressed: goToRepo,
                    icon: const FaIcon(FontAwesomeIcons.github),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: contentColumnWidth,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                      child: TextField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                          hintText: 'npub or public key',
                        ),
                        maxLines: 3,
                        minLines: 1,
                        // style: const TextStyle(
                        //   fontSize: 13.9,
                        // ),
                      ),
                    ),
                  ),
                ),
              ),
              if (pubkey == null && textEditingController.text.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                    child: Center(
                      child: Text(
                        'Invalid public key',
                        style: TextStyle(color: colScheme.error),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

extension ForceHex on String {
  String forceHex() {
    if (startsWith('npub1')) {
      String? output;
      try {
        final decoded = Nip19.decodePubkey(this);
        if (decoded.isNotEmpty) {
          output = decoded;
        }
      } catch (_) {
        return this;
      }
      if (output != null) {
        return output;
      }
    }
    return this;
  }
}

class ThemeState extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  void toDark() {
    themeMode = ThemeMode.dark;
    notifyListeners();
  }

  void toLight() {
    themeMode = ThemeMode.light;
    notifyListeners();
  }
}

class DemoTheme {
  static ThemeData dark() {
    final td = ThemeData.from(
      colorScheme: const ColorScheme.dark(
        primary: Color.fromARGB(255, 255, 255, 255),
        secondary: Color.fromARGB(255, 110, 184, 221),
        onSecondaryContainer: Color.fromARGB(255, 255, 255, 255),
        tertiaryContainer: Color.fromARGB(255, 64, 64, 64),
        onTertiaryContainer: Color.fromARGB(255, 168, 168, 168),
        surface: Color.fromARGB(255, 0, 0, 0),
        surfaceBright: Color.fromARGB(255, 41, 41, 41),
        surfaceContainer: Color.fromARGB(255, 29, 29, 29),
        onSurface: Color.fromARGB(255, 216, 216, 216),
        onSurfaceVariant: Color.fromARGB(255, 137, 137, 137),
        outlineVariant: Color.fromARGB(255, 66, 66, 66),
      ),
    );
    return td;
  }

  static ThemeData light() {
    final td = ThemeData.from(
      colorScheme: const ColorScheme.light(
        primary: Color.fromARGB(255, 0, 0, 0),
        secondary: Color.fromARGB(255, 130, 130, 130),
        onSecondaryContainer: Color.fromARGB(255, 122, 122, 122),
        tertiaryContainer: Color.fromARGB(255, 247, 247, 247),
        onTertiaryContainer: Color.fromARGB(255, 124, 124, 124),
        surface: Color.fromARGB(255, 255, 255, 255),
        surfaceBright: Color.fromARGB(255, 255, 255, 255),
        surfaceContainer: Color.fromARGB(255, 255, 255, 255),
        onSurface: Color.fromARGB(255, 0, 0, 0),
        onSurfaceVariant: Color.fromARGB(255, 128, 128, 128),
        outlineVariant: Color.fromARGB(255, 229, 229, 229),
      ),
    );
    return td;
  }
}
