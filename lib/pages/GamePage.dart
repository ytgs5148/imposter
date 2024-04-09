import 'package:flutter/material.dart';
import 'package:imposter/auth/Database.dart';

class GamePage extends StatefulWidget {
  final String data;

  GamePage({
    super.key,
    required this.data,
  });

  @override
  State<GamePage> createState() => _GamePageState(data);
}

class _GamePageState extends State<GamePage> {
  final String roomCode;
  Database db = Database();

  _GamePageState(this.roomCode);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(124, 102, 236, 100),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Room Code: $roomCode'),
            ElevatedButton(
              onPressed: () {
                db.startGame(roomCode);
              },
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}
