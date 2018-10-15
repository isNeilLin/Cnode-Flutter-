import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cnode/common/api.dart';
import 'package:cnode/common/GlobalNotification.dart';


class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginState();
  }
}

class LoginState extends State<Login> {
  SharedPreferences prefs;
  final TextEditingController controller = new TextEditingController();

  initState(){
    initPrefs();
    super.initState();
  }

  initPrefs() async{
    prefs = await SharedPreferences.getInstance();
  }

  dispose(){
    controller.dispose();
    super.dispose();
  }

  login() async{
    final mytoken = 'cd10e5eb-2720-4314-a5fd-69b99ed8ec70';
    final res = await loginWithAccessToken(mytoken);
    if(res['success']){
      prefs.setString('username', res['loginname']);
      prefs.setString('avatar', res['avatar_url']);
      prefs.setString('id', res['id']);
      prefs.setString('accesstoken', controller.text);
      Navigator.pop(context);
    }else{
      print(res['error_msg']);
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: new Text(res['error_msg']),
            actions: <Widget>[
              FlatButton(
                child: new Text('确定'),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Stack(
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Expanded(
                  child: new Container(
                    height: 160.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: new AssetImage('assets/cover.jpeg'),
                        alignment: Alignment.topCenter
                      ),
                      color: Color.fromRGBO(233, 233, 233, 1.0),
                    ),
                  ),
              )
            ],
          ),
          new SafeArea(
            child: new Container(
              margin: EdgeInsets.only(top: 8.0,left: 8.0),
              child: new Row(
                children: <Widget>[
                  new GestureDetector(
                    child: Icon(Icons.arrow_back,color: Colors.white,),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                  new Container(
                    margin: EdgeInsets.only(left: 24.0),
                    child: new Text('登录',style: TextStyle(color: Colors.white,fontSize: 18.0),),
                  )
                ],
              ),
            )
          ),
          new Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(top: 160.0, left: 16.0,right: 16.0, bottom: 24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0)
                ),
                padding: EdgeInsets.symmetric(vertical: 32.0,horizontal: 20.0),
                child: new Column(
                  children: <Widget>[
                    new Theme(
                        data: new ThemeData(
                          primaryColor: Color.fromRGBO(139, 196, 0, 1.0),
                        ),
                        child: new TextField(
                          autofocus: true,
                          style: TextStyle(fontSize: 14.0,height: 1.2,color: Colors.black),
                          controller: controller,
                          cursorColor: Theme.of(context).accentColor,
                          decoration: InputDecoration(
                              hintText: 'Access Token:',
                          ),
                        )
                    ),
                    new Row(
                      children: <Widget>[
                        new Expanded(child: new Container(
                          margin: EdgeInsets.symmetric(vertical: 16.0),
                          child: new RaisedButton(
                            onPressed: login,
                            color: Color.fromRGBO(139, 196, 0, 1.0),
                            child: new Text('登录', style: TextStyle(color: Colors.white),),
                          ),
                        ))
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Icon(Icons.crop_free),
                            new Container(
                              child: new Text('扫码登录'),
                              margin: EdgeInsets.only(left: 8.0),
                            )
                          ],
                        ),
                        new Row(
                          children: <Widget>[
                            new Icon(Icons.code),
                            new Container(
                              child: new Text('GitHub登录'),
                              margin: EdgeInsets.only(left: 8.0),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              new GestureDetector(
                child: new Text('如何获取 Access Token ？',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).accentColor,
                  ),
                ),
                onTap: (){
                  showDialog(context: context, builder: (context){
                    return new AlertDialog(
                      contentPadding: EdgeInsets.only(top: 16.0,left: 20.0,right: 20.0),
                      content: new Text('在CNode社区网站端登录你的账户，然后在右上角找到"设置"按钮，点击进去后将页面滑动到最底部来查看你的 Access Token。',),
                      actions: <Widget>[
                        new FlatButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: new Text('确定'))
                      ],
                    );
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
