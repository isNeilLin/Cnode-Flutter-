import 'package:flutter/material.dart';
import 'package:cnode/common/post.dart';
import 'package:cnode/common/commet.dart';
import 'package:cnode/common/helper.dart';
import 'package:cnode/common/api.dart';
import 'package:cnode/components/TabLabel.dart';
import 'package:cnode/pages/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cnode/pages/Profile.dart';

class PostDetail extends StatefulWidget {
  String id;
  PostDetail({Key key,this.id}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return new PostState();
  }
}

class PostState extends State<PostDetail> {
  SharedPreferences prefs;

  initState(){
    super.initState();
    initPrefs();
  }

  initPrefs() async{
    final p = await SharedPreferences.getInstance();
    setState(() {
      prefs = p;
    });
  }

  Future _future() async{
    final result = await getPost(widget.id);
    return result;
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

  toProfile(context, user){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return new Profile(user:user);
    }));
  }

  buildPost(Post post, commets){
    final create = fromNow(post.create).split(' ')[0];
    return new ListView(
      children: <Widget>[
        new Container(
          margin: EdgeInsets.only(left: 8.0,right:8.0, top: 16.0,),
          child: new Text(
            post.title, style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
          ),
        ),
        new Container(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          child: new Row(
            children: <Widget>[
              new GestureDetector(
                child: new Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(post.avatar)),
                      borderRadius: BorderRadius.circular(100.0)
                  ),
                ),
                onTap: (){
                  toProfile(context,{
                    'id': post.id,
                    'name': post.author,
                    'avatar': post.avatar
                  });
                },
              ),
              new Expanded(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new TabLabel(tab: post.tab,top: post.top,good: post.good,),
                        new Container(
                          margin: EdgeInsets.only(left: 8.0),
                          child: new Text(post.author,style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    new Container(
                      margin: EdgeInsets.only(top: 8.0),
                      child: new Text('创建于: ${create} · ${post.visit}次浏览',style: TextStyle(fontSize: 13.0),),
                    )
                  ],
                )
              ),
              new Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: new Like(post: post,prefs: prefs,),
              )
            ],
          ),
        ),
        new Container(
          margin: EdgeInsets.only(left: 12.0,right: 12.0,bottom: 12.0),
          alignment: Alignment.centerLeft,
          child: new MarkdownBody(
            data:post.content.replaceAll('//static', 'http://static'),
          ),
        ),
        new Divider(height: 1.0,),
        new Container(
          padding: EdgeInsets.only(left: 16.0,top: 16.0,bottom: 16.0),
          color: Color.fromRGBO(245, 245, 245, 1.0),
          child: new Text('${commets.length}条回复',style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold
          ),),
        ),
        new Divider(height: 1.0,),
        new ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: commets.length,
            itemBuilder: (context, index){
              final Comment comment = commets[index];
              final create = fromNow(comment.create).split(' ')[0];
              return new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new GestureDetector(
                          child: new Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.0),
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage(comment.avatar)),
                                borderRadius: BorderRadius.circular(100.0)
                            ),
                          ),
                          onTap: (){
                            toProfile(context,{
                              'id': comment.id,
                              'name': comment.author,
                              'avatar': comment.avatar
                            });
                          },
                        ),
                        new Expanded(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.only(left: 8.0),
                                  child: new Text(comment.author,),
                                ),
                                new Container(
                                    margin: EdgeInsets.only(top: 8.0),
                                    child: new Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        new Text('${index+1}楼',style: TextStyle(fontSize: 14.0,color: Theme.of(context).accentColor),),
                                        new Text(' · ${create}',style: TextStyle(fontSize: 14.0),),
                                      ],
                                    )
                                )
                              ],
                            )
                        ),
                        new Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          child: new Row(
                            children: <Widget>[
                              new GestureDetector(
                                child: comment.isUped ? new Icon(Icons.thumb_up,) : new Icon(Icons.thumb_up,color: Colors.grey,),
                                onTap: (){
                                  final username = prefs.getString('username');
                                  if(username!=null && username.isNotEmpty){
                                    print('like');
                                  }else{
                                    login();
                                  }
                                },
                              ),
                              new Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                child: new Text(comment.ups.length.toString()),
                              ),
                              new GestureDetector(
                                child: new Icon(Icons.reply,size: 32.0,color: Colors.grey,),
                                onTap: (){
                                  final username = prefs.getString('username');
                                  if(username!=null && username.isNotEmpty){
                                    print('reply');
                                  }else{
                                    login();
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 16.0,left: 16.0,bottom: 10.0),
                    child: new MarkdownBody(
                        data:comment.content.replaceAll('//static', 'http://static')
                    ),
                  ),
                  new Divider(height: 1.0,),
                ],
              );
            }
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        title: new Text('话题'),
        actions: <Widget>[
          new GestureDetector(
            child: new Icon(Icons.share),
            onTap: (){
              print('share');
            },
          )
        ],
      ),
      body: new FutureBuilder(
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            final Post post = snapshot.data['post'];
            final List commets = snapshot.data['commets'].toList();
            return new Container(
              child: buildPost(post, commets),
            );
          }
          return new Center(
            child: new CircularProgressIndicator(),
          );
        },
        future: _future(),
      ),
    );
  }
}

class Like extends StatefulWidget{
  Post post;
  SharedPreferences prefs;
  Like({Key key,this.post, this.prefs}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LikeState();
  }
}

class LikeState extends State<Like> {
  bool like = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      like = widget.post.isCollect;
    });
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

  changeLike(){
    final username = widget.prefs.getString('username');
    if(username!=null && username.isNotEmpty){
      setState(() {
        like = !like;
      });
    }else{
      login();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(like){
      return new GestureDetector(
        child: new Icon(Icons.favorite, color: Colors.red,),
        onTap: changeLike,
      );
    }
    return new GestureDetector(
      child: new Icon(Icons.favorite_border),
      onTap: changeLike,
    );
  }
}