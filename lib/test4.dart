// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'package:flutter/services.dart';
// import 'dart:typed_data';
// import 'package:flutter/painting.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Image Puzzle',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: PuzzlePage(),
//     );
//   }
// }

// class PuzzlePage extends StatefulWidget {
//   @override
//   _PuzzlePageState createState() => _PuzzlePageState();
// }

// class _PuzzlePageState extends State<PuzzlePage> {
//   late List<List<int>> _puzzle;
//   late List<List<int>> _solution;
//   bool _isSolved = false;
//   late List<Uint8List> _imagePieces; // To hold the image pieces

//   @override
//   void initState() {
//     super.initState();
//     _initializePuzzle();
//   }

//   // Initialize the puzzle and load image
//   void _initializePuzzle() async {
//     _solution = [
//       [0, 1, 2],
//       [3, 4, 5],
//       [6, 7, 8],
//     ];
//     _puzzle = [
//       [0, 1, 2],
//       [3, 4, 5],
//       [6, 7, 8],
//     ];

//     // Load and split the image
//     await _loadImagePieces();

//     // Shuffle the puzzle pieces
//     _shufflePuzzle();
//   }

//   // Load image and split it into pieces
//   Future<void> _loadImagePieces() async {
//     final ByteData data = await rootBundle.load('assets/puzzle_image.jpg');
//     final Uint8List bytes = data.buffer.asUint8List();
//     final img = await decodeImageFromList(bytes);

//     _imagePieces = [];
//     final int rows = 3;
//     final int cols = 3;

//     // Split the image into 9 pieces (3x3 grid)
//     for (int row = 0; row < rows; row++) {
//       for (int col = 0; col < cols; col++) {
//         var piece = img.clone();
//         final x = col * (img.width ~/ cols);
//         final y = row * (img.height ~/ rows);
//         final width = img.width ~/ cols;
//         final height = img.height ~/ rows;
//         piece = img.subimage(x, y, x + width, y + height);
//         _imagePieces.add(await piece.toByteData(format: ImageByteFormat.png));
//       }
//     }
//     setState(() {});
//   }

//   // Shuffle the puzzle pieces
//   void _shufflePuzzle() {
//     var rng = Random();
//     List<int> numbers = List.generate(9, (index) => index);
//     numbers.shuffle(rng);

//     for (int i = 0; i < 3; i++) {
//       for (int j = 0; j < 3; j++) {
//         _puzzle[i][j] = numbers[i * 3 + j];
//       }
//     }

//     setState(() {});
//   }

//   // Check if puzzle is solved
//   void _checkPuzzle() {
//     if (_puzzle.toString() == _solution.toString()) {
//       setState(() {
//         _isSolved = true;
//       });
//     }
//   }

//   // Build the grid of puzzle pieces
//   Widget _buildPuzzleGrid() {
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//       ),
//       itemCount: 9,
//       itemBuilder: (context, index) {
//         int row = index ~/ 3;
//         int col = index % 3;
//         int pieceIndex = _puzzle[row][col];

//         return Draggable<int>(
//           data: pieceIndex,
//           child: _buildPuzzlePiece(pieceIndex),
//           feedback: _buildPuzzlePiece(pieceIndex),
//           childWhenDragging: Container(),
//         );
//       },
//     );
//   }

//   // Build an individual puzzle piece (image slice)
//   Widget _buildPuzzlePiece(int pieceIndex) {
//     final imagePiece = _imagePieces[pieceIndex];
//     return Container(
//       margin: EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black, width: 1),
//       ),
//       child: Image.memory(imagePiece),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Flutter Image Puzzle')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             if (_isSolved)
//               Text('Congratulations! Puzzle Solved!',
//                   style: TextStyle(fontSize: 24, color: Colors.green)),
//             Expanded(
//               child: Stack(
//                 children: [
//                   _buildPuzzleGrid(),
//                   DragTarget<int>(
//                     onAccept: (piece) {
//                       setState(() {
//                         _checkPuzzle();
//                       });
//                     },
//                     builder: (context, candidateData, rejectedData) {
//                       return Container();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _isSolved = false;
//                   _initializePuzzle();
//                 });
//               },
//               child: Text("Shuffle"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
