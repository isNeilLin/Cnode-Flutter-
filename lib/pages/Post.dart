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
import 'package:share/share.dart';

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
  bool _visible;
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  Post post;
  int order = 0;
  initState(){
    super.initState();
    setState(() {
      _visible = true;
    });
    initPrefs();
  }

  initPrefs() async{
    final p = await SharedPreferences.getInstance();
    setState(() {
      prefs = p;
    });
  }

  Future _future() async{
    final token = prefs.getString('accesstoken') == null ? '' : prefs.getString('accesstoken');
    final result = await getPost(widget.id,token);
    setState(() {
      post = result['post'];
    });
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

  authorLabel(bool isAuthor){
    if(isAuthor){
      return new Container(
        margin: EdgeInsets.only(left: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 2.0),
        decoration: BoxDecoration(
            color: Color.fromRGBO(139, 196, 0, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(4.0))
        ),
        child: new Text('作者', style: TextStyle(color: Colors.white,fontSize: 13.0),),
      );
    }
    return new Container();
  }

  title(){
    insert('\n# ', (startText){
      return TextSelection(baseOffset: startText.length+3, extentOffset: startText.length+3);
    });
  }

  bold(){
    insert('**string**', (startText){
      return TextSelection(baseOffset: startText.length+2, extentOffset: startText.length+8);
    });
  }

  italic(){
    insert('*string*', (startText){
      return TextSelection(baseOffset: startText.length+1, extentOffset: startText.length+7);
    });
  }

  quote(){
    insert('\n> ', (startText){
      return TextSelection(baseOffset: startText.length+3, extentOffset: startText.length+3);
    });
  }

  ulist(){
    insert('\n- ', (startText){
      return TextSelection(baseOffset: startText.length+3, extentOffset: startText.length+3);
    });
  }
  olist(){
    setState(() {
      order = order+1;
    });
    insert('\n${order}. ', (startText){
      final len = (order).toString().length;
      return TextSelection(baseOffset: startText.length+2+len, extentOffset: startText.length+2+len);
    });
  }

  code(){
    insert('\n```\n\n``` ', (startText){
      return TextSelection(baseOffset: startText.length+5, extentOffset: startText.length+5);
    });
  }
  link(){
    final text = '[title](url)';
    insert(text, (startText){
      return TextSelection(baseOffset: startText.length+text.length-4, extentOffset: startText.length+text.length-1);
    });
  }
  image(){
    final text = '![Image](src)';
    insert(text, (startText){
      return TextSelection(baseOffset: startText.length+text.length-4, extentOffset: startText.length+text.length-1);
    });
  }

  insert(String text, cb){
    if(_focusNode.hasFocus){
      final startText = _controller.text.substring(0, _controller.selection.base.offset);
      final endText = _controller.text.substring(_controller.selection.base.offset);
      var str = startText + text + endText;
      TextSelection selection = cb(startText);
      _controller.value = TextEditingValue(
          text: str,
          selection: selection
      );
    }
  }
  showReply(BuildContext context, [String replyId]){
    setState(() {
      _visible = false;
    });
    showBottomSheet(context: context,builder: (context){
      return new Container(
        height: 200.0,
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new IconButton(
                    icon: Icon(Icons.close),
                    onPressed: (){
                      Navigator.pop(context);
                      setState(() {
                        _visible = true;
                      });
                    }
                ),
                new Expanded(
                  child: new SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: new Row(
                        children: <Widget>[
                          new IconButton(
                              icon: new Icon(Icons.title,color: Colors.black54,),
                              onPressed: title),
                          new IconButton(
                              icon: new Icon(Icons.format_bold,color: Colors.black54,),
                              onPressed: bold),
                          new IconButton(
                              icon: new Icon(Icons.format_italic,color: Colors.black54),
                              onPressed: italic),
                          new IconButton(
                              icon: new Icon(Icons.format_quote,color: Colors.black54),
                              onPressed: quote),
                          new IconButton(
                              icon: new Icon(Icons.format_list_bulleted,color: Colors.black54),
                              onPressed: ulist),
                          new IconButton(
                              icon: new Icon(Icons.format_list_numbered,color: Colors.black54),
                              onPressed: olist),
                          new IconButton(
                              icon: new Icon(Icons.code,color: Colors.black54),
                              onPressed: code),
                          new IconButton(
                              icon: new Icon(Icons.link,color: Colors.black54),
                              onPressed: link),
                          new IconButton(
                              icon: new Icon(Icons.image,color: Colors.black54),
                              onPressed: image),
                        ],
                      ),
                    )
                ),
                new GestureDetector(
                  child: new Container(
                    width: 48.0,
                    height: 48.0,
                    padding: EdgeInsets.all(8.0),
                    child: new Icon(Icons.send),
                  ),
                  onTap: (){
                    print('send');
                    sendReply(replyId);
                  }
                )
              ],
            ),
            new Divider(height: 1.0,),
            new Expanded(
              child: new TextField(
                controller: _controller,
                focusNode: _focusNode,
                cursorColor: Theme.of(context).accentColor,
                maxLengthEnforced: false,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black87,
                    height: 1.2
                ),
                maxLines: 5000,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 16.0),
                    hintText: '说点什么吧',
                    border: InputBorder.none
                ),
              )
            )
          ],
        ),
      );
    });
  }

  share(){
    final url = 'https://cnodejs.org/topic/${post.id}';
    Share.share(url);
  }


  sendReply([String replyId]) async{
    String content = _controller.text;
    final token = prefs.getString('accesstoken');
    if(prefs.getBool('openTrail')!=null&&prefs.getBool('openTrail')){
      content = '${content}\n\n${prefs.getString('trail')}';
    }
    if(replyId!=null){
      await replyTopic(token, post.id, content,replyId);
    }else{
      await replyTopic(token, post.id, content);
    }
    Navigator.pop(context);
    setState(() {
      _visible = true;
    });
  }

  toProfile(context, user,tag){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return new Profile(user:user,tag: tag,);
    }));
  }

  buildPost(Post post, commets){
    final create = fromNow(post.create).split(' ')[0];
    final now = DateTime.now().toIso8601String();
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
              new Hero(
                tag: post.author+now,
                child: new GestureDetector(
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
                      },post.author+now);
                    },
                  )
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
          color: Theme.of(context).cardColor,
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
              final now = DateTime.now().toIso8601String();
              return new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Hero(
                          child: new GestureDetector(
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
                                'avatar': comment.avatar,
                              },comment.author+now);
                            },
                          ),
                          tag: comment.author+now,
                        ),
                        new Expanded(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    new Container(
                                      margin: EdgeInsets.only(left: 8.0),
                                      child: new Text(comment.author,),
                                    ),
                                    authorLabel(comment.author==post.author)
                                  ],
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
                              Up(commet: comment,username: prefs.getString('username'),token: prefs.getString('accesstoken')),
                              new GestureDetector(
                                child: new Icon(Icons.reply,size: 32.0,color: Colors.grey,),
                                onTap: (){
                                  final username = prefs.getString('username');
                                  if(username!=null && username.isNotEmpty){
                                    showReply(context, comment.id);
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
          new Container(
            child: new GestureDetector(
              child: new Icon(Icons.share),
              onTap: (){
                share();
              },
            ),
            margin: EdgeInsets.only(right: 10.0),
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
      floatingActionButton: new Builder(builder: (context){
        return new AnimatedOpacity(
          // If the Widget should be visible, animate to 1.0 (fully visible). If
          // the Widget should be hidden, animate to 0.0 (invisible).
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          // The green box needs to be the child of the AnimatedOpacity
          child: new FloatingActionButton(
            onPressed: (){
              final username = prefs.getString('username');
              if(username!=null && username.isNotEmpty){
                showReply(context);
              }else{
                login();
              }
            },
            child: new Icon(
              Icons.reply,
              color: Color.fromRGBO(236, 236, 236, 1.0),
            ),
          ),
        );
      })
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
  bool like;

  @override
  void initState() {
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
      collect(!like);
      setState(() {
        like = !like;
      });
    }else{
      login();
    }
  }

  collect(bool isCollect) async{
    if(isCollect){
      collectTopic(widget.post.id, widget.prefs.getString('accesstoken'));
    }else{
      deCollectTopic(widget.post.id, widget.prefs.getString('accesstoken'));
    }
  }

  @override
  Widget build(BuildContext context) {
    if(like){
      return new GestureDetector(
        child: new Icon(Icons.favorite, color: Theme.of(context).accentColor,),
        onTap: changeLike,
      );
    }
    return new GestureDetector(
      child: new Icon(Icons.favorite_border),
      onTap: changeLike,
    );
  }
}

class Up extends StatefulWidget {
  Comment commet;
  String username;
  String token;
  Up({Key key, this.commet, this.username, this.token}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return UpState();
  }
}

class UpState extends State<Up>{
  bool like;
  int length;

  initState(){
    super.initState();
    setState(() {
      like = widget.commet.isUped;
      length = widget.commet.ups.length;
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

  buildCommet(){
    return new Row(
      children: <Widget>[
        new GestureDetector(
          child: like ? new Icon(Icons.thumb_up,color: Theme.of(context).accentColor,) : new Icon(Icons.thumb_up,color: Colors.grey,),
          onTap: (){
            final username = widget.username;
            if(username!=null && username.isNotEmpty){
              up();
            }else{
              login();
            }
          },
        ),
        new Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          child: new Text(length.toString()),
        ),
      ],
    );
  }

  up()async{
    final res = await upReply(widget.token,widget.commet.id);
    if(res['success']){
      if(!like){
        setState(() {
          like = !like;
          length = length+1;
        });
      }else{
        setState(() {
          like = !like;
          length = length - 1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return buildCommet();
  }
}