import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'chart.dart';

class AddPatient extends StatefulWidget {
  final String patient_name;
  AddPatient(this.patient_name);

  @override
  _AddPatientState createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  @override
  void didChangeDependencies() {
    InheritedState.of(this.context).loadContext(this.context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    patientData();
    alarmController();
  }

  Widget _avg_bpm() {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Text('Average Heart Rate',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xffe46b10), fontSize: 18)),
    );
  }

  Widget _avg_sbp() {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Text('Average SBP',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xffe46b10), fontSize: 18)),
    );
  }

  Widget _heart_condition() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      decoration:
          BoxDecoration(color: Color(0xffe46b10), shape: BoxShape.rectangle),
      child: Text(
        '$heart_condition',
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
      decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xffe46b10),
            width: 4,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('$avg_bpm',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 50))
        ],
      ),
    );
  }

  Widget _display_sbp() {
    return Container(
      width: 150.0,
      height: 150.0,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xffe46b10),
            width: 4,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('$avg_sbp',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 50))
        ],
      ),
    );
  }

  Widget readData() {
    return RaisedButton(
      onPressed: () {
        patientData();
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

  Widget callAmbulance() {
    return RaisedButton(
      onPressed: () {
        ambulance();
      },
      child: Text("Call ambulance",
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
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Container(
              child: Row(children: <Widget>[
            Expanded(
              child: _avg_bpm(),
            ),
            Expanded(
              child: _avg_sbp(),
            ),
          ])),
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
            children: <Widget>[readData(), callAmbulance()],
          )),
        ],
      )),
    );
  }

  List db_data = [];
  String avg_sbp, avg_bpm;
  List bpm, time;
  List int_bpm = [];
  String heart_condition;

  void alarmController() {
    final subscription = FirebaseDatabase.instance
        .reference()
        .child(widget.patient_name)
        .child('Alarm');
    final condition = FirebaseDatabase.instance
        .reference()
        .child(widget.patient_name)
        .child('Condition');
    final subscriptions =
        FirebaseDatabase.instance.reference().child(widget.patient_name);
    condition.onValue.listen((event) {
      subscriptions.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        if (values['Condition'] == 'Patient having a heart attack') {
          FlutterRingtonePlayer.playAlarm(asAlarm: false);
          InheritedState.of(context).navigateAway();
        }
      });
    });
    subscription.onValue.listen((event) {
      subscriptions.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        if (values['Alarm'] == '1') {
          FlutterRingtonePlayer.stop();
          values.forEach((key, values) {
            db_data.add(values);
          });
          avg_sbp = db_data[0];
          bpm = db_data[1].split(',');
          bpm.removeLast();
          bpm.removeAt(0);
          heart_condition = db_data[2];
          avg_bpm = db_data[3];
          time = db_data[4].split(',');
          time.removeLast();
          time.removeAt(0);
          subscriptions.set({
            'Alarm': '0',
            'avg_bpm': '$avg_bpm',
            'avg_sbp': '$avg_sbp',
            'data_bpm': '$bpm',
            'data_time': '$time'
          });
        }
      });
    });
  }

  Future<void> patientData() async {
    // making this both a Future and async method
    final databaseReferences =
        await FirebaseDatabase.instance.reference().child(widget.patient_name);
    databaseReferences.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        db_data.add(values); // omitting "[keys]" from the OPs approach
      });
      avg_sbp = db_data[0];
      bpm = db_data[1].split(',');
      bpm.removeLast();
      bpm.removeAt(0);
      int data_len = bpm.length;
      for (int i = 0; i < data_len; i++) {
        int_bpm.add(double.parse(bpm[i]));
      }
      heart_condition = db_data[2];
      if (heart_condition == 'Patient having a heart Attack') {
        FlutterRingtonePlayer.playAlarm(asAlarm: false);
      }
      avg_bpm = db_data[3];
      time = db_data[4].split(',');
      time.removeLast();
      time.removeAt(0);
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => Chart(int_bpm, time, data_len),
              fullscreenDialog: true));
    });
  }

  void ambulance() async {
    final databaseReferences =
        await FirebaseDatabase.instance.reference().child(widget.patient_name);
    final databaseReference = await FirebaseDatabase.instance.reference();
    FlutterRingtonePlayer.stop();
    databaseReferences.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        db_data.add(values); // omitting "[keys]" from the OPs approach
      });
      avg_sbp = db_data[0];
      bpm = db_data[1].split(',');
      bpm.removeLast();
      bpm.removeAt(0);
      heart_condition = db_data[2];
      avg_bpm = db_data[3];
      time = db_data[4].split(',');
      time.removeLast();
      time.removeAt(0);
      databaseReference.child(widget.patient_name).set({
        'Alarm': '1',
        'Condition': '$heart_condition',
        'avg_bpm': '$avg_bpm',
        'avg_sbp': '$avg_sbp',
        'data_bpm': '$bpm',
        'data_time': '$time'
      });
    });
  }
}

class NewView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('New view from inherited widget'),),
        body: Center(
            child: Text('Test view')
        )
    );
  }
}

class InheritedState extends InheritedWidget {
  InheritedState({Key key, Widget child}) : super(key: key, child: child);
  BuildContext _buildContext;

  void loadContext(BuildContext buildContext){
    _buildContext = buildContext;
  }

  void navigateAway(){
    Navigator.of(_buildContext).push(MaterialPageRoute(
        builder: (context){
          return NewView();
        })
    );
  }

  static InheritedState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedState>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
