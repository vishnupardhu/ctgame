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
  late List<img.Image> puzzlePieces;
  late int rows;
  late int cols;
  late List<int?> puzzlePositions; // To track correct placements

  @override
  void initState() {
    super.initState();
    puzzlePieces = widget.pieces;
    rows = 3;  // Number of rows in puzzle
    cols = 3;  // Number of columns in puzzle
    puzzlePositions = List<int?>.filled(puzzlePieces.length, null); // Tracks where pieces are placed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Puzzle Game"),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,  // Number of columns
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: puzzlePieces.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              // The DragTarget area where pieces should be placed
              Positioned.fill(
                child: DragTarget<int>(
                  onMove: (details) {
                    // Handle when a draggable is moving over the target
                    //print("Piece is moving over target area: ${details.localPosition}");
                  },
                  onLeave: (data) {
                    // Handle when a draggable leaves the target area
                    print("Piece left the target area: $data");
                  },
                  onAcceptWithDetails: (details) {
                    // Handle when the draggable is dropped (replaces onAccept)
                    final data = details.data;
                    setState(() {
                      puzzlePositions[data] = index; // Track that the piece is placed here
                    });
                   // print("Piece $data dropped at target $index with details: ${details.localPosition}");
                  },
                  builder: (context, candidateData, rejectedData) {
                    // Placeholder container for the target area
                    return Container(
                      color: Colors.blueGrey.withValues(alpha:0.2),
                      child: Center(
                        child: puzzlePositions[index] == null
                            ? Container()
                            : PuzzlePiece(piece: puzzlePieces[puzzlePositions[index]!]),
                      ),
                    );
                  },
                ),
              ),
              
              // The Draggable piece (this is the piece the user can drag)
              Positioned.fill(
                child: Draggable<int>(
                  data: index,
                  child: PuzzlePiece(piece: puzzlePieces[index]),
                  feedback: PuzzlePiece(piece: puzzlePieces[index], isDragging: true),
                  childWhenDragging: Container(), // Optional empty container when dragging
                ),
              ),
            ],
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
