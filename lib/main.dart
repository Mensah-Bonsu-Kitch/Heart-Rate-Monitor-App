import 'package:flutter/material.dart';
import 'Pages/Setup/WelcomePage.dart';
import 'Pages/Setup/DoctorsPage.dart';
import 'Pages/Setup/call.dart';

void main() {
  runApp(new HeartMonitor());
}

class HeartMonitor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  InheritedState(
        child: MaterialApp(
            home: WelcomePage()
        )
    );
  }
}

