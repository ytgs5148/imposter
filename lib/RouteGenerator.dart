import 'package:flutter/material.dart';
import 'package:imposter/pages/CreateLobby.dart';
import 'package:imposter/pages/GamePage.dart';
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
      case '/game':
        return MaterialPageRoute(builder: (_) => GamePage(data: args));
      default:
        return errorRoute(args);
    }
  }

  static Route<dynamic> errorRoute(String args) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'ERROR: $args',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.red,
                ),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(_, '/home', arguments: args);
                },
                label: const Text(
                  'Go Back',
                  style: TextStyle(fontSize: 26, fontFamily: 'ShortStack'),
                ),
                icon: const Icon(Icons.arrow_forward),
                backgroundColor: Color.fromRGBO(97, 239, 159, 0.612),
                foregroundColor: Colors.white,
              )
            ],
          ),
        )
      );
    });
  }
}
