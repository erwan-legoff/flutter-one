import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_two/score.dart';

class ScoreScreen extends StatelessWidget {
  List<Score> _scores;

  ScoreScreen( this._scores, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Score'),
      ),
      // Centrer la liste avec expendable
      
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: _scores.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(_scores[index].name),
                subtitle: Text("${_scores[index].score}"),
              );
            },
          ),
        ),
      ),
    );
  }
}
