import 'dart:async';

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'post.dart';

import 'todo_list_service.dart';

@Component(
  selector: 'todo-list',
  styleUrls: const ['todo_list_component.css'],
  templateUrl: 'todo_list_component.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
  providers: const [RedditService],
)
class TodoListComponent implements OnInit {
  final RedditService todoListService;

  List<Post> items = [];
  String subredditName = 'fffffffuuuuuuuuuuuu';
  String interval = "120";
  bool running = false;
  String limit = "8";
  bool expand = false;
  TodoListComponent(this.todoListService);

  @override
  Future<Null> ngOnInit() async {
//    items = await todoListService.getTodoList();
  }

  start() async {
    if(running)
      return;
    items.clear();

    running = true;
    await for (Post p in postStream(
        subredditName, new Duration(days: int.parse(interval)), int.parse(limit))) {
      items.add(p);
    }
    running = false;
  }

  Stream<Post> postStream(
      String subreddit, Duration dt, int postsPerInterval) async* {
    DateTime start = (await todoListService.getSubredditCreation(subreddit));
    DateTime cur = start;
    while (running && cur.isBefore(new DateTime.now())) {
      try {
        for (Post p in await todoListService.getPosts(
            subreddit, cur, cur.add(dt), postsPerInterval))
          yield p;
        cur = cur.add(dt);
      }
      catch(e){
        print(e.toString());
        continue;
      }
    }
  }
   hideMe(image){
    image.parentNode.style.display = 'none';
  }


  void open(Post item) {
    window.open("https://www.reddit.com" + item.permalink, '_blank');
  }

}
