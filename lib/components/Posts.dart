import 'package:flutter/material.dart';
import 'package:cnode/common/api.dart' as API;
import 'package:cnode/common/post.dart';
import 'package:cnode/components/PostItem.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Posts extends StatefulWidget {
  final String tab;

  Posts({Key key, this.tab}):super(key:key);

  PostsState createState()=>new PostsState();
}

class PostsState extends State<Posts> {
  RefreshController _refreshController;
  int page = 1;
  List results = [];
  bool upto;

  @override
  initState(){
    super.initState();
    _refreshController = new RefreshController();
  }

  @override
  didUpdateWidget(oldWidget){
    setState(() {
      results = [];
      page = 1;
    });
  }

  Future _future () async{
    final newResults =  await API.getPosts(page,widget.tab);
    if(upto != null){
      _refreshController.sendBack(upto, RefreshStatus.idle);
    }
    results = new List.from(results)..addAll(newResults);
    return results;
  }

  Widget buildFooter(context,mode){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [new RefreshProgressIndicator()],
    );
  }

  Widget buildHeader(context,mode){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [new RefreshProgressIndicator()],
    );
  }

  _refresh(bool up){
    if(up){
      setState(() {
        page = 1;
        upto = up;
      });
    }else{
      setState(() {
        page= page + 1;
        upto = up;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      builder: (context, snapshot){
        final list = snapshot.data;
        if(snapshot.hasData&&list.isNotEmpty){
          return new SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              footerBuilder: buildFooter,
              headerBuilder: buildHeader,
              child: ListView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final Post post = list[index];
                  return new PostItem(post: post);
                },
              ),
              onRefresh: _refresh
          );
        }
        return new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [new RefreshProgressIndicator()],
        );
      },
      future: _future(),
    );
  }
}