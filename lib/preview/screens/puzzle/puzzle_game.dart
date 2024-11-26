import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  int currentPuzzle = 1;
  final int totalPuzzles = 3;
  List<int> currentArrangement = List.generate(9, (index) => index);

  bool isPuzzleComplete() {
    for (int i = 0; i < currentArrangement.length; i++) {
      if (currentArrangement[i] != i) return false;
    }
    return true;
  }

  void _showCompletionMessage(bool isLastPuzzle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isLastPuzzle
              ? 'Congratulations! All puzzles completed!'
              : 'Puzzle $currentPuzzle completed!',
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          if (isLastPuzzle) {
            currentPuzzle = 1;
          } else {
            currentPuzzle++;
          }
          currentArrangement = List.generate(9, (index) => index);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    currentArrangement.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4052EE),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Put the puzzle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return DragTarget<int>(
                      onAccept: (receivedIndex) {
                        setState(() {
                          final temp = currentArrangement[index];
                          currentArrangement[index] =
                              currentArrangement[receivedIndex];
                          currentArrangement[receivedIndex] = temp;

                          if (isPuzzleComplete()) {
                            _showCompletionMessage(
                                currentPuzzle == totalPuzzles);
                          }
                        });
                      },
                      builder: (context, accepted, rejected) {
                        return Draggable<int>(
                          data: index,
                          feedback: Image.asset(
                            'assets/puz$currentPuzzle/${currentArrangement[index] + 1}.png',
                            width: 100,
                            height: 100,
                          ),
                          childWhenDragging: Container(
                            color: Colors.grey[300],
                          ),
                          child: Image.asset(
                            'assets/puz$currentPuzzle/${currentArrangement[index] + 1}.png',
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CupertinoButton(
                color: Colors.white,
                child: const Text(
                  'Next',
                  style: TextStyle(color: Color(0xFF4052EE)),
                ),
                onPressed: () {
                  setState(() {
                    currentPuzzle =
                        currentPuzzle < totalPuzzles ? currentPuzzle + 1 : 1;
                    currentArrangement = List.generate(9, (index) => index)
                      ..shuffle();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
