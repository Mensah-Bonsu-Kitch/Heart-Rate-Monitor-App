import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:heart/Pages/Setup/MyPatients.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Patient extends StatefulWidget {
  final String email;
  Patient(this.email);

  @override
  _PatientState createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  @override
  void initState() {
    get_existing_users();
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _patientAdded(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Patient added Successfully"),
      content: Text("Click ok to continue..."),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _patientNotFound(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Patient username incorrect"),
      content: Text("Please verify patient username, Click ok to continue"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _usernameunique() {
    return Form(
      key: _formKey,
      child: TextFormField(
        validator: (input) {
          if (input.isEmpty) {
            return 'Enter a name (All fields marked with "*" are required)';
          }
          return null;
        },
        onSaved: (input) => username = input,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: new BorderSide(
              ),
            ),
            icon: Icon(Icons.person),
            labelText: 'Username*'
        ),
      ),
    );
  }

  Widget _viewpatients() {
    return InkWell(
      onTap: () {
        view_patients();
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'View patients',
          style: TextStyle(fontSize: 20, color: Color(0xfff7892b)),
        ),
      ),
    );
  }

  Widget _addPatient() {
    return InkWell(
      onTap: () {
        add_patient();
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'Add a Patient',
          style: TextStyle(fontSize: 20, color: Color(0xfff7892b)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Add patients'),
        backgroundColor: Color(0xffe46b10),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          margin: const EdgeInsets.all(10.0),
          child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        _usernameunique(),
                        SizedBox(
                          height: 20,
                        ),
                        _addPatient(),
                        SizedBox(
                          height: 20,
                        ),
                        _divider(),
                        SizedBox(
                          height: 20,
                        ),
                        _viewpatients(),
                      ]
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }

  List myusers = [];
  List database_users = [];
  String username;
  int total_num_users = 0;

  void add_patient() async {
    final databaseReferences = await FirebaseDatabase.instance.reference();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      database_users.clear();
      databaseReferences.once().then((DataSnapshot snapshot) {
        Map <dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          database_users.add(key);
        });

        if (database_users.contains(username)){
          myusers.add(username);
          total_num_users += 1;
          add(total_num_users, username, total_num_users);
          print(myusers);
          _patientAdded(context);
        }else{
          //generate invalid username
          _patientNotFound(context);
        }

        for (int i = 0; i < myusers.length; i++){
          add(i, myusers[i], myusers.length);
        }

      });
    }
  }

  void view_patients() async {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Mypatients(myusers)));
    }

    add(key, name, total_users) async {
    int userkey = key;
    String _username = name;
    int number_of_users = total_users;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(userkey.toString(),_username);
      prefs.setString('Num_of_users', number_of_users.toString());
    }

  get_existing_users() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Number_of_users = prefs.getString('Num_of_users');

    if (Number_of_users != null) {
      var myInt = int.parse(Number_of_users);
      assert(myInt is int);
      total_num_users = myInt;
      for (int i = 0; i < myInt; i++){
        String stringValue = prefs.getString((i+1).toString());
        if (stringValue != null) {
          myusers.add(stringValue);
        }
        else{
          //show widget of no users
        }
      }
    }
  }
}
