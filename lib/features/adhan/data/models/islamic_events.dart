class IslamicEvent {
  final int id;
  final String title;
  final String body;
  final DateTime date;

  IslamicEvent({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
  });

  factory IslamicEvent.fromJson(Map<String, dynamic> json) {
    return IslamicEvent(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      date: DateTime(
        DateTime.parse(json['date']).year,
        DateTime.parse(json['date']).month,
        DateTime.parse(json['date']).day,
        json['hour'],
        json['minute'],
      ),
    );
  }
}
