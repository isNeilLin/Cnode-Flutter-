import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Preview extends StatelessWidget {
  String content;
  Preview({Key key,this.content}):super(key:key);

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
        title: new Text('MarkDown预览')
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new MarkdownBody(
          data: content.replaceAll('//static', 'http://static'),
        ),
      ),
    );
  }
}