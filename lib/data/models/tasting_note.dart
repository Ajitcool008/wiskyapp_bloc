class TastingNote {
  final String id;
  final String bottleId;
  final String author;
  final DateTime date;
  final String nose;
  final String palate;
  final String finish;
  final List<String> attachments;

  TastingNote({
    required this.id,
    required this.bottleId,
    required this.author,
    required this.date,
    required this.nose,
    required this.palate,
    required this.finish,
    required this.attachments,
  });

  factory TastingNote.fromJson(Map<String, dynamic> json) {
    return TastingNote(
      id: json['id'] as String,
      bottleId: json['bottle_id'] as String,
      author: json['author'] as String,
      date: DateTime.parse(json['date'] as String),
      nose: json['nose'] as String,
      palate: json['palate'] as String,
      finish: json['finish'] as String,
      attachments:
          (json['attachments'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bottle_id': bottleId,
      'author': author,
      'date': date.toIso8601String(),
      'nose': nose,
      'palate': palate,
      'finish': finish,
      'attachments': attachments,
    };
  }
}
