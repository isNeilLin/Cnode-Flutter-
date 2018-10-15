import 'package:flutter/material.dart';

class Publish extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PublishState();
  }
}

class PublishState extends State<Publish> {

  String tab = 'share';
  TextEditingController _controller = TextEditingController();
  TextEditingController _mdcontroller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  publish(){
    final title = _controller.text;
    print(title);
  }

  tabChange(String val){
    setState(() {
      tab = val;
    });
  }

  title(){

  }

  bold(){
    if(_focusNode.hasFocus){
//      _mdcontroller.text = 'test';
//      final sel = _mdcontroller.selection;

//      final range = new TextRange(start: sel.start, end: sel.end);
//      range.textAfter('**string**');
//      _mdcontroller.selection = new TextSelection(baseOffset: 6, extentOffset: 6);
    }
  }

  italic(){

  }

  quote(){

  }

  ulist(){

  }
  olist(){

  }

  code(){

  }
  link(){

  }
  image(){

  }
  preview(){

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        title: new Text('发布话题'),
        actions: <Widget>[
          new GestureDetector(
            child: new Icon(Icons.send),
            onTap: publish,
          )
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Container(
                child: new Text('发布到分类：',style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 16.0
                ),),
                padding: EdgeInsets.all(16.0),
              ),
              new Expanded(child:
                new Container(
                  padding: new EdgeInsets.only(right: 30.0),
                  child: new DropdownButtonHideUnderline(child: new DropdownButton(
                      isExpanded: true,
                      value: tab,
                      items: [
                        new DropdownMenuItem(
                          child: new Text('分享'),
                          value: 'share',
                        ),
                        new DropdownMenuItem(
                          child: new Text('问答'),
                          value: 'ask',
                        ),
                        new DropdownMenuItem(
                          child: new Text('招聘'),
                          value: 'job',
                        ),
                        new DropdownMenuItem(
                          child: new Text('开发'),
                          value: 'dev',
                        )
                      ],
                      onChanged: tabChange
                  )),
                )
              )
            ],
          ),
          new Divider(height: 1.0,),
          new TextField(
            controller: _controller,
            style: Theme.of(context).textTheme.title,
            cursorColor: Theme.of(context).accentColor,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 16.0),
              hintText: '标题,字数10字以上',
              border: InputBorder.none
            ),
          ),
          new Divider(height: 1.0,),
          new SingleChildScrollView(
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
                new IconButton(
                    icon: new Icon(Icons.remove_red_eye,color: Colors.black54),
                    onPressed: preview),
              ],
            ),
          ),
          new Divider(height: 1.0,),
          new Expanded(
            child: TextField(
              controller: _mdcontroller,
              focusNode: _focusNode,
              cursorColor: Theme.of(context).accentColor,
              maxLengthEnforced: false,
              style: TextStyle(
                fontSize: 20.0,
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
  }
}
