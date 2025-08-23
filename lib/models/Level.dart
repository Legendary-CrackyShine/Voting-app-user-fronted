import 'package:voting_client/models/Contestant.dart';

class Level {
  String? id;
  String? name;
  List<Contestant> contestant;

  Level({required this.id, required this.name, required this.contestant});

  factory Level.fromJson(Map<dynamic, dynamic> json) {
    List contestants = json["contestants"] as List;
    List<Contestant> contestant = contestants
        .map((sb) => Contestant.fromJson(sb))
        .toList();
    return Level(id: json["_id"], name: json["name"], contestant: contestant);
  }
}
