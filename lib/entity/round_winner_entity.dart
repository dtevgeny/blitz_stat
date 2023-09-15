import 'package:blitz_stat/db/database.dart';

const String tableRoundWinners = 'roundWinner';

class RoundWinnerFields {
  static final List<String> values = [
    id,
    gid,
    roundId,
    playerId,
    dtCreate,
    dtUpdate,
    dtUpload
  ];

  static const String id = "_id";
  static const String gid = "gid";
  static const String roundId = "roundId";
  static const String playerId = "playerId";
  static const String dtCreate = "dtCreate";
  static const String dtUpdate = "dtUpdate";
  static const String dtUpload = "dtUpload";
}
class RoundWinnerEntity {
  int? id;
  String? gid;
  int? roundId;
  int? playerId;
  DateTime? dtCreate = DateTime.now();
  DateTime? dtUpdate;
  DateTime? dtUpload;

  RoundWinnerEntity({
    this.id,
    this.gid,
    this.roundId,
    this.playerId,
    this.dtCreate,
    this.dtUpdate,
    this.dtUpload,
  });

  RoundWinnerEntity copy({
    int? id,
    String? gid,
    int? roundId,
    int? playerId,
    DateTime? dtCreate,
    DateTime? dtUpdate,
    DateTime? dtUpload,
  }) =>
      RoundWinnerEntity(
        id: id ?? this.id,
        gid: gid ?? this.gid,
        roundId: roundId ?? this.roundId,
        playerId: playerId ?? this.playerId,
        dtCreate: dtCreate ?? this.dtCreate,
        dtUpdate: dtUpdate ?? this.dtUpdate,
        dtUpload: dtUpload ?? this.dtUpload,
      );

  static RoundWinnerEntity fromJson(Map<String, Object?> json) => RoundWinnerEntity(
    id: json[RoundWinnerFields.id] as int?,
    gid: json[RoundWinnerFields.gid] as String?,
    roundId: json[RoundWinnerFields.roundId] as int?,
    playerId: json[RoundWinnerFields.playerId] as int?,
    dtCreate: DateTime.parse(json[RoundWinnerFields.dtCreate] as String),
    dtUpdate: DateTime.parse(json[RoundWinnerFields.dtUpdate] as String),
    dtUpload: json[RoundWinnerFields.dtCreate] == null
        ? DateTime.parse(json[RoundWinnerFields.dtCreate] as String)
        : null,
  );

  Map<String, Object?> toJson() => {
    RoundWinnerFields.id: id,
    RoundWinnerFields.gid: gid,
    RoundWinnerFields.roundId: roundId,
    RoundWinnerFields.playerId: playerId,
    RoundWinnerFields.dtCreate: dtCreate == null
        ? DateTime.now().toIso8601String()
        : dtCreate!.toIso8601String(),
    RoundWinnerFields.dtUpdate: dtUpdate == null
        ? DateTime.now().toIso8601String()
        : dtUpdate!.toIso8601String(),
    RoundWinnerFields.dtUpload: dtUpload?.toIso8601String(),
  };

  Future<RoundWinnerEntity> save() async {
    return await BlitzStatDatabase.instance.createRoundWinner(this);
  }
}
