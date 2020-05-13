import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';


class PatientRegister extends StatefulWidget {
  @override
  _PatientRegisterState createState() => _PatientRegisterState();
}

class _PatientRegisterState extends State<PatientRegister> {
  String _email, _password, _username;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();

  final databaseReference = FirebaseDatabase.instance.reference();

  Widget _names() {
    return Form(
      key: _formKey2,
      child: TextFormField(
        validator: (input) {
          if (input.isEmpty) {
            return 'Enter a name';
          }
          return null;
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: new BorderSide(
              ),
            ),
            icon: Icon(Icons.person),
            labelText: 'First name'
        ),
      ),
    );
  }

  Widget _names1() {
    return Form(
      key: _formKey3,
      child: TextFormField(
        validator: (input) {
          if (input.isEmpty) {
            return 'Enter a name';
          }
          return null;
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: new BorderSide(
              ),
            ),
            icon: Icon(Icons.person),
            labelText: 'Last Name'
        ),
      ),
    );
  }


  Widget _usernameunique() {
    return Form(
      key: _formKey4,
      child: TextFormField(
        validator: (input) {
          if (input.isEmpty) {
            return 'Enter a name (All fields marked with "*" are required)';
          }
          return null;
        },
        onSaved: (input) => _username = input,
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

  Widget _usersemail() {
    return Form(
      key: _formKey1,
      child: Column(
          children: <Widget>[
            TextFormField(
              validator: (input) {
                if (input.isEmpty) {
                  return 'Please enter an E-mail';
                }
                return null;
              },
              onSaved: (input) => _email = input,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  icon: Icon(Icons.email),
                  labelText: 'E-mail*'
              ),
            ),
          ]
      ),
    );
  }

  Widget _passwordsignup() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (input) {

              if (input.isEmpty) {
                return 'Enter a password';
              }
              return null;
            },
            onSaved: (input) => _password = input,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.deepOrangeAccent,
                  ),
                ),
                icon: Icon(Icons.lock),
                labelText: 'Password*'
            ),
            obscureText: true,
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return RaisedButton(
      onPressed: () {
        signUp();
        signUpDoc();
        username_validate();
        firstname_validate();
        lastname_validate();
      },
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.deepOrangeAccent)
      ),
      child: Text('Sign Up',
        style: TextStyle(
            color: Color(0xfff79c4f),
            fontSize: 20,
            fontWeight: FontWeight.w600),
      ),

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

  Widget _loginLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              'Sign In',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Patient - Register'),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: SingleChildScrollView(
    child: Container(
      height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.all(10.0),
          child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: Row(
                        children: <Widget>[
                          Expanded(
                            child: _names(),
                          ),
                          Expanded(
                            child: _names1(),
                          ),
                        ]
                    )
                ),
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
                        _usersemail(),
                        SizedBox(
                          height: 20,
                        ),
                        _passwordsignup(),
                        SizedBox(
                          height: 30,
                        ),
                        _submitButton(),
                        SizedBox(
                          height: 30,
                        ),
                        _divider(),
                        SizedBox(
                          height: 30,
                        ),
                        _loginLabel()
                      ]
                  ),
                ),
              ]
          ),
        ),
        ),
    );
  }
  void  firstname_validate() async {
    final formState = _formKey2.currentState;
    if(formState.validate()){
      formState.save();
    }
  }
  void  lastname_validate() async {
    final formState = _formKey3.currentState;
    if(formState.validate()){
      formState.save();
    }
  }
  void  username_validate() async {
    final formState = _formKey4.currentState;
    if(formState.validate()){
      formState.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(_email.replaceAll(new RegExp(r'[^\w\s]+'), ''), "$_username");
    }
  }

  void  signUp() async {
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try{
        AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = result.user;
        user.sendEmailVerification();
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }catch(e){
        print(e.message);
      }
    }

  }

  void  signUpDoc() async {
    final formState = _formKey1.currentState;
    if(formState.validate()){
      formState.save();
      try{
        AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = result.user;
        user.sendEmailVerification();
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }catch(e){
        print(e.message);
      }
    }
  }

}
