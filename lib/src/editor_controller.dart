import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'overlay_item.dart';
import 'package:flutter/rendering.dart';

class EditorController extends ChangeNotifier {
  final List<OverlayItem> items = [];

  void addItem(OverlayItem it) {
    items.add(it);
    notifyListeners();
  }

  void removeItem(String id) {
    items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void bringToFront(String id) {
    final idx = items.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      final it = items.removeAt(idx);
      items.add(it);
      notifyListeners();
    }
  }

  void updateItem(String id, OverlayItem newItem) {
    final idx = items.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      items[idx] = newItem;
      notifyListeners();
    }
  }

  Future<ui.Image> exportToImage(GlobalKey boundaryKey) async {
    final RenderRepaintBoundary? boundary =
        boundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) {
      throw Exception('Editor boundary not found');
    }
    final ui.Image image = await boundary.toImage(
      pixelRatio: ui.window.devicePixelRatio,
    );
    return image;
  }
}
