import 'package:flutter/material.dart';
import 'package:imposter/auth/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imposter/models/Player.dart';
import 'package:imposter/models/Room.dart';
import 'package:imposter/utils/UniqueID.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
  final String args;
  
  late String roomCode = args.split('_')[0];
  late String deviceID = args.split('_')[1];

  String? selectedValue = null;
  Database db = Database();

  _GamePageState(this.args);

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
                    if (snapshot.data!.docs.isEmpty) Navigator.pushNamedAndRemoveUntil(context, '/error', (route) => false, arguments: 'Invalid room code');

                    Room data = Room.fromJSON(snapshot.data!.docs[0].data() as Map<String, dynamic>);
                    List<Player> allPlayers = data.players + [data.host];
                    String questionToBeDisplayed = ((data.imposter?.deviceID != deviceID) ? data.mainQuestion : data.imposterQuestion) ?? 'Error fetching question';
                    num ofVotes = allPlayers.where((player) => player.votedFor != null).length;
                    Player user = allPlayers.firstWhere((player) => player.deviceID == deviceID);
                    List<Player> allPlayersExceptUser = allPlayers.where((player) => player.deviceID != deviceID).toList();

                    if ((ofVotes == allPlayers.length && data.status != 0) || data.status == 2) {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        db.endGame(roomCode);
                        Navigator.pushNamedAndRemoveUntil(context, '/results', (route) => false, arguments: '${roomCode}_${deviceID}');
                      });
                    }

                    if (data.status == 1) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 80, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                  child: Icon(Icons.ballot, color: Colors.white, size: 40),
                                ),
                                Text('VOTES: ${ofVotes}/${allPlayers.length}', style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'TiltNeon',
                                    color: Colors.white,
                                  )
                                ),
                              ],
                            )
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 100, 10, 0),
                            child: Card.filled(
                              shadowColor: Colors.black,
                              color: Color.fromRGBO(224, 210, 236, 1),
                              elevation: 10,
                              child: SizedBox(
                                width: 350,
                                height: 100,
                                child: Center(
                                  child: Text(
                                    questionToBeDisplayed,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'TiltNeon',
                                    ),
                                  )
                                ),
                              ),
                            )
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                hint: Text('Choose a person'),
                                items: allPlayersExceptUser.map((player) => DropdownMenuItem(child: Text(player.username), value: player.deviceID)).toList(),
                                onChanged: (String? value) => setState(() => selectedValue = value),
                                value: selectedValue,
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: 160,
                                  padding: const EdgeInsets.only(left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Color.fromRGBO(224, 210, 236, 1), // Changed color here
                                  ),
                                  elevation: 2,
                              ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_forward,
                                  ),
                                  iconSize: 14,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: 200,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 200, 10, 0),
                            child: FloatingActionButton.extended(
                              onPressed: () async {
                                if (user.votedFor != null && user.votedFor != '') {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have already voted')));
                                  return;
                                };
                                String deviceID = await UniqueID.getId();
                                if (selectedValue == null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a player')));
                                else Database().addVote(roomCode, allPlayers.firstWhere((player) => player.deviceID == deviceID), selectedValue ?? '');
                              },
                              label: const Text(
                                'Vote',
                                style: TextStyle(fontSize: 30, fontFamily: 'ShortStack'),
                              ),
                              icon: const Icon(Icons.arrow_forward),
                              backgroundColor: user.votedFor != null ? const Color.fromRGBO(65, 65, 65, 100) : const Color.fromRGBO(240, 98, 148, 100),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ); 
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        String deviceID = await UniqueID.getId();
                        Navigator.pushNamedAndRemoveUntil(context, '/room', (route) => false, arguments: '${roomCode}_${deviceID}');
                      });
                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              db.startGame(roomCode);
                            },
                            child: Text('Start Game'),
                          ),
                        ],
                      );
                    }
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
