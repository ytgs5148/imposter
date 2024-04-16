import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imposter/auth/Database.dart';
import 'package:imposter/utils/UniqueID.dart';

class RoomPage extends StatefulWidget {
  final String data;

  RoomPage({
    super.key,
    required this.data,
  });

  @override
  State<RoomPage> createState() => _RoomPageState(data);
}

class _RoomPageState extends State<RoomPage> {
  final String roomCode;
  Database db = Database();

  _RoomPageState(this.roomCode);

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
                  'PLAYERS:',
                  style: TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontFamily: 'Grandstander',
                      fontWeight: FontWeight.w800),
                )),
            StreamBuilder<QuerySnapshot>(
              stream: Database().getLobbySnapshot(roomCode),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data != null) {
                    if (snapshot.data!.docs.isEmpty) Navigator.pushNamedAndRemoveUntil(context, '/error', (route) => false, arguments: 'Invalid room code');
                    Map<String, dynamic> data = snapshot.data!.docs[0].data() as Map<String, dynamic>;

                    if (data['status'] == 1) {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        String deviceID = await UniqueID.getId();
                        Navigator.pushNamedAndRemoveUntil(context, '/game', (route) => false, arguments: '${roomCode}_${deviceID}');
                      });
                    } else if (data['status'] == 2) {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        String deviceID = await UniqueID.getId();
                        Navigator.pushNamedAndRemoveUntil(context, '/results', (route) => false, arguments: '${roomCode}_${deviceID}');
                      });
                    }

                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(Icons.star, color: Colors.white, size: 20),
                                  ),
                                ),
                                TextSpan(
                                  text: data['host']['username'], 
                                  style: TextStyle(
                                    fontSize: 20, 
                                    color: Colors.white, 
                                    fontFamily: 'ShortStack', 
                                    fontWeight: FontWeight.w800
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                        for (var player in data['players'])
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text(
                              player['username'],
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'ShortStack',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                      ],
                    );
                  } else return Center(child: Text('No players in lobby'));
                } else return Center(child: CircularProgressIndicator());
              },
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 200, 10, 0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: roomCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Code ${roomCode} copied to clipboard! 📋'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                label: const Text(
                  'Copy Code',
                  style: TextStyle(fontSize: 30, fontFamily: 'ShortStack'),
                ),
                icon: const Icon(Icons.copy),
                backgroundColor: const Color.fromRGBO(240, 98, 148, 100),
                foregroundColor: Colors.white,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  db.startGame(roomCode);
                  String deviceID = await UniqueID.getId();
                  Navigator.pushNamedAndRemoveUntil(context, '/game', (route) => false, arguments: '${roomCode}_${deviceID}');
                },
                label: const Text(
                  'Start Game',
                  style: TextStyle(fontSize: 26, fontFamily: 'ShortStack'),
                ),
                icon: const Icon(Icons.arrow_forward),
                backgroundColor: Color.fromRGBO(97, 239, 159, 0.612),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
