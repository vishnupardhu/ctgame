// import 'package:flutter/material.dart';

// class PuzzleGame extends StatefulWidget {
//   const PuzzleGame({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _PuzzleGameState createState() => _PuzzleGameState();
// }

// class _PuzzleGameState extends State<PuzzleGame> {
//   final int gridSize = 3; // 3x3 puzzle grid
//   late List<int> pieces;
//   final String imageUrl =
//       'https://example.com/image.jpg'; // Replace with your image

//   @override
//   void initState() {
//     super.initState();
//     // Initialize puzzle pieces in a shuffled order
//     pieces = List<int>.generate(gridSize * gridSize, (index) => index)
//       ..shuffle();
//   }

//   bool checkPuzzleSolved() {
//     // Check if pieces are in order
//     for (int i = 0; i < pieces.length; i++) {
//       if (pieces[i] != i) return false;
//     }
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double puzzleSize = screenWidth * 0.8;
//     final double pieceSize = puzzleSize / gridSize;

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Stack(
//             children: List.generate(pieces.length, (index) {
//               final int pieceIndex = pieces[index];
//               return DragTarget<int>(
//                 onAccept: (draggedIndex) {
//                   setState(() {
//                     // Swap the pieces
//                     final int oldIndex = pieces.indexOf(draggedIndex);
//                     pieces[oldIndex] = pieceIndex;
//                     pieces[index] = draggedIndex;

//                     // Check if the puzzle is solved
//                     if (checkPuzzleSolved()) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Puzzle Solved!')),
//                       );
//                     }
//                   });
//                 },
//                 builder: (context, candidateData, rejectedData) {
//                   return Positioned(
//                     left: (index % gridSize) * pieceSize,
//                     top: (index ~/ gridSize) * pieceSize,
//                     child: Draggable<int>(
//                       data: pieceIndex,
//                       feedback: Image.network(
//                         imageUrl,
//                         width: pieceSize,
//                         height: pieceSize,
//                         fit: BoxFit.cover,
//                         alignment: Alignment(
//                           (pieceIndex % gridSize - (gridSize - 1) / 2) *
//                               2 /
//                               gridSize,
//                           (pieceIndex ~/ gridSize - (gridSize - 1) / 2) *
//                               2 /
//                               gridSize,
//                         ),
//                       ),
//                       childWhenDragging: Container(
//                         width: pieceSize,
//                         height: pieceSize,
//                         color: Colors.grey,
//                       ),
//                       child: Image.network(
//                         imageUrl,
//                         width: pieceSize,
//                         height: pieceSize,
//                         fit: BoxFit.cover,
//                         alignment: Alignment(
//                           (pieceIndex % gridSize - (gridSize - 1) / 2) *
//                               2 /
//                               gridSize,
//                           (pieceIndex ~/ gridSize - (gridSize - 1) / 2) *
//                               2 /
//                               gridSize,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 pieces.shuffle();
//               });
//             },
//             child: Text('Shuffle'),
//           ),
//         ],
//       ),
//     );
//   }
// }
