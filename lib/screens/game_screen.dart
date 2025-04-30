import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameScreen extends StatefulWidget {
  final String username;
  const GameScreen({super.key, required this.username});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

enum Direction { up, down, left, right }

class Point {
  final int x;
  final int y;
  const Point(this.x, this.y);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point && runtimeType == other.runtimeType && x == other.x && y == other.y;
  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class _GameScreenState extends State<GameScreen> {
  static const int rowCount = 20;
  static const int colCount = 20;
  List<Point> snake = [const Point(10, 10)];
  Direction direction = Direction.right;
  Timer? gameLoop;
  Point food = const Point(5, 5);

  @override
  void initState() {
    super.initState();
    startGame();
    RawKeyboard.instance.addListener(handleKey);
  }

  @override
  void dispose() {
    gameLoop?.cancel();
    RawKeyboard.instance.removeListener(handleKey);
    super.dispose();
  }

  void startGame() {
    spawnFood();
    gameLoop = Timer.periodic(const Duration(milliseconds: 200), (_) {
      moveSnake();
    });
  }

  void handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      switch (event.logicalKey.keyLabel.toLowerCase()) {
        case 'w': if (direction != Direction.down) direction = Direction.up; break;
        case 's': if (direction != Direction.up) direction = Direction.down; break;
        case 'a': if (direction != Direction.right) direction = Direction.left; break;
        case 'd': if (direction != Direction.left) direction = Direction.right; break;
      }
    }
  }

  void moveSnake() {
    final head = snake.first;
    Point newHead;
    switch (direction) {
      case Direction.up:    newHead = Point(head.x, head.y - 1); break;
      case Direction.down:  newHead = Point(head.x, head.y + 1); break;
      case Direction.left:  newHead = Point(head.x - 1, head.y); break;
      case Direction.right: newHead = Point(head.x + 1, head.y); break;
    }
    // Game Over checks
    if (newHead.x < 0 || newHead.y < 0 || newHead.x >= colCount || newHead.y >= rowCount || snake.contains(newHead)) {
      gameLoop?.cancel();
      showGameOverDialog();
      return;
    }
    setState(() {
      snake.insert(0, newHead);
      if (newHead == food) spawnFood(); else snake.removeLast();
    });
  }

  void spawnFood() {
    final rng = Random();
    Point newFood;
    do {
      newFood = Point(rng.nextInt(colCount), rng.nextInt(rowCount));
    } while (snake.contains(newFood));
    setState(() => food = newFood);
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Score: ${snake.length - 1}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              restartGame();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  void restartGame() {
    setState(() {
      snake = [const Point(10, 10)];
      direction = Direction.right;
    });
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ผู้เล่น: ${widget.username}')),
      body: Center(
        child: AspectRatio(
          aspectRatio: colCount / rowCount,
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rowCount * colCount,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: colCount),
              itemBuilder: (context, index) {
                final x = index % colCount;
                final y = index ~/ colCount;
                final p = Point(x, y);
                final isSnake = snake.contains(p);
                final isFood = p == food;
                return Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: isFood ? Colors.red : isSnake ? Colors.green : Colors.grey[200],
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}