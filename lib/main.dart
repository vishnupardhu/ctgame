
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:puzzlegame/puzzle_number.dart';
import 'package:puzzlegame/puzzle_grid_five.dart';
import 'package:puzzlegame/puzzle_grid_game.dart';
import 'package:puzzlegame/puzzle_load_game.dart';
import 'package:puzzlegame/puzzle_tic_toe.dart';
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
      title: 'Ct Puzzle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  img.Image? image;
  final imagePath = 'assets/vis/ct.jpg'; // Update with your image asset path

  redme() async {
    // XFile file = XFile(File(imagePath).path);
    // final bytes = await file.readAsBytes();
    final byteData = await rootBundle.load(imagePath);
    final bytes = byteData.buffer.asUint8List();
    image = img.decodeImage(Uint8List.fromList(bytes))!; // Decode image
  }
// minsync() async {
//  final bytes = await File(imagePath).readAsBytes();
//   final image = img.decodeImage(Uint8List.fromList(bytes))!;

// }

  // Example function to generate puzzle pieces from an image
  List<img.Image> _generatePuzzlePieces() {
    redme();
    // Load an image from the assets (you can also load from file or network)

    // Future<Uint8List> _readFileByte(String filePath) async {
    //   ByteData byteData = await rootBundle.load(filePath);

    //   Uint8List bytes = byteData.buffer.asUint8List();
    //   return bytes;
    // }

    //final img.Image image1 = img.decodeImage(File(imagePath).readAsBytesSync())!;

    // Split the image into pieces (For simplicity, let's say 3x3 pieces)

    int rows = 3;
    int cols = 4;
    List<img.Image> pieces = [];

    int pieceWidth = image!.width ~/ cols;
    int pieceHeight = image!.height ~/ rows;

    // Loop over the image and create the puzzle pieces
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        // Here we are using copyCrop to create the puzzle piece from the image

        img.Image piece = img.copyCrop(image!,
            x: col * pieceWidth,
            y: row * pieceHeight,
            width: pieceWidth,
            height: pieceHeight);
        pieces.add(piece); // Add the cropped piece to the list
      }
    }

    return pieces;
  }

  @override
  void initState() {
    super.initState();
    redme();
    // Tracks where pieces are placed
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
                image: AssetImage('assets/vis/ct.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blur effect applied on top of the background image
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 3.0, sigmaY: 3.0), // Applying blur effect
            child: Container(
              color: Colors.black
                  .withValues(alpha: 0.1), // Optional: add a color overlay
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 ElevatedButton(
                  onPressed: () {
         
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicToeGamePuzzle(),
                      ),
                    );
                  },
                  child: Text('Tic Toe Game '),
                ),
                 SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
         
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NumberPuzzleGame(),
                      ),
                    );
                  },
                  child: Text('Number Puzzle '),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
         
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PuzzleCtGAmethree(),
                      ),
                    );
                  },
                  child: Text('Start 3 * 3 Puzzle '),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Generate puzzle pieces and navigate to PuzzleGameScreen

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PuzzleGridFourGame(),
                      ),
                    );
                  },
                  child: Text('Start 4 * 4 Puzzle '),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Generate puzzle pieces and navigate to PuzzleGameScreen

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PuzzleGridFiveGAme(),
                      ),
                    );
                  },
                  child: Text('Start 5 * 5 Puzzle '),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
