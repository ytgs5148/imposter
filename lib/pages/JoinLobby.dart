import 'package:flutter/material.dart';
import 'package:imposter/auth/Database.dart';
import 'package:imposter/models/Player.dart';
import 'package:imposter/utils/UniqueID.dart';
import 'package:imposter/utils/UpperCaseFormatter.dart';

class JoinLobbyPage extends StatefulWidget {
  const JoinLobbyPage({super.key});

  @override
  State<JoinLobbyPage> createState() => _JoinLobbyPageState();
}

class _JoinLobbyPageState extends State<JoinLobbyPage> {

  String username = '';
  String roomCode = '';
  
  Database db = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(124, 102, 236, 100),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.fromLTRB(10, 150, 10, 10),
                child: const Text(
                  'ENTER CODE:',
                  style: TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontFamily: 'Grandstander',
                      fontWeight: FontWeight.w800
                    ),
                  )
              ),
            Container(
              padding: const EdgeInsets.fromLTRB(50, 100, 50, 0),
              child: TextField(
                onChanged: (value) {
                  username = value;
                },
                maxLength: 12,
                inputFormatters: [UpperCaseTextFormatter()],
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ShadowsIntoLight',
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter username',
                  // labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(238, 238, 238, 100),
                  prefixIcon: Icon(Icons.person),
                  prefixIconColor: Colors.black,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 48),
              child: TextField(
                onChanged: (value) {
                  roomCode = value;
                },
                keyboardType: TextInputType.number,
                maxLength: 8,
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ShadowsIntoLight',
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter room code',
                  // labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(238, 238, 238, 100),
                  prefixIcon: Icon(Icons.home),
                  prefixIconColor: Colors.black,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  if (username.isEmpty || roomCode.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please fill in all fields!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  db.joinLobby(roomCode, Player(username: username, deviceID: await UniqueID.getId()));
                  Navigator.pushNamedAndRemoveUntil(context, '/room', (route) => false, arguments: roomCode);
                },
                label: const Text(
                  'Join',
                  style: TextStyle(fontSize: 30, fontFamily: 'ShortStack'),
                ),
                icon: const Icon(Icons.arrow_forward),
                backgroundColor: const Color.fromRGBO(240, 98, 148, 100),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
