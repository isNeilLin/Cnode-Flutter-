import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cnode/common/api.dart';
import 'package:cnode/common/user.dart';
import 'package:qr_mobile_vision/qr_camera.dart';


class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginState();
  }
}

class LoginState extends State<Login> with SingleTickerProviderStateMixin{
  SharedPreferences prefs;
  final TextEditingController controller = new TextEditingController();
  double dy = 1.0;
  AnimationController _animationController;
  Animation<Offset> animation;

  initState(){
    initPrefs();
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 300)
    );
    animation = new Tween(
      begin: new Offset(0.0, 1.0),
      end: new Offset(0.0, 0.0),
    ).animate(new CurvedAnimation(parent: _animationController, curve: Curves.ease));
    animation.addStatusListener(listener);
    super.initState();
  }

  listener(AnimationStatus status){
    if(status==AnimationStatus.completed){
      setState(() {
        dy = animation.value.dy;
      });
      print(dy);
    }
  }

  initPrefs() async{
    prefs = await SharedPreferences.getInstance();
  }

  dispose(){
    controller.dispose();
    _animationController.dispose();
    _animationController.removeStatusListener(listener);
    super.dispose();
  }

  login() async{
//    final mytoken = 'cd10e5eb-2720-4314-a5fd-69b99ed8ec70';
    final res = await loginWithAccessToken(controller.text);
    if(res['success']){
      final User u = await getUser(res['loginname']);
      prefs.setString('username', res['loginname']);
      prefs.setString('avatar', res['avatar_url']);
      prefs.setString('id', res['id']);
      prefs.setString('accesstoken', controller.text);
      prefs.setString('score', u.score.toString());
      Navigator.pop(context);
    }else{
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

  scanQrcode()async{
    _animationController.forward();
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
                    new GestureDetector(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Icon(Icons.crop_free),
                          new Container(
                            child: new Text('扫码登录'),
                            margin: EdgeInsets.only(left: 8.0),
                          )
                        ],
                      ),
                      onTap: (){
                        scanQrcode();
                      },
                    ),
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
          ),
          new SlideTransition(
            position: animation,
            child:  new Scaffold(
              appBar: new AppBar(
                title: new Text('扫描二维码'),
                leading: GestureDetector(
                  child: Icon(Icons.arrow_back),
                  onTap: (){
                    _animationController.reverse();
                  },
                ),
              ),
              body: new Container(
                color: Color.fromRGBO(255, 255, 255, 1.0),
                child: new Center(
                  child: new SizedBox(
                    width: 300.0,
                    height: 300.0,
                    child: dy == 1.0 ? new Container() :new QrCamera(
                        qrCodeCallback: (code){
                          _animationController.reverse();
                          if(code!=null&&code.isNotEmpty){
                            controller.text = code;
                          }
                        }
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
