import 'dart:typed_data';
import 'dart:io';
import 'package:image/image.dart' as img;

Future<List<img.Image>> splitImage(String imagePath, int rows, int cols) async {
  // Load the image file
  final bytes = await File(imagePath).readAsBytes();
  final image = img.decodeImage(Uint8List.fromList(bytes))!;

  int pieceWidth = (image.width / cols).toInt();
  int pieceHeight = (image.height / rows).toInt();

  List<img.Image> pieces = [];

  // Crop the image into pieces
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      int startX = x * pieceWidth;
      int startY = y * pieceHeight;

      // Crop the piece from the image
      img.Image piece = img.copyCrop(image, x: startX, y: startY, width: pieceWidth,height: pieceHeight);
      pieces.add(piece);
    }
  }

  return pieces;
}
