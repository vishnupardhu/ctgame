import 'package:flutter/material.dart';
import 'dart:math';

class ImagePuzzleGame extends StatefulWidget {
  const ImagePuzzleGame({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePuzzleGameState createState() => _ImagePuzzleGameState();
}

class _ImagePuzzleGameState extends State<ImagePuzzleGame> {
  final int gridSize = 3; // 3x3 grid
  late List<int> shuffledIndices;
  late List<int> correctOrder;

  @override
  void initState() {
    super.initState();
    generatePuzzlePieces();
  }

  void generatePuzzlePieces() {
    // Generate the correct order indices
    correctOrder = List.generate(gridSize * gridSize, (index) => index);

    // Shuffle indices for the initial random order
    shuffledIndices = List.from(correctOrder);
    shuffledIndices.shuffle(Random());
  }

  bool isPuzzleComplete() {
    return List.generate(gridSize * gridSize, (index) => shuffledIndices[index])
        .every((element) => shuffledIndices.indexOf(element) == element);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Puzzle Game'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: gridSize * gridSize,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemBuilder: (context, index) {
                int pieceIndex = shuffledIndices[index];
                return DragTarget<int>(
                  onMove: (details) {
                    // This callback is triggered when a piece is hovering over the target
                    // You can handle UI effects here if needed
                  },
                  onLeave: (data) {
                    // Triggered when the draggable leaves the target
                  },
                  onAcceptWithDetails: (details) {
                    setState(() {
                      int draggedIndex = details.data;
                      int temp = shuffledIndices[index];
                      shuffledIndices[index] = shuffledIndices[draggedIndex];
                      shuffledIndices[draggedIndex] = temp;

                      if (isPuzzleComplete()) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Congratulations!'),
                            content: Text('You completed the puzzle!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Draggable<int>(
                      data: index,
                      feedback: buildPuzzlePiece(pieceIndex, opacity: 0.7),
                      childWhenDragging: Container(
                        color: Colors.black12,
                      ),
                      child: buildPuzzlePiece(pieceIndex),
                    );
                  },
                );
              },
            ),
          ),
          Text(
            "Drag the pieces to reassemble the image!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget buildPuzzlePiece(int index, {double opacity = 1.0}) {
    int row = index ~/ gridSize;
    int col = index % gridSize;

    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/vis/ct.jpg'),
            fit: BoxFit.cover,
            alignment: Alignment(
              (2 * col / (gridSize - 1)) - 1,
              (2 * row / (gridSize - 1)) - 1,
            ),
          ),
        ),
      ),
    );
  }
}
