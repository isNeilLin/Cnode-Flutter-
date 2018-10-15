import 'package:cnode/common/helper.dart';

class Comment {
  final String author;
  final String avatar;
  final String id;
  final String content;
  final String create;
  final bool isUped;
  final String replyId;
  final List ups;

  Comment({
    this.author,
    this.avatar,
    this.id,
    this.content,
    this.create,
    this.isUped,
    this.replyId,
    this.ups
  });

  factory Comment.fromJSON(json){
    final create = sliceDateString(json['create_at']);
    final url = json['author']['avatar_url'];
    final avatar = url.startsWith('//') ? 'http:$url' : url;
    return Comment(
      author: json['author']['loginname'],
      avatar: avatar,
      id: json['id'],
      content: json['content'],
      create: create,
      isUped: json['is_uped'],
      replyId: json['reply_id'],
      ups: json['ups'].toList()
    );
  }
}