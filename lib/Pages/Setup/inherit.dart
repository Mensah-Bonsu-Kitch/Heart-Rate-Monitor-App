import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  void didChangeDependencies() {
    InheritedState.of(this.context).loadContext(this.context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
          child: Text('Navigate with InheritedWidget'),
          onPressed: () {
            InheritedState.of(context).navigateAway();
          }),
    );
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