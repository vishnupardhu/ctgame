

import 'package:flutter/material.dart';

class NumberPuzzleGame extends StatefulWidget {
  const NumberPuzzleGame({super.key});

  @override
  State<NumberPuzzleGame> createState() => _NumberPuzzleGameState();
}

class _NumberPuzzleGameState extends State<NumberPuzzleGame> {

  late List<int> _tiles;
  int _emptyTileIndex = 24;

  @override
  void initState() {
    super.initState();
    _tiles = List.generate(25, (index) => index);
    _shuffleTiles();
  }

  // Shuffle tiles
  void _shuffleTiles() {
    _tiles.shuffle();
    setState(() {});
  }

  // Swap tiles
  void _moveTile(int index) {
    int emptyTileRow = _emptyTileIndex ~/ 5;
    int emptyTileCol = _emptyTileIndex % 5;

    int selectedTileRow = index ~/ 5;
    int selectedTileCol = index % 5;

    // Check if the selected tile is adjacent to the empty space
    if ((selectedTileRow - emptyTileRow).abs() + (selectedTileCol - emptyTileCol).abs() == 1) {
      setState(() {
        // Swap the tiles
        int temp = _tiles[index];
        _tiles[index] = _tiles[_emptyTileIndex];
        _tiles[_emptyTileIndex] = temp;

        _emptyTileIndex = index;
      });

      // Check if the puzzle is solved
      if (_tiles.sublist(0, 24).every((tile) => tile == _tiles.indexOf(tile))) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Puzzle Solved!'),
            content: Text('Congratulations, you solved the puzzle!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _shuffleTiles();
                },
                child: Text('Play Again'),
              ),
            ],
          ),
        );
      }
    }
  }

  // Reset the puzzle (shuffle again)
  void _resetGame() {
    setState(() {
      _tiles = List.generate(25, (index) => index);
      _shuffleTiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('5x5 Number Puzzle'),
        actions: [
          IconButton(
            onPressed: _shuffleTiles,
            icon: Icon(Icons.shuffle),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _resetGame,
              child: Text('Start New Game'),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // Change to 5 for a 5x5 grid
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: 25, // There are 25 tiles (5x5)
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _moveTile(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _tiles[index] == 0 ? Colors.transparent : Colors.blue,
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: _tiles[index] == 0
                          ? null
                          : Text(
                              _tiles[index].toString(),
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
