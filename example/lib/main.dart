import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:statescope/statescope.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nostr_core_dart/nostr.dart';

import 'package:hexpattern/hexpattern.dart';

const contentColumnWidth = 600.0;

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
      title: 'pubkey to colors',
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
  final textEditingController = TextEditingController(
      text: '3c7d12a6c2f71fe9ca2527216f529a137bb0f2eb018b18f30003933b9532013e');

  String? pubkey;
  double sliderValue = 2;
  bool isMonochrome = true;

  @override
  void initState() {
    super.initState();
    validate();
    textEditingController.addListener(() {
      validate();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  void validate() {
    final input = textEditingController.text.trim();
    if (input.startsWith('npub1')) {
      final decoded = Nip19.decodePubkey(input);
      if (decoded.isNotEmpty) {
        textEditingController.text = decoded;
        setState(() {});
        return;
      }
    }
    String? output;
    if (input.length == 64 && isHexadecimal(input)) {
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

  @override
  Widget build(BuildContext context) {
    final colScheme = Theme.of(context).colorScheme;
    final isDarkMode = colScheme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: colScheme.surface,
      body: LayoutBuilder(builder: (context, constraints) {
        final height = constraints.maxWidth / 12;
        final pad = height * 2;
        return Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Enter pubkey',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: pad),
                  child: TextField(
                    controller: textEditingController,
                    maxLines: 3,
                    minLines: 1,
                    style: const TextStyle(
                      fontSize: 13.9,
                    ),
                  ),
                ),
                if (pubkey == null)
                  Padding(
                    padding: EdgeInsets.all(height / 2),
                    child: Text(
                      'pubkey is not valid',
                      style: TextStyle(color: colScheme.error),
                    ),
                  ),
                if (pubkey != null)
                  Row(
                    children: [
                      const Spacer(),
                      if (!isMonochrome)
                        Pubkey2Pattern(
                          pubkeyHex: pubkey!,
                          height: height,
                          compress: sliderValue,
                        ),
                      if (isMonochrome)
                        Pubkey2Colors(
                          pubkeyHex: pubkey!,
                          height: height,
                          compress: sliderValue,
                        ),
                      const Spacer(),
                    ],
                  ),
                if (pubkey != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: pad),
                    child: Slider(
                      value: sliderValue,
                      onChanged: (v) {
                        setState(() {
                          sliderValue = v;
                        });
                      },
                      min: 0.0,
                      max: 4.0,
                    ),
                  ),
                if (pubkey != null)
                  Text('Compressed: ${sliderValue.toStringAsFixed(1)}'),
                if (pubkey != null)
                  Switch(
                      value: isMonochrome,
                      onChanged: (bool value) {
                        setState(() {
                          isMonochrome = value;
                        });
                      }),
                if (pubkey != null && isMonochrome) const Text('Mono'),
                if (pubkey != null && !isMonochrome)
                  const Text('Identicon (experimental)'),
              ],
            ),
            Row(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5.0,
                    runSpacing: 5.0,
                    children: [
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
                ),
              ],
            ),
          ],
        );
      }),
    );
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
        surface: Color.fromARGB(255, 29, 29, 29),
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
