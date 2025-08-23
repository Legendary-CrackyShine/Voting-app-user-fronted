class Contestant {
  final String id;
  final String name;
  final String level;
  final String title;
  final String code;
  final List<String> images;
  final List<String> objective;
  final String desc;
  Contestant({
    required this.id,
    required this.name,
    required this.level,
    required this.title,
    required this.code,
    required this.images,
    required this.objective,
    required this.desc,
  });

  factory Contestant.fromJson(Map<String, dynamic> json) {
    return Contestant(
      id: json["_id"],
      name: json["name"],
      level: json["level"],
      title: json["title"],
      code: json["code"],
      images: List<String>.from(json["images"] ?? []),
      objective: List<String>.from(json["objective"] ?? []),
      desc: json["desc"],
    );
  }
}
