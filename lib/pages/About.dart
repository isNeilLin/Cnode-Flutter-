import 'package:flutter/material.dart';
import 'package:cnode/common/helper.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new NestedScrollView(
          headerSliverBuilder: (context, isScroll){
            return [
              new SliverAppBar(
                expandedHeight: 210.0,
                title: new Text('关于'),
                pinned: true,
                leading: GestureDetector(
                  child: Icon(Icons.arrow_back),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: new Container(
                    height: 230.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/cover1.jpeg'),fit: BoxFit.cover)
                    ),
                  ),
                ),
              )
            ];
          },
          body: new Column(
            children: <Widget>[
              new ListTile(
                title: new Text('当前版本'),
                subtitle: new Text('1.0.0'),
              ),
              new Divider(height: 1.0,),
              new GestureDetector(
                child: new ListTile(
                  title: new Text('项目开源主页'),
                  subtitle: new Text('https://github.com/isNeilLin/Cnode-Flutter-'),
                ),
                onTap: (){
                  openInBrowser('https://github.com/isNeilLin/Cnode-Flutter-');
                },
              ),
              new Divider(height: 1.0,),
              new GestureDetector(
                child: new ListTile(
                  title: new Text('关于CNode社区'),
                  subtitle: new Text('https://cnodejs.org/about'),
                ),
                onTap: (){
                  openInBrowser('https://cnodejs.org/about');
                },
              ),
              new Divider(height: 1.0,),
              new GestureDetector(
                child: new ListTile(
                  title: new Text('关于作者'),
                  subtitle: new Text('https://juejin.im/user/59cbc2c06fb9a00a5143acf2'),
                ),
                onTap: (){
                  openInBrowser('https://juejin.im/user/59cbc2c06fb9a00a5143acf2');
                },
              ),
              new Divider(height: 1.0,),
              new GestureDetector(
                child: new ListTile(
                  title: new Text('意见反馈'),
                  subtitle: new Text('向作者发送电子邮件'),
                ),
                onTap: (){
                  sendMail();
                },
              ),
              new Divider(height: 1.0,),
              new Expanded(child: new Container()),
              new Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: new Text('Copyright © 2018 isNeilLin'),
              )
            ],
          )
      ),
    );
  }
}