import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_two/score.dart';
import 'package:flutter_two/score_screen.dart';
import 'package:flutter_two/user.dart';
import 'package:flutter_two/user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GameScreenRemake extends StatefulWidget {
  const GameScreenRemake({Key? key}) : super(key: key);

  @override
  _GameScreenRemakeState createState() {
    return _GameScreenRemakeState();
  }
}

class _GameScreenRemakeState extends State<GameScreenRemake> {
  int _counter = 0;
  List<int> scores = [];
  List<Score> scoreList = [];
  bool _gameIsRunning = false;
  bool _gameIsOver = false;
  bool _nameIsEntered = false;
  String _name = '';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void endTheGame() {
    setState(() {
      _gameIsRunning = false;
      _gameIsOver = true;

      scoreList.add(Score(_counter, _name));
      final bestScore = scoreList.reduce((a, b) => a.score > b.score ? a : b);
      storeBestScore(bestScore);

      _counter = 0;
    });
  }

  storeBestScore(Score bestScore) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bestScore', bestScore.score);
    await prefs.setString('name', bestScore.name);
  }

  Future<Score?> getBestScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? bestScore = prefs.getInt('bestScore');
    String? name = prefs.getString('name');
    if (bestScore != null && name != null) {
      return Score(bestScore, name);
    }
    return null;
  }

  Future<List<User>> getUsers() async {
    List<User> users;
    http.Response response =
        await http.get(Uri.parse("https://randomuser.me/api/"));
    if (response.statusCode == 200) {
      List listMap = jsonDecode(response.body)["results"];
      users = listMap.map((userMap) => User.fromJson(userMap)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  void _startGame() {
    setState(() {
      _counter = 0;
      _gameIsRunning = true;
    });
    Timer(const Duration(seconds: 5), endTheGame);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ClickErwan"),
      ),
      body: Center(
          child: FutureBuilder<Score?>(
        future: getBestScore(),
        builder: getWidget,
      )),

      // Only enable the button if the game is enabled
      floatingActionButton: _gameIsRunning
          ? FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget getWidget(BuildContext context, AsyncSnapshot<Score?> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      final score = snapshot.data;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Mettre un titre "meilleurs scores" et puis mettre la liste de scores
          Text(
            "Meilleur score",
            style: Theme.of(context).textTheme.headline3,
          ),
          Text(
            score == null ? "Aucun score" : score.toString(),
            style: Theme.of(context).textTheme.headline4,
          ),
          Text("Historique des scores",
              style: Theme.of(context).textTheme.headline5),
          Column(
            children: scoreList.map((score) => Text(score.toString())).toList(),
          ),

          if (!_gameIsRunning && _nameIsEntered)
            ElevatedButton(
              child: const Text('Commencer'),
              onPressed: _startGame,
            ),

          const Text(
            'Nombre de clics :',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headline4,
          ),

          if (!_gameIsRunning)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autocorrect: false,
                autofillHints: const [AutofillHints.username],
                decoration: const InputDecoration(
                  hintText: 'Entrez un pseudo',
                ),
                onSubmitted: (String value) {
                  setState(() {
                    _nameIsEntered = value.isNotEmpty;
                    if (_nameIsEntered) {
                      _name = value;
                    }
                  });
                },
              ),
            ),
          //On met le bouton centré verticalement

          //Bouton pour augmenter le nombre de clics
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ElevatedButton(
                child: const Text('+'),
                onPressed: _gameIsRunning ? _incrementCounter : null,
              ),
              //Bouton pour aller vers l'écran des scores
              if (!_gameIsRunning)
                ElevatedButton(
                  child: const Text('Go to scores'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScoreScreen(scoreList),
                      ),
                    );
                  },
                ),

              if (!_gameIsRunning)
                ElevatedButton(
                  child: const Text('Go to Users'),
                  onPressed: () async {
                    List<User> users = await getUsers();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserScreen(users),
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      );
    } else if (snapshot.hasError) {
      return Text("${snapshot.error}");
    } else {
      return const CircularProgressIndicator();
    }
  }
}
