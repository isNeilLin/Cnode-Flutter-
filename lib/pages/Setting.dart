import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cnode/common/GlobalNotification.dart';
import 'package:cnode/pages/SetTrail.dart';

class Setting extends StatefulWidget {
  SharedPreferences prefs;
  Setting({Key key,this.prefs}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return SettingState();
  }
}

class SettingState extends State<Setting> {
  bool isOpenPush = true;
  bool isNightMode = false;
  bool isSaveTopic = true;
  bool isOpenTrail = false;

  initState(){
    super.initState();
    setState(() {
      isNightMode =  widget.prefs.getBool('nightMode') == null ? false : widget.prefs.getBool('nightMode');
    });
  }

  changeTrail(bool openTrail){
    widget.prefs.setBool('openTrail', openTrail);
    setState(() {
      isOpenTrail = openTrail;
    });
  }

  changeSaveTopic(bool saveTopic){
    widget.prefs.setBool('saveTopic', saveTopic);
    setState(() {
      isSaveTopic = saveTopic;
    });
  }

  changeNightMode(bool nightMode){
    widget.prefs.setBool('nightMode', nightMode);
    GlobalNotification(nightMode: nightMode).dispatch(context);
    setState(() {
      isNightMode = nightMode;
    });
  }

  changePush(bool openPush){
    setState(() {
      isOpenPush = openPush;
    });
  }

  setTrail(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return new SetTrail(prefs: widget.prefs);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('设置'),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: new Column(
        children: <Widget>[
          new SwitchListTile(
              value: isOpenPush,
              onChanged: changePush,
              title: new Text('接收消息推送'),
              subtitle: new Text('开不开都一样'),
          ),
          new Divider(height: 1.0,),
          new SwitchListTile(
            value: isNightMode,
            onChanged: changeNightMode,
            title: new Text('夜间模式'),
          ),
          new Divider(height: 1.0,),
          new SwitchListTile(
            value: isSaveTopic,
            onChanged: changeSaveTopic,
            title: new Text('保存草稿'),
            subtitle: new Text('没有发布的话题会被保存'),
          ),
          new Divider(height: 1.0,),
          new SwitchListTile(
            value: isOpenTrail,
            onChanged: changeTrail,
            title: new Text('话题小尾巴'),
            subtitle: new Text('开启后可以自定义'),
          ),
          new Divider(height: 1.0,),
          new GestureDetector(
            child: new ListTile(
              title: new Text('设置小尾巴'),
              enabled: isOpenTrail,
            ),
            onTap: (){
              if(isOpenTrail){
                setTrail();
              }
            },
          ),
          new Divider(height: 1.0,),
        ],
      ),
    );
  }
}