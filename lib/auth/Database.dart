import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imposter/models/Player.dart';
import 'package:imposter/models/Room.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  createLobby(Room roomInfo) {
    _firestore.collection('lobbies').add({
      'roomCode': roomInfo.roomCode,
      'host': roomInfo.host.toJSONEncodable(),
      'players': roomInfo.players.map((player) => player.toJSONEncodable()).toList(),
      'created': roomInfo.created,
    }).then((value) => print('Document added with id: ${value.id}'));
  }

  getLobby(String roomCode) {
    return _firestore.collection('lobbies').where('roomCode', isEqualTo: roomCode).snapshots();
  }

  joinLobby(String roomCode, Player player) {
    return _firestore.collection('lobbies').where('roomCode', isEqualTo: roomCode).get().then((value) {
      if (value.docs.isNotEmpty) {
        var lobby = value.docs[0];
        var players = lobby.data()['players'];
        players.add(player.toJSONEncodable());
        lobby.reference.update({ 'players': players });
      }
    });
  }
}