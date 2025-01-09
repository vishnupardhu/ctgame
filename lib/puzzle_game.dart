import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class PuzzleGameScreen extends StatefulWidget {
  final List<img.Image> pieces;

  const PuzzleGameScreen({super.key, required this.pieces});

  @override
  // ignore: library_private_types_in_public_api
  _PuzzleGameScreenState createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  List<img.Image> puzzlePieces = [];
  late int rows;
  late int cols;

  @override
  void initState() {
    super.initState();
    puzzlePieces = widget.pieces;
    rows = 3;  // Number of rows in puzzle
    cols = 3;  // Number of columns in puzzle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Puzzle Game")),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols, // Number of columns
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: puzzlePieces.length,
        itemBuilder: (context, index) {
          return Draggable<int>(
            data: index,
            feedback: PuzzlePiece(piece: puzzlePieces[index], isDragging: true),
            childWhenDragging: Container(),
            child: PuzzlePiece(piece: puzzlePieces[index]),
          );
        },
      ),
    );
  }
}

class PuzzlePiece extends StatelessWidget {
  final img.Image piece;
  final bool isDragging;

  const PuzzlePiece({super.key, required this.piece, this.isDragging = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        image: DecorationImage(
          image: MemoryImage(Uint8List.fromList(img.encodeJpg(piece))),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
