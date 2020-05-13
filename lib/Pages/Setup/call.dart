import 'package:flutter/material.dart';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: Center(
          child: RaisedButton(
            onPressed: _launchURL,
            child: Text('Dial a number'),
          )
      ),
    ));
  }
}


_launchURL() async {
  // Replace 12345678 with your tel. no.

  android_intent.Intent()
    ..setAction(android_action.Action.ACTION_CALL)
    ..setAction(android_action.Action.ACTION_SEND)
    ..setData(Uri(scheme: "tel", path: "12345678"))
    ..startActivity().catchError((e) => print(e));
}