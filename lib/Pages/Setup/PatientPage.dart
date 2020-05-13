import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fit_kit/fit_kit.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chart.dart';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;

class PatientsPage extends StatefulWidget {

  final String email;
  PatientsPage(this.email);
  @override
  _PatientsPage createState() => _PatientsPage();
}
class _PatientsPage extends State<PatientsPage> {
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    run_func();
    getStringValuesSF();

  }

  Widget _avg_bpm() {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Text(
        'Average heart rate',
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xffe46b10), fontSize: 18),
      ),
    );
  }

  Widget _avg_sbp() {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Text(
        'Average SBP',
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xffe46b10), fontSize: 20),
      ),
    );
  }

  Widget _heart_condition() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 30,
      decoration: BoxDecoration(
          color: Color(0xffe46b10), shape: BoxShape.rectangle),
      child: Text(
        '$heart_state',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  Widget _display_bpm() {
    return Container(
      width: 150.0,
      height: 150.0,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle, border: Border.all(
          color: Color(0xffe46b10),
        width: 4,
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('$bpm_avg_value', style: TextStyle(color: Color(0xffe46b10), fontSize: 50))
        ],
      ),
    );
  }

  Widget _display_sbp() {
    return Container(
      width: 150.0,
      height: 150.0,
      margin: EdgeInsets.all(5.0),
      decoration:
      BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle, border: Border.all(
        color: Color(0xffe46b10),
        width: 4
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('$sbp_avg_value',style: TextStyle(color: Color(0xffe46b10), fontSize: 50)),
        ],
      ),
    );
  }

  Widget _read_data() {
    return RaisedButton(
      onPressed: () {
        readdata(name);
      },
      child: Text("Read heart data",
          style: TextStyle(
              color: Color(0xfff79c4f),
              fontSize: 20,
              fontWeight: FontWeight.w600)),
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.deepOrangeAccent)),
    );
  }

  Widget chart_view() {
    return RaisedButton(
      onPressed: () {
        chart();
      },
      child: Text("View Chart",
          style: TextStyle(
              color: Color(0xfff79c4f),
              fontSize: 20,
              fontWeight: FontWeight.w600)),
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.deepOrangeAccent)),
    );
  }

  Widget stop_alarm() {
    return RaisedButton(
      onPressed: () {
        stop();
      },
      child: Text("Stop alarm",
          style: TextStyle(
              color: Color(0xfff79c4f),
              fontSize: 20,
              fontWeight: FontWeight.w600)),
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.deepOrangeAccent)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor Heart Rate'),
        backgroundColor: Color(0xffe46b10),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              refresh_page();
            },
          )
        ],
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Container(
                  child: Row(
                      children: <Widget>[
                        Expanded(
                          child: _avg_bpm(),
                        ),
                        Expanded(
                          child: _avg_sbp(),
                        ),
                      ]
                  )

              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _display_bpm(),
                      ),
                      Expanded(
                        child: _display_sbp(),
                      ),
                    ],
                  )),
              SizedBox(
                height: 50,
              ),
              _heart_condition(),
              SizedBox(
                height: 50,
              ),
              Container(
                  child: Column(
                    children: <Widget>[_read_data(), chart_view(), stop_alarm()],
                  )
              ),
            ],
          )),
    );
  }

  void run_func() {
    Timer.periodic(Duration(seconds: 720), (timer) {
      readdata(name);
    });
  }
  void stop() {
    FlutterRingtonePlayer.stop();
  }
  String name;
  int bpm_avg_value;
  int sbp_avg_value;
  String heart_state;
  List bpm = [];
  List time = [];
  List bpm_abs;
  List time_abs;
  double avg_bpm = 0;
  double avg_sbp = 0;
  int data_len;

  void readdata(x) async {
    String UniqueUser = x;
    final results = await FitKit.read(DataType.HEART_RATE,
        dateFrom: DateTime.now().subtract(Duration(days: 20)),
        dateTo: DateTime.now());
      data_len = results.length;
      bpm.clear();
      time.clear();
      for (int i = 0; i < data_len; i++) {
        bpm.add(results[i].value);
        avg_bpm += results[i].value;
        avg_sbp += 0.383 * (results[i].value) + 108.222;
        time.add(results[i].dateTo.toString());
      }
      if (avg_bpm == 0) {
        bpm_avg_value = 0;
        sbp_avg_value = 0;
        heart_state = 'You have no data yet';
      }
      else {
        bpm_avg_value = (avg_bpm / data_len).toInt();
        sbp_avg_value = (avg_sbp / data_len).toInt();

        int heart_condition = 0;
        if (bpm_avg_value >= 51 && bpm_avg_value <= 100) {
          heart_condition += 0;
        }
        if (bpm_avg_value >= 41 && bpm_avg_value <= 50) {
          heart_condition += 1;
        }
        if (bpm_avg_value >= 101 && bpm_avg_value <= 110) {
          heart_condition += 1;
        }
        if (bpm_avg_value >= 111 && bpm_avg_value <= 129) {
          heart_condition += 2;
        }
        if (bpm_avg_value >= 130) {
          heart_condition += 3;
        }
        if (bpm_avg_value <= 40) {
          heart_condition += 2;
        }
        if (sbp_avg_value >= 200) {
          heart_condition += 2;
        }
        if (sbp_avg_value >= 100 && sbp_avg_value <= 119) {
          heart_condition += 0;
        }
        if (sbp_avg_value >= 81 && sbp_avg_value <= 100) {
          heart_condition += 1;
        }
        if (sbp_avg_value >= 71 && sbp_avg_value <= 80) {
          heart_condition += 2;
        }
        if (sbp_avg_value <= 70) {
          heart_condition += 3;
        }

        if (heart_condition == 0) {
          heart_state = 'Patient condition is normal';
        }
        if (heart_condition >= 1 && heart_condition <= 2) {
          heart_state = 'Patient at risk';
        }
        if (heart_condition >= 2 && heart_condition <= 4) {
          heart_state = 'Patient in critical condition';
        }
        if (heart_condition >= 5 && heart_condition <= 6) {
          heart_state = 'Patient having a heart Attack';
          _launchURL();
          FlutterRingtonePlayer.playAlarm(asAlarm: false);
          Timer(Duration(seconds: 60), () {
            FlutterRingtonePlayer.stop();
          });
        }
      }
      databaseReference.child(UniqueUser).set({
        'Condition': '$heart_state',
        'avg_bpm': '$bpm_avg_value',
        'avg_sbp': '$sbp_avg_value',
        'data_bpm': '$bpm',
        'data_time': '$time'
      });
      avg_sbp = 0;
      avg_bpm = 0;
  }

  void refresh_page() {
    setState(() {
      bpm_avg_value = bpm_avg_value;
      sbp_avg_value = sbp_avg_value;
      heart_state = heart_state;
    });
  }
  void chart() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => Chart(bpm, time, data_len),
            fullscreenDialog: true));
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(widget.email);
    name = stringValue;
    readdata(name);
  }

  _launchURL() async {
    // Replace 12345678 with your tel. no.
    android_intent.Intent()
      ..setAction(android_action.Action.ACTION_CALL)
      ..setData(Uri(scheme: "tel", path: "12345678"))
      ..startActivity().catchError((e) => print(e));
  }


}
