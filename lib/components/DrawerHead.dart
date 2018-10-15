import 'package:flutter/material.dart';
import 'package:cnode/common/GlobalNotification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cnode/pages/Login.dart';
import 'package:cnode/pages/Profile.dart';

class DrawerHead extends StatefulWidget {
  SharedPreferences prefs;
  DrawerHead({Key key, this.prefs}):super(key:key);

  @override
  DrawerHeadState createState() => new DrawerHeadState();
}

class DrawerHeadState extends State<DrawerHead> {

  bool nightMode;
  String username;
  String avatar;

  @override
  void initState() {
    setState(() {
      nightMode = widget.prefs.getBool('nightMode') == null ? false : widget.prefs.getBool('nightMode');
      username = widget.prefs.getString('username') == null ? '' : widget.prefs.getString('username');
      avatar = widget.prefs.getString('avatar') == null ? '' : widget.prefs.getString('avatar');
    });
    super.initState();
  }

  login(){
    Navigator.pop(context);
    Navigator.push(context, new MaterialPageRoute(builder: (context){
      return new Login();
    }));
  }

  buildUser(){
    if(username.isEmpty){
      return new Column(
        children: <Widget>[
          new GestureDetector(
            child: new Container(
              width: 72.0,
              height: 72.0,
              margin: EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(72.0),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/avatar.png'))
              ),
            ),
            onTap: login,
          ),
          new Text('点击头像登录',style: TextStyle(color: Colors.white),)
        ],
      );
    }else{
      return new Column(
        children: <Widget>[
          new GestureDetector(
            child: new Container(
              width: 72.0,
              height: 72.0,
              margin: EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(72.0),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(avatar))
              ),
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return new Profile(user:{
                  'id': widget.prefs.getString('id'),
                  'name': widget.prefs.getString('username'),
                  'avatar': widget.prefs.getString('avatar')
                });
              }));
            },
          ),
          new Text(username,style: TextStyle(color: Colors.white),)
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: new Container(
          padding: EdgeInsets.only(top: 32.0,left: 32.0,right: 32.0),
          height: 160.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/cover.jpeg'))
          ),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildUser(),
              new GestureDetector(
                child: nightMode ? Icon(Icons.brightness_3,color: Colors.white,)
                    : Icon(Icons.wb_sunny,color: Colors.white,),
                onTap: (){
                  new GlobalNotification(nightMode: !nightMode).dispatch(context);
                  widget.prefs.setBool('nightMode', !nightMode);
                  setState(() {
                    nightMode = !nightMode;
                  });
                },
              )
            ],
          ),
        )
    );
  }
}