import 'package:flutter/material.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:url_launcher/url_launcher.dart';

class Emergency extends StatefulWidget {
  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Emergency Calling"),
      ),
      body: new Center(
        child: new FlatButton(
            onPressed: _launchCaller,
            child: new Text("Call Ambulance")),
      ),
    );;
  }
}
_launchCaller() async {
  FlutterPhoneState.startPhoneCall("480-555-1234");
}
