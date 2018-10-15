import 'package:url_launcher/url_launcher.dart';

sliceDateString(datetime){
  return datetime.replaceAll(
      new RegExp(r'T|Z'), ' '
  ).substring(0,19);
}

String fromNow(String datetime) {
  final _now = new DateTime.now();
  final _datetime = DateTime.parse(datetime);
  final _diff = _now.difference(_datetime);
  if (_diff.inMinutes <60) {
    return '${_diff.inMinutes}分钟之前';
  } else if (_diff.inHours < 24) {
    return '${_diff.inHours}小时以前';
  } else if(_diff.inDays < 7){
    return '${_diff.inDays}天以前';
  } else if(_diff.inDays < 28){
    final week = _diff.inDays / 7;
    return '${week.floor()}周以前';
  } else {
    return datetime;
  }
}

const Map<String, String> tagDict = {
  "dev": "开发",
  "ask": "问答",
  "share": "分享",
  "job": "招聘"
};

String tagLabel(String tag) {
  return tagDict[tag];
}

openInBrowser(String url) async{
  if(await canLaunch(url)){
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

sendMail() async{
  final address = 'neil3397@gmail.com';
  final email = 'mailto:${address}?subject=CNode-Issue';
  if(await canLaunch(email)){
    await launch(email);
  }
}