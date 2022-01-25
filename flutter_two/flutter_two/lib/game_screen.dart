import 'package:flutter/material.dart';
// On crée un jeu de clicker
class GameScreen extends StatefulWidget {
  GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String _nickname = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [ 
            Text("Hello $_nickname"),
            ElevatedButton(
              child: Text("Change nickname"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Change nickname"),
                      content: TextField(
                        onChanged: (String value) {
                          setState(() {
                            _nickname = value;
                          });
                        },
                      ),
                      actions: [
                        ElevatedButton(
                          child: Text("Ok"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              
            ),
          ],
          
          ),
          ),
    );
  }
}