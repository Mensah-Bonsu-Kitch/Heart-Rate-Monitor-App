import 'package:flutter/material.dart';
import 'package:heart/Pages/Setup/DoctorsPage.dart';

class Mypatients extends StatefulWidget {
  List patient_name;
  Mypatients(this.patient_name);

  @override
  _MypatientsState createState() => _MypatientsState();
}

class _MypatientsState extends State<Mypatients> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My patients'),
          backgroundColor: Color(0xffe46b10),
        ),
        body: Container(
        child: Form(
            child: ListView.builder(
                itemCount: widget.patient_name.length,
                itemBuilder: (context, index) {
                  return
                    ListTile(
                      title: Text(
                        ('$index: ' + 'View ' + widget.patient_name[index]+"'s" + ' heart rate data'),
                          style: TextStyle(color: Color(0xffe46b10), fontSize: 20)
                      ),
                      onTap: () {
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                                AddPatient(widget.patient_name[index]),
                            fullscreenDialog: true));
                      }
                  );
                }
            )
        ),
        ),
      );

  }
}



