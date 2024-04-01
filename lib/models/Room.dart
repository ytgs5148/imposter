import 'package:imposter/models/Player.dart';

class Room {
  final String roomCode;
  final Player host;
  final DateTime created;
  final List<Player> players;

  Room({ 
    required this.roomCode, 
    required this.host,
    required this.created,
    required this.players
  });
}