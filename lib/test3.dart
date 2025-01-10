import 'dart:math';

import 'package:flutter/material.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  List<List<int>> _puzzle = [];
  List<List<int>> _solution = [];
  bool _isSolved = false;

  @override
  void initState() {
    super.initState();
    _initializePuzzle();
  }

  // Initialize the puzzle
  void _initializePuzzle() {
    _solution = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
    ];
    _puzzle = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
    ];

    // Shuffle puzzle pieces
    _shufflePuzzle();
  }

  // Shuffle the puzzle pieces
  void _shufflePuzzle() {
    var rng = Random();
    List<int> numbers = List.generate(9, (index) => index);
    numbers.shuffle(rng);

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        _puzzle[i][j] = numbers[i * 3 + j];
      }
    }

    setState(() {});
  }

  // Check if puzzle is solved
  void _checkPuzzle() {
    if (_puzzle.toString() == _solution.toString()) {
      setState(() {
        _isSolved = true;
      });
    }
  }

  // Build the grid of puzzle pieces
  Widget _buildPuzzleGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        int row = index ~/ 3;
        int col = index % 3;
        int piece = _puzzle[row][col];

        return Draggable<int>(
          data: piece,
          feedback: _buildPuzzlePiece(piece),
          childWhenDragging: Container(),
          child: _buildPuzzlePiece(piece),
        );
      },
    );
  }

  // Build an individual puzzle piece
  Widget _buildPuzzlePiece(int piece) {
    return Container(
      margin: EdgeInsets.all(4),
      color: Colors.blue,
      child: Center(
        child: Text(
          piece == 8 ? "" : piece.toString(),
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Puzzle Game')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (_isSolved)
              Text('Congratulations! Puzzle Solved!',
                  style: TextStyle(fontSize: 24, color: Colors.green)),
            Expanded(
              child: Stack(
                children: [
                  _buildPuzzleGrid(),
                  DragTarget<int>(
                    onAcceptWithDetails: (piece) {
                      setState(() {
                        // Update puzzle state when dropped in the correct place
                        _checkPuzzle();
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container();
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isSolved = false;
                  _initializePuzzle();
                });
              },
              child: Text("Shuffle"),
            )
          ],
        ),
      ),
    );
  }
}
