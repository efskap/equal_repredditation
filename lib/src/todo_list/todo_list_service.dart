import 'dart:async';
import 'dart:convert';
import 'post.dart';
import 'dart:html';
import '../../app_component.dart';
import 'package:angular/core.dart';
import 'package:http/browser_client.dart';

@Injectable()
class RedditService {
 String base = "https://cors-anywhere.herokuapp.com/https://www.reddit.com";
  Future<List<Post>> getPosts(String subred, DateTime start, DateTime end, int n) async {
    int from = (start.millisecondsSinceEpoch / 1000).round();
    int to = (end.millisecondsSinceEpoch / 1000).round();
    String sub = subred.isEmpty ? subred : "r/$subred";
    String url =
        "$base/$sub/search.json?q=timestamp:$from..$to&restrict_sr=true&syntax=cloudsearch&sort=top&limit=$n";
    return new Future<List<Post>>(() => HttpRequest.getString(url).then((String s) {
          Map data = JSON.decode(s);
          return data['data']['children'].map((x) => new Post.fromJson(x['data']));
        }));
  }

  Future<DateTime> getSubredditCreation(String subred) async {
    if (subred.isEmpty)
      return new DateTime(2005, DateTime.JUNE);
    String url = "$base/r/$subred/about.json";
    return new Future<DateTime>(() => HttpRequest.getString(url).then((String s) {
          Map data = JSON.decode(s);
          return new DateTime.fromMillisecondsSinceEpoch((data['data']['created_utc']*1000).round(), isUtc: true);
        }));
  }
}
