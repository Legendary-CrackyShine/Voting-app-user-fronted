class Vote {
  final String id, code, title;
  final int points;

  Vote({
    required this.id,
    required this.code,
    required this.title,
    required this.points,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    final c = json['contestantId'];
    final Map<String, dynamic>? contestant = (c is Map)
        ? Map<String, dynamic>.from(c)
        : null;

    return Vote(
      id: (json['_id'] ?? '').toString(),
      code: (contestant?['code'] ?? '').toString(),
      title: (contestant?['title'] ?? '').toString(),
      points: (json['points'] as num).toInt(),
    );
  }
}
