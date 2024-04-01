import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(124, 102, 236, 100),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(10, 150, 10, 10),
              child: const Text(
                'IMPOSTER',
                style: TextStyle(
                  fontSize: 70,
                  color: Colors.white,
                  fontFamily: 'Grandstander',
                  fontWeight: FontWeight.w800
                ),
              )
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: const Image(
                image: AssetImage('assets/img/mascot.png'),
                width: 400,
                height: 200,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 170, 10, 10),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(context, '/create');
                },
                label: const Text('Create a Room', style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'ShortStack'
                ),),
                icon: const Icon(Icons.add),
                backgroundColor: const Color.fromRGBO(123, 170, 238, 100),
                foregroundColor: Colors.white,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(context, '/join');
                },
                label: const Text('Join a Lobby', style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'ShortStack'
                ),),
                icon: const Icon(Icons.house),
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
