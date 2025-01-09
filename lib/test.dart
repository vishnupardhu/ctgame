import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';  // Image Picker for gallery and camera
import 'dart:typed_data';

class LoadGame extends StatefulWidget {
  const LoadGame({super.key});

  @override
  State<LoadGame> createState() => _LoadGameState();
}

class _LoadGameState extends State<LoadGame> {

  final ImagePicker _picker = ImagePicker();
  late img.Image? _image;
   final imagePath = 'assets/images/vish.jpeg'; // Update with your image asset path
    
   

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
            _image == null
                ? Text("No Image Selected")
                : Image.memory(Uint8List.fromList(img.encodeJpg(_image!))),
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
                          builder: (context) => PuzzleGameScreen1(pieces: pieces),
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

class PuzzleGameScreen1 extends StatefulWidget {
  final List<img.Image> pieces;

  const PuzzleGameScreen1({super.key, required this.pieces});

  @override
  // ignore: library_private_types_in_public_api
  _PuzzleGameScreenState createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen1> {
  late List<img.Image> puzzlePieces;
  late int rows;
  late int cols;
  late List<int?> puzzlePositions;
  late List<int?> correctPositions;

  @override
  void initState() {
    super.initState();
    puzzlePieces = widget.pieces;
    rows = 3;
    cols = 3;
    puzzlePositions = List<int?>.filled(puzzlePieces.length, null);
    correctPositions = List<int?>.generate(puzzlePieces.length, (index) => index);  // Correct order of pieces
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

  // Function to show congratulations dialog
  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You solved the puzzle!'),
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
      body: GridView.builder(
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

                    if (_isPuzzleSolved()) {
                      // Puzzle solved, show congratulations
                      _showCongratulationsDialog();
                    }
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
