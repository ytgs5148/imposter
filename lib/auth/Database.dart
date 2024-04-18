import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imposter/models/Player.dart';
import 'package:imposter/models/Questions.dart';
import 'package:imposter/models/Room.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  createLobby(Room roomInfo) {
    return _firestore.collection('lobbies').add({
      'roomCode': roomInfo.roomCode,
      'host': roomInfo.host.toJSONEncodable(),
      'players': roomInfo.players.map((player) => player.toJSONEncodable()).toList(),
      'created': roomInfo.created,
      'status': roomInfo.status,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLobbySnapshot(String roomCode) {
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

  startGame(String roomCode) async {
    Map<String, dynamic> room = await this.getLobbySnapshot(roomCode).map((event) => event.docs[0].data()).first;
    List<dynamic> players = room['players'] + [room['host']];
    Map<String, dynamic> imposter = players[new Random().nextInt(players.length)];
    List<String> question = Questions().getQuestions();

    return _firestore.collection('lobbies').where('roomCode', isEqualTo: roomCode).get().then((value) {
      if (value.docs.isNotEmpty) {
        var lobby = value.docs[0];
        lobby.reference.update({ 
          'status': 1, 
          'imposter': imposter,
          'mainQuestion': question[0],
          'imposterQuestion': question[1]
        });
      } else print('No lobby found');
    });
  }

  addVote(String roomCode, Player user, String targetDeviceID) {
    return _firestore.collection('lobbies').where('roomCode', isEqualTo: roomCode).get().then((value) {
      if (value.docs.isNotEmpty) {
        var data = value.docs[0].data();
        var player = data['players'].firstWhere((element) => element['deviceID'] == user.deviceID);

        player['votedFor'] = targetDeviceID;
        value.docs[0].reference.update({ 'players': data['players'] });
      } else print('No lobby found');
    });
  }

  endGame(String roomCode) {
    return _firestore.collection('lobbies').where('roomCode', isEqualTo: roomCode).get().then((value) {
      if (value.docs.isNotEmpty) {
        var lobby = value.docs[0];
        lobby.reference.update({ 'status': 2 });
      } else print('No lobby found');
    });
  }

  restartGame(String roomCode) async {
    return await _firestore.collection('lobbies').where('roomCode', isEqualTo: roomCode).get().then((value) {
      if (value.docs.isNotEmpty) {
        var lobby = value.docs[0];
        lobby.reference.update({ 'status': 0 });
      } else print('No lobby found');
    });
  }

  deleteLobby(String roomCode) {
    return _firestore.collection('lobbies').where('roomCode', isEqualTo: roomCode).get().then((value) {
      if (value.docs.isNotEmpty) {
        var lobby = value.docs[0];
        lobby.reference.delete();
      } else print('No lobby found');
    });
  }

  kickPlayer(String roomCode, String userDeviceID) {
    return _firestore.collection('lobbies').where('roomCode', isEqualTo: roomCode).get().then((value) {
      if (value.docs.isNotEmpty) {
        var data = value.docs[0].data();
        var players = data['players'].where((element) => element['deviceID'] != userDeviceID).toList();
        value.docs[0].reference.update({ 'players': players });
      } else print('No lobby found');
    });
  }
}