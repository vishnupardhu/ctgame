import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'package:puzzlegame/puzzle_game_screen.dart';

import 'package:puzzlegame/test2.dart';
// Make sure to import your PuzzleGameScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Flutter Puzzle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Example function to generate puzzle pieces from an image
   List<img.Image> _generatePuzzlePieces() {
    // Load an image from the assets (you can also load from file or network)
    final imagePath = 'assets/vis/ct.jpg'; // Update with your image asset path
    
    final img.Image image = img.decodeImage(File(imagePath).readAsBytesSync())!;
    
    // Split the image into pieces (For simplicity, let's say 3x3 pieces)
    int rows = 3;
    int cols = 3;
    List<img.Image> pieces = [];
    
    int pieceWidth = image.width ~/ cols;
    int pieceHeight = image.height ~/ rows;

    // Loop over the image and create the puzzle pieces
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        // Here we are using copyCrop to create the puzzle piece from the image
      
         img.Image piece = img.copyCrop(image, x:  col * pieceWidth, y: row * pieceHeight, width: pieceWidth,height: pieceHeight);
        pieces.add(piece);  // Add the cropped piece to the list
      }
    
    }
    
    return pieces;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CT Game'),
      ),
      body: Stack(
         fit: StackFit.expand,
        children: [
          Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/vis/ct2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Blur effect applied on top of the background image
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0), // Applying blur effect
              child: Container(
                color: Colors.black.withValues(alpha:0.1),// Optional: add a color overlay
              ),
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              
           SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    // Generate puzzle pieces and navigate to PuzzleGameScreen
                    List<img.Image> pieces = _generatePuzzlePieces();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PuzzleGameScreen(pieces: pieces),
                      ),
                    );
                  },
                  child: Text('Start Puzzle Game'),
                ),
               
                 SizedBox(height: 20,),
                  ElevatedButton(
                  onPressed: () {
                    // Generate puzzle pieces and navigate to PuzzleGameScreen
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => loadGame2(),
                      ),
                    );
                  },
                  child: Text('Start Puzzle Game gallery'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
