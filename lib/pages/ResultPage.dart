import 'package:flutter/material.dart';
import 'package:imposter/auth/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imposter/models/Player.dart';
import 'package:imposter/models/Room.dart';
import 'package:collection/collection.dart';
import 'package:imposter/utils/UniqueID.dart';

class ResultPage extends StatefulWidget {
  final String data;

  ResultPage({
    super.key,
    required this.data,
  });

  @override
  State<ResultPage> createState() => _ResultPageState(data);
}

class _ResultPageState extends State<ResultPage> {
  final String args;
  
  late String roomCode = args.split('_')[0];
  late String deviceID = args.split('_')[1];

  String? selectedValue = null;
  Database db = Database();

  _ResultPageState(this.args);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(124, 102, 236, 100),
      body: Center(
        child: Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: Database().getLobbySnapshot(roomCode),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data != null) {
                    if (snapshot.data!.docs.isEmpty) Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

                    Room data = Room.fromJSON(snapshot.data!.docs[0].data() as Map<String, dynamic>);
                    List<Player> allPlayers = data.players + [data.host];
                    List<Map<String, String>> votes = allPlayers.map((player) => {
                      'username': player.username,
                      'votedFor': allPlayers.firstWhereOrNull((p) => p.deviceID == player.votedFor)?.username ?? 'N/A'
                    }).toList();

                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 150, 10, 10),
                          child: const Text(
                            'VOTES:',
                            style: TextStyle(
                                fontSize: 60,
                                color: Colors.white,
                                fontFamily: 'Grandstander',
                                fontWeight: FontWeight.w800
                              ),
                            )
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Table(
                            border: TableBorder.all(width: 1.0, style: BorderStyle.none),
                            children: [
                              TableRow(
                                children: [
                                  TableCell(child: Center(child: Text('Username', style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    fontFamily: 'Grandstander'
                                  ),))),
                                  TableCell(child: Center(child: Text('Voted for', style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    fontFamily: 'Grandstander'
                                  )))),
                                ],
                              ),
                              for (var vote in votes)
                                TableRow(
                                  children: [
                                    TableCell(child: Center(child: Text(vote['username'] ?? 'N/A', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                    )))),
                                    TableCell(child: Center(child: Text(vote['votedFor'] ?? 'N/A', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                    )))),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 150, 10, 0),
                          child: FloatingActionButton.extended(
                            onPressed: () async {
                              await db.restartGame(roomCode);
                              WidgetsBinding.instance.addPostFrameCallback((_) async {
                                String deviceID = await UniqueID.getId();
                                Navigator.pushNamedAndRemoveUntil(context, '/room', (route) => false, arguments: '${roomCode}_${deviceID}');
                              });
                            },
                            label: const Text(
                              'Restart',
                              style: TextStyle(fontSize: 29, fontFamily: 'ShortStack'),
                            ),
                            icon: const Icon(Icons.replay),
                            backgroundColor: const Color.fromRGBO(240, 98, 148, 100),
                            foregroundColor: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                          child: FloatingActionButton.extended(
                            onPressed: () async {
                              db.deleteLobby(roomCode);
                              Navigator.pushNamedAndRemoveUntil(context, '/create', (route) => false);
                            },
                            label: const Text(
                              'New Lobby',
                              style: TextStyle(fontSize: 22, fontFamily: 'ShortStack'),
                            ),
                            icon: const Icon(Icons.leave_bags_at_home),
                            backgroundColor: Color.fromRGBO(97, 239, 159, 0.612),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ]
                    );
                  } else return Center(child: Text('No players in lobby'));
                } else return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
