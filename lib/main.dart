import 'package:flutter/material.dart';
import 'package:cnode/pages/App.dart';
import 'package:cnode/pages/Splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  Future _future () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 3));
    return prefs;
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      builder: (context, snapshot){
        if(snapshot.hasData){
          final prefs = snapshot.data;
          return new ThemeChanger(prefs: prefs);
        }
        return new Splash();
      },
      future: _future(),
    );
  }
}


