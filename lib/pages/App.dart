import 'package:flutter/material.dart';
import 'package:cnode/theme.dart' as CustomTheme;
import 'package:cnode/components/DrawerHead.dart';
import 'package:cnode/components/Posts.dart';
import 'package:cnode/common/GlobalNotification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cnode/pages/Login.dart';
import 'package:cnode/pages/About.dart';
import 'package:cnode/pages/Setting.dart';
import 'package:cnode/pages/Publish.dart';

class ThemeChanger extends StatefulWidget {
  SharedPreferences prefs;
  ThemeChanger({Key key, this.prefs}):super(key:key);

  ThemeChangerState createState()=>new ThemeChangerState();
}

class ThemeChangerState extends State<ThemeChanger>{
  bool nightMode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      nightMode = widget.prefs.getBool('nightMode') == null ? false : widget.prefs.getBool('nightMode');
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: new MaterialApp(
        title: 'CNode中文社区',
        theme: nightMode ? CustomTheme.darkTheme : CustomTheme.lightTheme,
        home: new MyHomePage(title: 'CNode社区', prefs: widget.prefs),
      ),
      onNotification: (GlobalNotification n){
        setState(() {
          nightMode = n.nightMode;
        });
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  SharedPreferences prefs;
  MyHomePage({Key key, this.title, this.prefs}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String tab = 'all';
  String username = '';

  @override
  void initState() {
    super.initState();
    widget.prefs.clear();
    setState(() {
      tab = 'all';
      username = widget.prefs.getString('username') == null ? '' : widget.prefs.getString('username');
    });
  }

  void _publish() {
    final user = widget.prefs.getString('username');
    if(user==null || user.isEmpty){
      login();
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return new Publish(prefs: widget.prefs,);
      }));
    }
  }

  void _toNotification(){
    Navigator.pop(context);
    final user = widget.prefs.getString('username');
    if(user==null || user.isEmpty){
      login();
    }else{
      print('message');
    }
  }

  void _toAbout(){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return new About();
    }));
  }

  void _toSetting(){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return new Setting(prefs: widget.prefs,);
    }));
  }

  void login(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: new Text('当前操作需要登录，是否登录?'),
            actions: <Widget>[
              new FlatButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: new Text('取消',style: TextStyle(color: Color.fromRGBO(131, 131, 131, 1.0)),)),
              new FlatButton(onPressed: (){
                Navigator.of(context).pop();
                Navigator.push(context, new MaterialPageRoute(builder: (context){
                  return new Login();
                }));
              }, child: new Text('登录',style: TextStyle(color: Colors.blueAccent))),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      drawer: new Drawer(
          elevation: 1.0,
          child: new MediaQuery.removePadding(
            context: context,
            child: new ListView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                new DrawerHead(prefs: widget.prefs,),
                new ListTileTheme(
                  selectedColor: Theme.of(context).accentColor,
                  child: new ListTile(
                    selected: tab == 'all',
                    leading: new Icon(Icons.forum),
                    title: new Text('全部'),
                    onTap: (){
                      setState(() {
                        tab = 'all';
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                new ListTileTheme(
                  selectedColor: Theme.of(context).accentColor,
                  child: new ListTile(
                    selected: tab == 'good',
                    leading: new Icon(Icons.thumb_up),
                    title: new Text('精华'),
                    onTap: (){
                      setState(() {
                        tab = 'good';
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                new ListTileTheme(
                  selectedColor: Theme.of(context).accentColor,
                  child: new ListTile(
                    selected: tab == 'share',
                    leading: new Icon(Icons.share),
                    title: new Text('分享'),
                    onTap: (){
                      setState(() {
                        tab = 'share';
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                new ListTileTheme(
                  selectedColor: Theme.of(context).accentColor,
                  child: new ListTile(
                    selected: tab == 'ask',
                    leading: new Icon(Icons.face),
                    title: new Text('问答'),
                    onTap: (){
                      setState(() {
                        tab = 'ask';
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                new ListTileTheme(
                  selectedColor: Theme.of(context).accentColor,
                  child: new ListTile(
                    selected: tab == 'job',
                    leading: new Icon(Icons.folder),
                    title: new Text('招聘'),
                    onTap: (){
                      setState(() {
                        tab = 'job';
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                new Divider(),
                new ListTile(
                  leading: new Icon(Icons.notifications),
                  title: new Text('消息'),
                  onTap: _toNotification,
                ),
                new ListTile(
                  leading: new Icon(Icons.settings),
                  title: new Text('设置'),
                  onTap: _toSetting,
                ),
                new ListTile(
                  leading: new Icon(Icons.info),
                  title: new Text('关于'),
                  onTap: _toAbout,
                ),
              ],
            ),
            removeTop: true,
          )
      ),
      body: new Posts(tab: tab,),
      floatingActionButton: new FloatingActionButton(
        onPressed: _publish,
        tooltip: '发布',
        child: new Icon(
          Icons.edit,
          color: Color.fromRGBO(236, 236, 236, 1.0),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}