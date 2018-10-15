import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cnode/common/post.dart';
import 'package:cnode/common/commet.dart';
import 'package:cnode/common/user.dart';

const String BASE_URL = 'https://cnodejs.org/api/v1/';

createPost(String token, String title, String tab, String content) async{
  final response = await http.post('${BASE_URL}/topics',
      body: {
        'accesstoken': token,
        'title': title,
        'tab': tab,
        'content': content
      }
  );
  return json.decode(response.body);
}

updatePost(String token, String topicId, String title, String tab, String content) async{
  final response = await http.post('${BASE_URL}/topics/update',
      body: {
        'accesstoken': token,
        'topic_id': topicId,
        'title': title,
        'tab': tab,
        'content': content
      }
  );
  return json.decode(response.body);
}

getPosts(int page,[String tab='all']) async{
  final response = await http.get('${BASE_URL}/topics?page=${page}&limit=20&tab=${tab}&mdrender=false');
  final body = json.decode(response.body);
  final list = body['data'].toList();
  return list.map((json)=>Post.fromJSON(json));
}

getPost(String id) async{
  final response = await http.get('${BASE_URL}/topic/$id?mdrender=false');
  final body = json.decode(response.body);
  final list = body['data']['replies'].toList();
  final post = Post.fromJSON(body['data']);
  final commets = list.map((json)=>Comment.fromJSON(json));
  return {
    'post': post,
    'commets': commets,
  };
}

getUser(String username) async{
  final response = await http.get('${BASE_URL}/user/${username}');
  final body = json.decode(response.body);
  return User.fromJSON(body['data']);
}

getUserCollects(String username) async {
  final response = await http.get('${BASE_URL}/topic_collect/${username}');
  final body = json.decode(response.body);
  final list = body['data'].toList();
  return list.map((json)=>Topic.fromJson(json)).toList();
}

loginWithAccessToken(String token) async{
  final response = await http.post('${BASE_URL}/accesstoken',
    body: {
      'accesstoken': token
    }
  );
  return json.decode(response.body);
}

collectTopic(String topicId, String token) async{
  final response = await http.post('${BASE_URL}/topic_collect/collect',
    body: {
      'accesstoken': token,
      'topic_id': topicId
    }
  );
  final body = json.decode(response.body);
  return body['success'];
}

deCollectTopic(String topicId, String token) async{
  final response = await http.post('${BASE_URL}/topic_collect/de_collect',
      body: {
        'accesstoken': token,
        'topic_id': topicId
      }
  );
  final body = json.decode(response.body);
  return body['success'];
}

replyTopic(String token, String topicId, String content, [String replyId = '']) async{
  final response = await http.post('${BASE_URL}/topic/${topicId}/replies',
      body: {
        'accesstoken': token,
        'content': content,
        'reply_id': replyId,
      }
  );
  return json.decode(response.body);
}

upReply(String token, String replyId) async{
  final response = await http.post('${BASE_URL}/reply/${replyId}/ups',
      body: {
        'accesstoken': token,
      }
  );
  return json.decode(response.body);
}

unReadMessageCount(String token) async{
  final response = await http.get('${BASE_URL}/message/count?accesstoken=${token}');
  final body = json.decode(response.body);
  if(body['success']){
    return body['data'];
  }
  return 0;
}

allMessages(String token) async{
  final response = await http.get('${BASE_URL}/messages?accesstoken=${token}&mdrender=false');
  final body = json.decode(response.body);
  if(body['success']){
    return body['data'];
  }
  return 0;
}

markAllMessage(String token) async{
  final response = await http.post('${BASE_URL}/message/mark_all',
      body: {
        'accesstoken': token,
      }
  );
  final body = json.decode(response.body);
  return body['success'];
}

markOneMessage(String token, String messageId) async {
  final response = await http.post('${BASE_URL}/message/mark_one/${messageId}',
      body: {
        'accesstoken': token,
      }
  );
  final body = json.decode(response.body);
  return body['success'];
}