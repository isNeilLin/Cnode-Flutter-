import 'package:cnode/common/helper.dart';

class User {
  final String username;
  final String avatar;
  final String githubName;
  final String create;
  final String score;
  final List recentTopics;
  final List recentReplies;

  User({
    this.username,
    this.avatar,
    this.githubName,
    this.create,
    this.score,
    this.recentTopics,
    this.recentReplies
  });

  static toTopicList(list){
    return list.map((json)=>Topic.fromJson(json)).toList();
  }

  factory User.fromJSON(json){
    final create = sliceDateString(json['create_at']);
    final url = json['avatar_url'];
    final avatar = url.startsWith('//') ? 'http:$url' : url;
    return User(
        username: json['loginname'],
        githubName: json['githubUsername'],
        avatar: avatar,
        create: create,
        score: json['score'].toString(),
        recentTopics: toTopicList(json['recent_topics']),
        recentReplies: toTopicList(json['recent_replies']),
    );
  }
}

class Topic {
  final String id;
  final String author;
  final String avatar;
  final String title;
  final String lastReply;

  Topic({
    this.id,
    this.author,
    this.avatar,
    this.title,
    this.lastReply
  });

  factory Topic.fromJson(json){
    final lastReply = sliceDateString(json['last_reply_at']);
    final url = json['author']['avatar_url'];
    final avatar = url.startsWith('//') ? 'http:$url' : url;
    return Topic(
      id: json['id'],
      author: json['author']['loginname'],
      avatar: avatar,
      title: json['title'],
      lastReply: lastReply
    );
  }
}

