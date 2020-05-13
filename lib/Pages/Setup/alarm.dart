import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Testing'),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: Container(
            child: Column(
                children: <Widget>[
                  Container(
                    child: RaisedButton(
                      onPressed: string,
                    ),
                  ),
                  Container(
                    child: Text(
                      '$x'
                    )
                  ),
        ])));
  }

  List db_data = [];
  List db = [];
  int x = 0;
  List list = ['yaw', 'kofi', 'kitch'];
  void string() async {
    print(list.contains('kitch'));
    print(list.length);
    setState(() {
      x += 1;
    });

    final subscription = FirebaseDatabase.instance.reference().child('testgmailcom').child('Alarm');
    final subscriptions = FirebaseDatabase.instance.reference().child('testgmailcom');
        subscription.onValue.listen((event) {
          subscriptions.once().then((DataSnapshot snapshot){
            Map <dynamic, dynamic> values = snapshot.value;
            print(values['Key']);
            if (values['Key'] == '1'){
              FlutterRingtonePlayer.stop();
            }
          });
    });
    //print(db_data[5]);
    /*int time = DateTime.now().minute;
    Timer.periodic(Duration(seconds: 60), (timer) {
      int newtime = DateTime.now().minute;
      if (newtime == time + 1) print('Kitch');
      time = newtime + 1;
    });*/

    /* final databaseReferences = await FirebaseDatabase.instance.reference()
        .child("Users");
    databaseReferences.once().then((DataSnapshot snapshot) {
      Map <dynamic, dynamic> values = snapshot.value;

    });*/
  }
}
