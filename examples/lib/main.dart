import 'package:flutter/material.dart';
import 'package:busttech_photo_overlay/busttech_utils.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  final controller = EditorController();

  @override
  void initState() {
    super.initState();

    // Add a demo sticker automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.addItem(
        OverlayItem(
          id: 'sticker1',
          type: OverlayType.sticker,
          position: const Offset(80, 80),
          scale: 1.2,
          child: Image.asset('assets/stickers/sample.png', width: 120),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BustTech Photo Overlay Example')),
      body: Center(
        child: BusttechPhotoEditor(
          imageProvider: const AssetImage('assets/sample.jpg'),
          controller: controller,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          final editorState = context.findAncestorStateOfType<State>();

          final overlayEditor = context.findAncestorStateOfType();

          // Instead expose via controller if needed
        },
      ),
    );
  }
}
