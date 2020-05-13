import 'package:flutter/material.dart';

class data extends StatelessWidget {
  final List bpm;
  const data({Key key, @required this.bpm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Display of Bpm Data')),
        body: Form(
            child: ListView.builder(
                itemCount: bpm.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      (bpm[index]),
                    ),
                  );
                }
            )
        ),
    );
  }
}



