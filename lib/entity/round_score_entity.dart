import 'package:blitz_stat/db/database.dart';

const String tableRoundScores = 'roundScore';

class RoundScoreFields {
  static final List<String> values = [
    id,
    gid,
    roundId,
    playerId,
    score,
    dtCreate,
    dtUpdate,
    dtUpload
  ];

  static const String id = "_id";
  static const String gid = "gid";
  static const String roundId = "roundId";
  static const String playerId = "playerId";
  static const String score = "score";
  static const String dtCreate = "dtCreate";
  static const String dtUpdate = "dtUpdate";
  static const String dtUpload = "dtUpload";
}
class RoundScoreEntity {
  int? id;
  String? gid;
  int? roundId;
  int? playerId;
  int? score;
  DateTime? dtCreate = DateTime.now();
  DateTime? dtUpdate;
  DateTime? dtUpload;

  RoundScoreEntity({
    this.id,
    this.gid,
    this.roundId,
    this.playerId,
    this.score,
    this.dtCreate,
    this.dtUpdate,
    this.dtUpload,
  });

  RoundScoreEntity copy({
    int? id,
    String? gid,
    int? roundId,
    int? playerId,
    int? score,
    DateTime? dtCreate,
    DateTime? dtUpdate,
    DateTime? dtUpload,
  }) =>
      RoundScoreEntity(
        id: id ?? this.id,
        gid: gid ?? this.gid,
        roundId: roundId ?? this.roundId,
        playerId: playerId ?? this.playerId,
        score: score ?? this.score,
        dtCreate: dtCreate ?? this.dtCreate,
        dtUpdate: dtUpdate ?? this.dtUpdate,
        dtUpload: dtUpload ?? this.dtUpload,
      );

  static RoundScoreEntity fromJson(Map<String, Object?> json) => RoundScoreEntity(
    id: json[RoundScoreFields.id] as int?,
    gid: json[RoundScoreFields.gid] as String?,
    roundId: json[RoundScoreFields.roundId] as int?,
    playerId: json[RoundScoreFields.playerId] as int?,
    score: json[RoundScoreFields.score] as int?,
    dtCreate: DateTime.parse(json[RoundScoreFields.dtCreate] as String),
    dtUpdate: DateTime.parse(json[RoundScoreFields.dtUpdate] as String),
    dtUpload: json[RoundScoreFields.dtCreate] == null
        ? DateTime.parse(json[RoundScoreFields.dtCreate] as String)
        : null,
  );

  Map<String, Object?> toJson() => {
    RoundScoreFields.id: id,
    RoundScoreFields.gid: gid,
    RoundScoreFields.roundId: roundId,
    RoundScoreFields.playerId: playerId,
    RoundScoreFields.score: score,
    RoundScoreFields.dtCreate: dtCreate == null
        ? DateTime.now().toIso8601String()
        : dtCreate!.toIso8601String(),
    RoundScoreFields.dtUpdate: dtUpdate == null
        ? DateTime.now().toIso8601String()
        : dtUpdate!.toIso8601String(),
    RoundScoreFields.dtUpload: dtUpload?.toIso8601String(),
  };

  Future<RoundScoreEntity> save() async {
    return await BlitzStatDatabase.instance.createRoundScore(this);
  }
}
