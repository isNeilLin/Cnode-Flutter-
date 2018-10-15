import 'package:cnode/common/helper.dart';

class Post {
  final String id;
  final String author;
  final String authorId;
  final String content;
  final String create;
  final bool good;
  final String lastReply;
  final int reply;
  final String tab;
  final String title;
  final bool top;
  final int visit;
  final String avatar;
  final bool isCollect;

  Post({
    this.create,
    this.author,
    this.visit,
    this.reply,
    this.title,
    this.content,
    this.tab,
    this.authorId,
    this.avatar,
    this.good,
    this.id,
    this.isCollect,
    this.lastReply,
    this.top
  });

  factory Post.fromJSON(json){
    final create = sliceDateString(json['create_at']);
    final lastReply = sliceDateString(json['last_reply_at']);
    final url = json['author']['avatar_url'];
    final avatar = url.startsWith('//') ? 'http:$url' : url;
    return Post(
      id: json['id'],
      author: json['author']['loginname'],
      authorId: json['author_id'],
      content: json['content'],
      create: create,
      good: json['good'],
      lastReply: lastReply,
      reply: json['reply_count'],
      tab: json['tab'],
      title: json['title'],
      top: json['top'],
      visit: json['visit_count'],
      avatar: avatar,
      isCollect: json['is_collect'] == null ? false : json['is_collect']
    );
  }
}


