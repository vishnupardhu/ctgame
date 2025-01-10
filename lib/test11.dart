import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ImagePuzzleGame4 extends StatefulWidget {
  const ImagePuzzleGame4({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePuzzleGameState createState() => _ImagePuzzleGameState();
}

class _ImagePuzzleGameState extends State<ImagePuzzleGame4> {
  File? _imageFile;
  img.Image? _image;
  late List<PuzzlePiece> puzzlePieces;
  late List<int> shuffledIndices;
  final int gridSize = 5; // 3x3 grid (9 pieces)
  bool isSolved = false;

  @override
  void initState() {
    super.initState();
    puzzlePieces = [];
    _loadImage();
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _loadImage();
      });
    }
  }

  // Load and split the image into puzzle pieces
  Future<void> _loadImage() async {
    final ByteData data = await rootBundle.load('assets/vis/ct.jpg');
    final Uint8List bytes = data.buffer.asUint8List();
    _image = img.decodeImage(Uint8List.fromList(bytes))!;

    puzzlePieces.clear();
    shuffledIndices = List.generate(gridSize * gridSize, (index) => index);

    // Split the image into pieces
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        int x = col * (_image!.width ~/ gridSize);
        int y = row * (_image!.height ~/ gridSize);
        img.Image piece = img.copyCrop(_image!,
            x: x,
            y: y,
            width: _image!.width ~/ gridSize,
            height: _image!.height ~/ gridSize);
        puzzlePieces.add(PuzzlePiece(piece, row, col));
      }
    }

    _shufflePuzzle();
  }

  // Shuffle the puzzle pieces
  void _shufflePuzzle() {
    setState(() {
      shuffledIndices.shuffle(Random());
      isSolved = false; // Reset the solved state
    });
  }

  // Show the solved puzzle
  void _showSolvedPuzzle() {
    setState(() {
      isSolved = true;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isSolved = false;
      });
    });
  }

  // Check if the puzzle is solved
  bool _isPuzzleComplete() {
    for (int i = 0; i < shuffledIndices.length; i++) {
      if (shuffledIndices[i] != i) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Puzzle Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_album),
            onPressed: _pickImage,
          ),
        ],
      ),
      body: Column(
        children: [
          //if (_imageFile != null)
          Expanded(
            child: Stack(
              children: [
                if (isSolved) _buildSolvedPuzzle() else _buildPuzzleGrid(),
              ],
            ),
          ),

          /// if (_imageFile != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _shufflePuzzle,
                child: Text('Shuffle'),
              ),
              ElevatedButton(
                onPressed: _showSolvedPuzzle,
                child: Text('Show Solved'),
              ),
            ],
          ),
          if (_imageFile == null)
            Center(
              child: Text('Pick an image from gallery to start'),
            ),
        ],
      ),
    );
  }

  // Build the puzzle grid with drag-and-drop functionality
  Widget _buildPuzzleGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridSize,
      ),
      itemCount: gridSize * gridSize,
      itemBuilder: (context, index) {
        int pieceIndex = shuffledIndices[index];
        PuzzlePiece piece = puzzlePieces[pieceIndex];
        return DragTarget<int>(
          onAcceptWithDetails: (details) {
            setState(() {
              int draggedIndex = details.data;

              // Swap dragged and target pieces
              int temp = shuffledIndices[draggedIndex];
              shuffledIndices[draggedIndex] = shuffledIndices[index];
              shuffledIndices[index] = temp;

              // Check if the puzzle is complete
              if (_isPuzzleComplete()) {
                _showCompletionDialog();
              }
            });
          },
          builder: (context, candidateData, rejectedData) {
            return Draggable<int>(
              data: index,
              feedback: _buildPuzzlePiece(piece, 0.7),
              childWhenDragging: Container(
                color: Colors.black12,
              ),
              child: _buildPuzzlePiece(piece),
            );
          },
        );
      },
    );
  }

  // Build the solved puzzle for reference
  Widget _buildSolvedPuzzle() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridSize,
      ),
      itemCount: gridSize * gridSize,
      itemBuilder: (context, index) {
        PuzzlePiece piece = puzzlePieces[index];
        return _buildPuzzlePiece(piece);
      },
    );
  }

  // Builds a single puzzle piece widget
  Widget _buildPuzzlePiece(PuzzlePiece piece, [double opacity = 1.0]) {
    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          image: DecorationImage(
            image: MemoryImage(Uint8List.fromList(img.encodeJpg(piece.image))),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // Show completion dialog
  void _showCompletionDialog() {
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
}

class PuzzlePiece {
  final img.Image image;
  final int row;
  final int col;

  PuzzlePiece(this.image, this.row, this.col);
}
