import 'package:imposter/models/Player.dart';

class Room {
  final String roomCode;
  final Player host;
  final DateTime created;
  final List<Player> players;
  final num status;
  final Player? imposter;
  final String? mainQuestion;
  final String? imposterQuestion;

  Room({ 
    required this.roomCode, 
    required this.host,
    required this.created,
    required this.players,
    required this.status,
    this.imposter,
    this.mainQuestion,
    this.imposterQuestion
  });

  static fromJSON(Map<String, dynamic> data) {
    return Room(
      roomCode: data['roomCode'],
      host: Player.fromJSON(data['host']),
      created: data['created'],
      players: data['players'].map<Player>((player) => Player.fromJSON(player)).toList(),
      status: data['status'],
      imposter: data['imposter'] != null ? Player.fromJSON(data['imposter']) : null,
      mainQuestion: data['mainQuestion'],
      imposterQuestion: data['imposterQuestion']
    );
  }
}