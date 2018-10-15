import 'package:flutter/material.dart';
import 'package:cnode/common/helper.dart';

class TabLabel extends StatelessWidget {
  final bool top;
  final bool good;
  final String tab;
  TabLabel({Key key, this.tab, this.top,this.good}):super(key:key);

  Widget buildLabel(Color color,String label){
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(4.0))
      ),
      child: new Text(label, style: TextStyle(color: Colors.white,fontSize: 13.0),),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(top){
      return buildLabel(Color.fromRGBO(139, 196, 0, 1.0),'置顶');
    }else if(good){
      return buildLabel(Color.fromRGBO(230, 126, 34, 1.0),'精华');
    }
    switch (tab){
      case 'dev':
        return buildLabel(Color.fromRGBO(231, 76, 60, 1.0), tagLabel(tab));
        break;
      case 'ask':
        return buildLabel(Color.fromRGBO(26, 188, 156, 1.0), tagLabel(tab));
        break;
      case 'job':
        return buildLabel(Color.fromRGBO(52, 152, 219, 1.0), tagLabel(tab));
        break;
      case 'share':
        return buildLabel(Color.fromRGBO(121, 176, 60, 1.0), tagLabel(tab));
        break;
    };
  }
}