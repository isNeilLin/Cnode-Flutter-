import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetTrail extends StatelessWidget {
  SharedPreferences prefs;
  final defaultText = '来自[CNode-Flutter](https://github.com/isNeilLin/Cnode-Flutter-)';
  TextEditingController _controller = TextEditingController(text: '来自[CNode-Flutter](https://github.com/isNeilLin/Cnode-Flutter-)');

  SetTrail({Key key, this.prefs}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text('设置小尾巴'),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: (){
            final trail = _controller.text;
            prefs.setString('trail', trail);
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          new GestureDetector(
            child: new Container(
              margin: EdgeInsets.only(top: 20.0),
              child: new Text('默认尾巴'),
            ),
            onTap: (){
              _controller.text = defaultText;
            },
          )
        ],
      ),
      body: new Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: new TextField(
          controller: _controller,
          maxLines: 100,
          style: Theme.of(context).textTheme.title,
          cursorColor: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}