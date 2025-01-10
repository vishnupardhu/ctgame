import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class PuzzleGridFiveGAme extends StatefulWidget {
  const PuzzleGridFiveGAme({super.key});

  @override
  State<PuzzleGridFiveGAme> createState() => _PuzzleGridFiveGAmeState();
}

class _PuzzleGridFiveGAmeState extends State<PuzzleGridFiveGAme> {
   File? _imageFile;
  img.Image? _image;
  late List<PuzzlePiece> puzzlePieces;
  List<int> shuffledIndices =[];
  final int gridSize = 5; // 3x3 grid (9 pieces)
  bool isSolved = false;

 
 // List<String> puzzleims =['assets/puzzle/v1.jpg','assets/puzzle/v2.jpg','assets/puzzle/v3.jpg','assets/puzzle/v4.jpg','assets/puzzle/v5.jpg','assets/puzzle/v6.jpg','assets/puzzle/v7.jpg','assets/puzzle/v8.jpg','assets/puzzle/v9.jpg','assets/puzzle/v10.jpg','assets/puzzle/b1.jpg','assets/puzzle/b2.jpg','assets/puzzle/b3.jpg','assets/puzzle/b4.jpg','assets/puzzle/b5.jpg','assets/puzzle/b6.jpg','assets/puzzle/b7.jpg','assets/puzzle/b8.jpg','assets/puzzle/b9.jpg','assets/puzzle/b10.jpg','assets/puzzle/b11.jpg'];
  List<String> puzzleims =['assets/puzzle/c1.jpg','assets/puzzle/c2.jpg','assets/puzzle/c3.jpg','assets/puzzle/c4.jpg','assets/puzzle/c5.jpg','assets/puzzle/c6.jpg','assets/puzzle/c7.jpg','assets/puzzle/c8.jpg','assets/puzzle/c9.jpg','assets/puzzle/c10.jpg','assets/puzzle/c11.jpg','assets/puzzle/c12.jpg'];
  

  late String displayedString;
  void getRandomString() {
    final random = Random();
    setState(() {
      // Selecting a random string from the list
      displayedString = puzzleims[random.nextInt(puzzleims.length)];
    });
      _loadImage();
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _loadImageGallery();
         puzzlePieces.clear();
        shuffledIndices.clear();
        isSolved = false;
      });
    }
  }

  
 Future<void> _loadImageGallery() async {
     final bytes = await _imageFile?.readAsBytes();
    _image = img.decodeImage(Uint8List.fromList(bytes!))!;

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

  
  // Load and split the image into puzzle pieces
  Future<void> _loadImage() async {
    final ByteData data = await rootBundle.load(displayedString);
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
  void initState() {
    super.initState();
       getRandomString();
    puzzlePieces = [];
    _loadImage();
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
                if (isSolved) _buildSolvedPuzzle() else (shuffledIndices.isEmpty ? SizedBox(height: 20,) : _buildPuzzleGrid()),
              ],
            ),
          ),

          /// if (_imageFile != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: getRandomString,
                child: Text('Refresh'),
              ),
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
