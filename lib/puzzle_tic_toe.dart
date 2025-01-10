import 'package:flutter/material.dart';

class TicToeGamePuzzle extends StatefulWidget {
  const TicToeGamePuzzle({super.key});

  @override
  State<TicToeGamePuzzle> createState() => _TicToeGamePuzzleState();
}

class _TicToeGamePuzzleState extends State<TicToeGamePuzzle> {
 
  List<String?> _board = List.generate(25, (_) => null); // 5x5 board
  bool _isXTurn = true;

  void _resetGame() {
    setState(() {
      _board = List.generate(25, (_) => null);
      _isXTurn = true;
    });
  }

  void _makeMove(int index) {
    if (_board[index] == null) {
      setState(() {
        _board[index] = _isXTurn ? 'X' : 'O';
        _isXTurn = !_isXTurn;
      });

      // Check for winner
      String? winner = _checkWinner();
      if (winner != null) {
        _showWinnerDialog(winner);
      }
    }
  }

  // Check if there's a winner (5 consecutive marks)
  String? _checkWinner() {
    // Winning combinations (check horizontal, vertical, and diagonal lines)
    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 5; col++) {
        String? player = _board[row * 5 + col];
        if (player != null) {
          // Check horizontal
          if (col + 4 < 5 && player == _board[row * 5 + col + 1] && player == _board[row * 5 + col + 2] && player == _board[row * 5 + col + 3] && player == _board[row * 5 + col + 4]) {
            return player;
          }
          // Check vertical
          if (row + 4 < 5 && player == _board[(row + 1) * 5 + col] && player == _board[(row + 2) * 5 + col] && player == _board[(row + 3) * 5 + col] && player == _board[(row + 4) * 5 + col]) {
            return player;
          }
          // Check diagonal
          if (row + 4 < 5 && col + 4 < 5 &&
              player == _board[(row + 1) * 5 + col + 1] &&
              player == _board[(row + 2) * 5 + col + 2] &&
              player == _board[(row + 3) * 5 + col + 3] &&
              player == _board[(row + 4) * 5 + col + 4]) {
            return player;
          }
          // Check reverse diagonal
          if (row - 4 >= 0 && col + 4 < 5 &&
              player == _board[(row - 1) * 5 + col + 1] &&
              player == _board[(row - 2) * 5 + col + 2] &&
              player == _board[(row - 3) * 5 + col + 3] &&
              player == _board[(row - 4) * 5 + col + 4]) {
            return player;
          }
        }
      }
    }

    // Check if the board is full
    if (_board.every((spot) => spot != null)) {
      return 'Draw';
    }

    return null;
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(winner == 'Draw' ? 'It\'s a Draw!' : '$winner Wins!'),
        content: Text('Congratulations to the winner!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('5x5 Tic-Tac-Toe'),
        actions: [
          IconButton(
            onPressed: _resetGame,
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // 5x5 grid
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: 25, // There are 25 cells
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _makeMove(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.grey[200],
                    ),
                    child: Center(
                      child: Text(
                        _board[index] ?? '',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetGame,
              child: Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }
}
