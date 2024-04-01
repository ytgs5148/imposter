import 'package:flutter/material.dart';
import 'package:imposter/pages/CreateLobby.dart';
import 'package:imposter/pages/Home.dart';
import 'package:imposter/pages/JoinLobby.dart';
import 'package:imposter/pages/RoomPage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String args = settings.arguments.toString();

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/join':
        return MaterialPageRoute(builder: (_) => const JoinLobbyPage());
      case '/create':
        return MaterialPageRoute(builder: (_) => const CreateLobbyPage());
      case '/room':
        return MaterialPageRoute(builder: (_) => RoomPage(data: args));
      default:
        return errorRoute(args);
    }
  }

  static Route<dynamic> errorRoute(String args) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ERROR'),
        ),
        body: Center(
          child: Text('TODO: $args'),
        ),
      );
    });
  }
}
