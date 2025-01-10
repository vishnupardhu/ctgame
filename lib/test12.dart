// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:flutter/material.dart';

// class ImagePuzzleGame extends StatefulWidget {
//   const ImagePuzzleGame({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _ImagePuzzleGameState createState() => _ImagePuzzleGameState();
// }

// class _ImagePuzzleGameState extends State<ImagePuzzleGame> {
//   final int gridSize = 3; // 3x3 grid (9 pieces)
//   late List<PuzzlePiece> puzzlePieces;
//   late List<int> shuffledIndices;
//   late List<int> correctOrder;

//   @override
//   void initState() {
//     super.initState();
//     _generatePuzzlePieces();
//   }

//   // Function to generate the puzzle pieces by splitting a generated image
//   void _generatePuzzlePieces() {
//     puzzlePieces = [];
//     correctOrder = List.generate(gridSize * gridSize, (index) => index);

//     // Generate an image and divide it into pieces
//     for (int i = 0; i < gridSize * gridSize; i++) {
//       puzzlePieces.add(PuzzlePiece(i));
//     }

//     shuffledIndices = List.from(correctOrder);
//     shuffledIndices.shuffle(Random());
//   }

//   bool _isPuzzleComplete() {
//     return List.generate(gridSize * gridSize, (index) => shuffledIndices[index])
//         .every((element) => shuffledIndices.indexOf(element) == element);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Puzzle Game'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GridView.builder(
//               itemCount: gridSize * gridSize,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: gridSize,
//               ),
//               itemBuilder: (context, index) {
//                 int pieceIndex = shuffledIndices[index];
//                 return DragTarget<int>(
//                   onMove: (details) {
//                     // Hovering over target; handle visual cues if needed
//                   },
//                   onLeave: (data) {
//                     // Drag left target; reset hover effects if needed
//                   },
//                   onAcceptWithDetails: (details) {
//                     setState(() {
//                       int draggedIndex = details.data;

//                       // Swap dragged and target pieces
//                       int temp = shuffledIndices[index];
//                       shuffledIndices[index] = shuffledIndices[draggedIndex];
//                       shuffledIndices[draggedIndex] = temp;

//                       // Check if the puzzle is complete
//                       if (_isPuzzleComplete()) {
//                         _showCompletionDialog();
//                       }
//                     });
//                   },
//                   builder: (context, candidateData, rejectedData) {
//                     return Draggable<int>(
//                       data: index,
//                       feedback: _buildPuzzlePiece(pieceIndex, opacity: 0.7),
//                       childWhenDragging: Container(
//                         color: Colors.black12,
//                       ),
//                       child: _buildPuzzlePiece(pieceIndex),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               "Drag the pieces to reassemble the image!",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Builds a single puzzle piece using image slicing
//   Widget _buildPuzzlePiece(int index, {double opacity = 1.0}) {
//     int row = index ~/ gridSize;
//     int col = index % gridSize;

//     return Opacity(
//       opacity: opacity,
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           image: DecorationImage(
//             image: _generateImage().image, // Generate the image dynamically
//             fit: BoxFit.cover,
//             alignment: Alignment(
//               (2 * col / (gridSize - 1)) - 1,
//               (2 * row / (gridSize - 1)) - 1,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Generate a simple image pattern programmatically (for example, a gradient)
//   Image _generateImage() {
//     return Image.memory(
//       _createImageBytes(),
//       fit: BoxFit.cover,
//     );
//   }

//   // Helper function to generate the image bytes
//   Uint8List _createImageBytes() {
//     // Here, we use a simple gradient as an example for the generated image
//     final recorder = PictureRecorder();
//     final canvas = Canvas(recorder, Rect.fromPoints(Offset(0, 0), Offset(300, 300)));
//     final paint = Paint()..style = PaintingStyle.fill;
//     final gradient = LinearGradient(
//       colors: [Colors.red, Colors.blue],
//     );
//     final shader = gradient.createShader(Rect.fromLTWH(0, 0, 300, 300));
//     paint.shader = shader;
//     canvas.drawRect(Rect.fromLTWH(0, 0, 300, 300), paint);

//     final picture = recorder.endRecording();
//     final img = picture.toImage(300, 300);
//     return img.toByteData(format: ImageByteFormat.png)!.buffer.asUint8List();
//   }

//   void _showCompletionDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('Congratulations!'),
//         content: Text('You completed the puzzle!'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PuzzlePiece {
//   final int index;

//   PuzzlePiece(this.index);
// }
