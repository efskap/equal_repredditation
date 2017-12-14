import 'package:intl/intl.dart';

class Post{
  String title;
  String url;
  String id;
  String permalink;
  DateTime when;
  String thumbnail_url;
  String domain;
  int num_comments;
  bool should_expand = false;
  Post.fromJson(Map json){
    id = json['id'];
    permalink= json['permalink'];
    title = json['title'];
    url = json['url'];
    domain = json['domain'];
    thumbnail_url = json['thumbnail'];
    when = new DateTime.fromMillisecondsSinceEpoch((json['created_utc']*1000).round(), isUtc: true);
    num_comments = json['num_comments'];
  }
  String datestr () =>
      new DateFormat('yyyy-MM-dd').format(when);
}