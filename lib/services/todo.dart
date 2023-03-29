class Todo {
  Todo({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.time,
    required this.notifications,
    required this.finished,
    required this.day,
    required this.userId,
    required this.colorId,
  });
  late final String id;
  late final String createdAt;
  late final String title;
  late final String time;
  late final bool notifications;
  late final bool finished;
  late final String day;
  late final String userId;
  late final int colorId;

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    title = json['title'];
    time = json['time'];
    notifications = json['notifications'];
    finished = json['finished'];
    day = json['day'];
    userId = json['userId'];
    colorId = json['colorId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created_at'] = createdAt;
    _data['title'] = title;
    _data['time'] = time;
    _data['notifications'] = notifications;
    _data['finished'] = finished;
    _data['day'] = day;
    _data['userId'] = userId;
    _data['colorId'] = colorId;
    return _data;
  }
}
