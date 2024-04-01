import 'package:flutter/material.dart';
import 'package:imposter/auth/Database.dart';
import 'package:imposter/models/Player.dart';
import 'package:imposter/models/Room.dart';
import 'package:imposter/utils/UniqueID.dart';
import 'package:imposter/utils/UpperCaseFormatter.dart';
import 'dart:math';

class CreateLobbyPage extends StatefulWidget {
  const CreateLobbyPage({super.key});

  @override
  State<CreateLobbyPage> createState() => _CreateLobbyPageState();
}

class _CreateLobbyPageState extends State<CreateLobbyPage> {
  String username = '';
  String roomCode = Random().nextInt(1000000).toString();

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
                child: Text(
                  'Create a Room',
                  style: TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontFamily: 'Grandstander',
                      fontWeight: FontWeight.w800),
                )),
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
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  db.createLobby(Room(roomCode: roomCode, host: Player(deviceID: await UniqueID.getId(), username: username), created: DateTime.now(), players: [] ));
                  Navigator.pushNamed(context, '/room', arguments: roomCode);
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
