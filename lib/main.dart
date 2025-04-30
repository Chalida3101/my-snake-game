import 'package:flutter/material.dart';
import 'screens/game_screen.dart'; // <-- ตรงนี้ให้ตรงกับ path ที่คุณเก็บ GameScreen

void main() {
  runApp(const SnakeGameApp());
}

class SnakeGameApp extends StatelessWidget {
  const SnakeGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cute Anime Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Kanit', // ถ้าคุณใช้ฟอนต์ Kanit
      ),
      home: const UsernameInputScreen(),
    );
  }
}

class UsernameInputScreen extends StatefulWidget {
  const UsernameInputScreen({super.key});

  @override
  State<UsernameInputScreen> createState() => _UsernameInputScreenState();
}

class _UsernameInputScreenState extends State<UsernameInputScreen> {
  final TextEditingController _controller = TextEditingController();

  void _startGame() {
    final username = _controller.text.trim();
    if (username.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(username: username),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter Your Username',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _startGame,
                child: const Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
