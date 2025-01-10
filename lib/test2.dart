import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';  // Image Picker for gallery and camera
import 'dart:typed_data';
import 'dart:io';
// ignore: camel_case_types
class loadGame2 extends StatefulWidget {
  const loadGame2({super.key});

  @override
  State<loadGame2> createState() => _loadGame2State();
}

// ignore: camel_case_types
class _loadGame2State extends State<loadGame2> {
 
  final ImagePicker _picker = ImagePicker();
   late img.Image? _image;
   final imagePath = 'assets/vis/ct.jpg'; // Update with your image asset path
   

  // Image selection and manipulation function
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = img.decodeImage(Uint8List.fromList(bytes));  // Decode image
      });
    }
  }

  // Function to generate puzzle pieces
  List<img.Image> _generatePuzzlePieces(img.Image image) {
    int rows = 3;
    int cols = 3;
    List<img.Image> pieces = [];

    int pieceWidth = image.width ~/ cols;
    int pieceHeight = image.height ~/ rows;

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
  void initState() {
    super.initState();
    _image=img.decodeImage(File(imagePath).readAsBytesSync())!;
   // Tracks where pieces are placed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/vis/ct2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Image.asset(
         'assets/vis/ct.jpg'),
            ),
            // _image == null
            //     ? Text("No Image Selected")
            //     : Image.memory(Uint8List.fromList(img.encodeJpg(_image!))),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _pickImage(ImageSource.camera); // Pick image from camera
              },
              child: Text('Capture Image'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _pickImage(ImageSource.gallery); // Pick image from gallery
              },
              child: Text('Pick from Gallery'),
            ),
            SizedBox(height: 20),
            _image == null
                ? Container()
                : ElevatedButton(
                    onPressed: () {
                      // Generate puzzle pieces and navigate to PuzzleGameScreen
                      List<img.Image> pieces = _generatePuzzlePieces(_image!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PuzzleGameScreen2(pieces: pieces),
                        ),
                      );
                    },
                    child: Text('Start Puzzle Game'),
                  ),
          ],
        ),
      ),
    );
  }
}

class PuzzleGameScreen2 extends StatefulWidget {
  final List<img.Image> pieces;

  const PuzzleGameScreen2({super.key, required this.pieces});

  @override
  // ignore: library_private_types_in_public_api
  _PuzzleGameScreenState createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen2> {
  late List<img.Image> puzzlePieces;
  late int rows;
  late int cols;
  late List<int?> puzzlePositions;
  late List<int?> correctPositions;
  final Random _random = Random();
  @override
  void initState() {
    super.initState();
    puzzlePieces = widget.pieces;
    rows = 3;
    cols = 3;
    puzzlePositions = List<int?>.filled(puzzlePieces.length, null);
    correctPositions = List<int?>.generate(puzzlePieces.length, (index) => index);  // Correct order of pieces
  }
 // Function to shuffle the puzzle pieces
  void _shufflePuzzle() {
    setState(() {
      puzzlePositions.shuffle(_random);
    });
  }

   void _shufflePuzzle1() {
    setState(() {
      // Shuffle the puzzle pieces' positions randomly
      puzzlePositions = List<int?>.generate(puzzlePieces.length, (index) => index);
      puzzlePositions.shuffle(_random);
    });
  }


  // Function to check if the puzzle is solved
  bool _isPuzzleSolved() {
    for (int i = 0; i < puzzlePositions.length; i++) {
      if (puzzlePositions[i] != correctPositions[i]) {
        return false;
      }
    }
    return true;
  }

  // Function to show completion dialog
  void _showCompletionDialog(bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isSuccess ? 'Congratulations!' : 'Oops!'),
          content: Text(isSuccess ? 'You solved the puzzle!' : 'The puzzle is not yet solved. Try again!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Puzzle Game"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: puzzlePieces.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: DragTarget<int>(
                        onAcceptWithDetails: (details) {
                          final data = details.data;
                          setState(() {
                            puzzlePositions[data] = index;
                          });
                        },
                        builder: (context, candidateData, rejectedData) {
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
                    Positioned.fill(
                      child: Draggable<int>(
                        data: index,
                        feedback: PuzzlePiece(piece: puzzlePieces[index], isDragging: true),
                        childWhenDragging: Container(),
                        child: PuzzlePiece(piece: puzzlePieces[index]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _shufflePuzzle,
                  child: Text('Shuffle Pieces'),
                ),
                ElevatedButton(
                  onPressed: _shufflePuzzle1,
                  child: Text('Shuffle random'),
                ),
                ElevatedButton(
                  onPressed: () {
                    bool isSuccess = _isPuzzleSolved();
                    _showCompletionDialog(isSuccess); // Show success/failure dialog
                  },
                  child: Text('Complete Puzzle'),
                ),
              ],
            ),
          ),
        ],
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
