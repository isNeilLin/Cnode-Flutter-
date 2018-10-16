import 'package:flutter/material.dart';
import 'package:cnode/common/api.dart';
import 'package:cnode/common/user.dart';
import 'package:cnode/common/helper.dart';
import 'package:cnode/pages/Post.dart';

class Profile extends StatefulWidget {
  final user;
  String tag;
  Profile({Key key, this.user,this.tag}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return new ProfileState();
  }
}

class ProfileState extends State<Profile> with TickerProviderStateMixin{
  TabController _controller;
  ScrollController _scrollController;
  List collects = [];
  bool isHide = false;

  @override
  void initState() {
    super.initState();
    initCollects();
    _controller = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListener);
  }

  scrollListener() {
    if(_scrollController.offset > 200.0 && !isHide){
      setState(() {
        isHide = true;
      });
    }else if(_scrollController.offset < 200.0 && isHide){
      setState(() {
        isHide = false;
      });
    };
  }

  dispose(){
    _controller.dispose();
    _scrollController.removeListener(scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<User> _future() async {
    final User user = await getUser(widget.user['name']);
    return user;
  }

  initCollects() async{
    final res = await getUserCollects(widget.user['name']);
    setState(() {
      collects = res;
    });
  }

  defaultUser(){
    return buildHeader(widget.user['avatar'],widget.user['name']);
  }
  
  realUser(User user){
    final email = user.githubName.isEmpty ? '' : '${user.githubName}@github.com';
    final create = user.create.split(' ')[0];
    return buildHeader(user.avatar,user.username,email,user.score,create, user);
  }

  buildTabView(User user){
    List recentReplies = [];
    List recentTopics = [];
    if(user!=null){
      recentReplies = user.recentReplies;
      recentTopics = user.recentTopics;
    }
    return new Column(
      children: <Widget>[
        new Container(
          color: Colors.black87,
          child: new TabBar(
              labelStyle: TextStyle(fontSize: 14.0,),
              labelPadding: EdgeInsets.only(top: isHide ? 30.0 : 10.0,bottom: 10.0),
              controller: _controller,
              tabs: [
                new Container(
                  child: new Text('最近回复'),
                ),
                new Container(
                  child: new Text('最新发布'),
                ),
                new Container(
                  child: new Text('话题收藏'),
                )
              ]
          ),
        ),
        new Expanded(child: new TabBarView(
            controller: _controller,
            children: [
              buildTpoics(recentReplies),
              buildTpoics(recentTopics),
              buildTpoics(collects),
            ]
        ))
      ],
    );
  }

  buildTpoics(List topics){
    return new ListView.builder(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index){
        final Topic topic = topics[index];
        final createAt = fromNow(topic.lastReply).split(' ')[0];
        return new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new GestureDetector(
                  child: new Container(
                    width: 46.0,
                    height: 46.0,
                    margin: EdgeInsets.all(16.0),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      image: new DecorationImage(image: new NetworkImage(topic.avatar)),
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return new Profile(user:{
                        'id': topic.id,
                        'name': topic.author,
                        'avatar': topic.avatar
                      });
                    }));
                  },
                ),
                new GestureDetector(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        width: MediaQuery.of(context).size.width - 94,
                        margin: EdgeInsets.only(bottom: 8.0),
                        child: new Text(
                          topic.title,
                          overflow:TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                        ),
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width - 94,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                              child: new Text(
                                topic.author,
                                style: TextStyle(color: Color.fromRGBO(131, 131, 131, 1.0)),
                              ),
                            ),
                            new Container(
                              child: new Text(
                                '${createAt}',
                                style: TextStyle(
                                  color: Color.fromRGBO(131, 131, 131, 1.0),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return new PostDetail(id:topic.id);
                    }));
                  },
                ),
              ],
            ),
            new Divider(height: 1.0,)
          ],
        );
      },
      itemCount: topics.length,
    );
  }
  
  buildHeader(avatar, username, [email='',score='',create='',user=null]){
    return NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled){
          return [
            SliverAppBar(
              expandedHeight: 210.0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: new Column(
                  children: <Widget>[
                    new Container(
                      height: 230.0,
                      padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 10.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: new AssetImage('assets/cover1.jpeg'),
                            alignment: Alignment.topCenter
                        ),
                        color: Color.fromRGBO(233, 233, 233, 1.0),
                      ),
                      child: new SafeArea(child: new Stack(
                        children: <Widget>[
                          new Container(
                            child: new GestureDetector(
                              child: new Icon(Icons.arrow_back, color: Colors.white,),
                              onTap: (){
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          new Column(
                            children: <Widget>[
                              new Hero(
                                  tag: widget.tag,
                                  child: new Container(
                                    width: 90.0,
                                    height: 90.0,
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: new NetworkImage(avatar),
                                          alignment: Alignment.topCenter
                                      ),
                                      borderRadius: BorderRadius.circular(100.0),
                                      color: Color.fromRGBO(233, 233, 233, 1.0),
                                    ),
                                  )
                              ),
                              new Container(
                                child: new Text(username,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18.0, color: Colors.white),),
                              ),
                              new Container(
                                margin: EdgeInsets.only(top: 10.0,bottom: 20.0),
                                child: new Text(email,style: TextStyle(color: Colors.white54,decoration: TextDecoration.underline),),
                              ),
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Container(
                                    child: new Text(create.isEmpty?'':'注册时间:$create',style: TextStyle(color: Colors.white,)),
                                  ),
                                  new Container(
                                    child: new Text(score.isEmpty?'':'积分：$score',style: TextStyle(color: Theme.of(context).accentColor)),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      )),
                    ),
                  ],
                ),
//                title: new Container(
//                  margin: EdgeInsets.only(bottom: innerBoxIsScrolled ? 0.0 : 40.0),
//                  child: new Text(username,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.0, color: Colors.white),),
//                ),
//                centerTitle: true,
              ),
//              pinned: true,
//              leading: new Container(
//                child: new GestureDetector(
//                  child: new Icon(Icons.arrow_back, color: Colors.white,),
//                  onTap: (){
//                    Navigator.pop(context);
//                  },
//                ),
//              ),
            ),
          ];
        },
        body: buildTabView(user)
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new FutureBuilder(
        builder: (context, snapshot){
          if(snapshot.hasData){
            final User user = snapshot.data;
            return realUser(user);
          }
          return defaultUser();
        },
        future: _future(),
      ),
    );
  }
}