import 'package:flutter/material.dart';

enum OverlayType { sticker, text, frame, logo }

class OverlayItem {
  final String id;
  OverlayType type;
  Offset position;
  double scale;
  double rotation; // radians
  Widget? child; // visual widget

  OverlayItem({
    required this.id,
    required this.type,
    required this.position,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.child,
  });

  OverlayItem copyWith({
    Offset? position,
    double? scale,
    double? rotation,
    Widget? child,
  }) {
    return OverlayItem(
      id: id,
      type: type,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      child: child ?? this.child,
    );
  }
}