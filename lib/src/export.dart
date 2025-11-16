import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

Future<Uint8List> encodePng(ui.Image image) async {
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) throw Exception('Failed to convert to PNG bytes');
  return byteData.buffer.asUint8List();
}

Future<Uint8List> encodeJpeg(ui.Image image, {int quality = 90}) async {
  final pngBytes = await encodePng(image);
  final decoded = img.decodeImage(pngBytes);
  if (decoded == null) throw Exception('Failed to decode PNG');
  final jpgBytes = img.encodeJpg(decoded, quality: quality);
  return Uint8List.fromList(jpgBytes);
}
