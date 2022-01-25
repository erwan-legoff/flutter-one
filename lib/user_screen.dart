import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_two/score.dart';
import 'package:flutter_two/user.dart';

class UserScreen extends StatelessWidget {
  List<User> _users;

  UserScreen( this._users, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Utilisateurs'),
      ),
      // Centrer la liste avec expendable
      
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(_users[index].name),
                subtitle: Text(_users[index].name),
                
              );
            },
          ),
        ),
      ),
    );
  }
}
