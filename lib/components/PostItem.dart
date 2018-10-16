import 'package:flutter/material.dart';
import 'package:cnode/common/post.dart';
import 'package:cnode/common/helper.dart';
import 'package:cnode/components/TabLabel.dart';
import 'package:cnode/pages/Post.dart';
import 'package:cnode/pages/Profile.dart';

class PostItem extends StatelessWidget {
  final Post post;
  PostItem({Key key, this.post}):super(key:key);

  toDetail(BuildContext context,Post post){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return new PostDetail(id: post.id);
    }));
  }

  toProfile(BuildContext context, tag){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return new Profile(user:{
        'id': post.id,
        'name': post.author,
        'avatar': post.avatar,
      },tag: tag,);
    }));
  }

  @override
  Widget build(BuildContext context) {
    final time = DateTime.now().toIso8601String();
    return new GestureDetector(
      onTap: (){
        toDetail(context,post);
      },
      child: new Container(
        margin: EdgeInsets.only(bottom: 16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color:Color.fromRGBO(0, 0, 0, 0.2), offset: Offset(1.0, 0.0),blurRadius: 1.0)]
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new TabLabel(tab: post.tab,top: post.top,good: post.good,),
                new Row(
                  children: <Widget>[
                    new Text(
                      '${post.reply}',
                      style: TextStyle(color: Color.fromRGBO(139, 196, 0, 1.0)),
                    ),
                    new Text(
                      ' / ${post.visit} · ',
                      style: TextStyle(color: Color.fromRGBO(131, 131, 131, 1.0)),
                    ),
                    new Text(
                      fromNow(post.lastReply),
                      style: TextStyle(color: Color.fromRGBO(131, 131, 131, 1.0)),
                    )
                  ],
                )
              ],
            ),
            new Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: new Text(post.title,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
            ),
            new Container(
              margin: EdgeInsets.only(bottom: 12.0),
              child: new Text(
                post.content.substring(0,post.content.length>180 ? 180 : post.content.length),
              ),
            ),
            new Divider(),
            new GestureDetector(
              child: new Container(
                margin: EdgeInsets.only(top: 12.0),
                child: new Row(
                  children: <Widget>[
                    new Hero(tag: post.author+time, child: new Container(
                      width: 32.0,
                      height: 32.0,
                      margin: EdgeInsets.only(right: 6.0),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        image: new DecorationImage(image: new NetworkImage(post.avatar)),
                      )
                    )),
                    new Text(
                      post.author,
                      style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500),
                    ),
                    new Expanded(
                        child: new Text(
                          '创建于: ${post.create}',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Color.fromRGBO(131, 131, 131, 1.0),
                          ),
                        )
                    ),
                  ],
                ),
              ),
              onTap: (){
                toProfile(context,post.author+time);
              },
            )
          ],
        ),
      ),
    );
  }
}