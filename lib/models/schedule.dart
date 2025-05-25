class Schedule {
  final String id;
  final String date;
  final String name;
  final String content;
  final String timeBegin;
  final String timeEnd;

  Schedule({
    required this.id,
    required this.date,
    required this.name,
    required this.content,
    required this.timeBegin,
    required this.timeEnd,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      date: json['date'],
      name: json['name'],
      content: json['content'],
      timeBegin: json['timeBegin'],
      timeEnd: json['timeEnd'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'name': name,
      'content': content,
      'timeBegin': timeBegin,
      'timeEnd': timeEnd,
    };
  }
}