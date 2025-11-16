import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'overlay_item.dart';
import 'editor_controller.dart';
import 'dart:ui' as ui;

class BusttechPhotoEditor extends StatefulWidget {
  final ImageProvider imageProvider;
  final EditorController? controller;
  final double maxWidth;
  final double maxHeight;

  const BusttechPhotoEditor({
    super.key,
    required this.imageProvider,
    this.controller,
    this.maxWidth = 1080,
    this.maxHeight = 1920,
  });

  @override
  State<BusttechPhotoEditor> createState() => _BusttechPhotoEditorState();
}

class _BusttechPhotoEditorState extends State<BusttechPhotoEditor> {
  late EditorController controller;
  final GlobalKey _previewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? EditorController();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _previewKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = math.min(constraints.maxWidth, widget.maxWidth);
          final h = math.min(constraints.maxHeight, widget.maxHeight);
          return SizedBox(
            width: w,
            height: h,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image(image: widget.imageProvider, fit: BoxFit.cover),
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    return Stack(
                      children: controller.items.map((item) {
                        final idx = controller.items.indexOf(item);
                        return _OverlayWidget(
                          key: ValueKey(item.id),
                          item: item,
                          onUpdate: (newItem) =>
                              controller.updateItem(item.id, newItem),
                          onRemove: () => controller.removeItem(item.id),
                          onBringToFront: () =>
                              controller.bringToFront(item.id),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// expose for export
  Future<Image> exportImage() async {
    final uiImage = await controller.exportToImage(_previewKey);
    final bytes = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) throw Exception('Failed to convert image bytes');
    return Image.memory(bytes.buffer.asUint8List());
  }
}

class _OverlayWidget extends StatefulWidget {
  final OverlayItem item;
  final ValueChanged<OverlayItem> onUpdate;
  final VoidCallback onRemove;
  final VoidCallback onBringToFront;

  const _OverlayWidget({
    super.key,
    required this.item,
    required this.onUpdate,
    required this.onRemove,
    required this.onBringToFront,
  });

  @override
  State<_OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<_OverlayWidget> {
  late Offset position;
  late double scale;
  late double rotation;

  @override
  void initState() {
    super.initState();
    position = widget.item.position;
    scale = widget.item.scale;
    rotation = widget.item.rotation;
  }

  void _onScaleStart(ScaleStartDetails details) {
    widget.onBringToFront();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      position += details.focalPointDelta;
      scale *= details.scale;
      rotation += details.rotation;
      // clamp scale
      scale = scale.clamp(0.2, 10.0);
    });
    widget.onUpdate(
      widget.item.copyWith(
        position: position,
        scale: scale,
        rotation: rotation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onTap: () => widget.onBringToFront(),
        onLongPress: widget.onRemove,
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        child: Transform.rotate(
          angle: rotation,
          child: Transform.scale(
            scale: scale,
            child: widget.item.child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
