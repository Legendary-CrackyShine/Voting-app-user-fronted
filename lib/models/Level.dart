import 'package:voting_client/models/Contestant.dart';

class Level {
  String? id;
  String? name;
  List<Contestant> contestant;
  List<String> boardIds;

  Level({
    required this.id,
    required this.name,
    required this.contestant,
    required this.boardIds,
  });

  factory Level.fromJson(Map<dynamic, dynamic> json) {
    List contestants = json["contestants"] as List;
    List<Contestant> contestant = contestants
        .map((sb) => Contestant.fromJson(sb))
        .toList();
    List boards = json["boards"] as List? ?? [];
    List<String> boardIds = boards.map((b) => b["_id"].toString()).toList();
    return Level(
      id: json["_id"],
      name: json["name"],
      contestant: contestant,
      boardIds: boardIds,
    );
  }
}
