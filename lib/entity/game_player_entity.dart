const String tableGamePlayers = 'gamePlayer';

class GamePlayerFields {
  static final List<String> values = [
    id,
    gid,
    gameId,
    playerId,
    dtCreate,
    dtUpdate,
    dtUpload
  ];

  static const String id = "_id";
  static const String gid = "gid";
  static const String gameId = "gameId";
  static const String playerId = "playerId";
  static const String dtCreate = "dtCreate";
  static const String dtUpdate = "dtUpdate";
  static const String dtUpload = "dtUpload";
}

class GamePlayerEntity {
  int? id;
  String? gid;
  int? gameId;
  int? playerId;
  DateTime? dtCreate = DateTime.now();
  DateTime? dtUpdate = DateTime.now();
  DateTime? dtUpload;

  GamePlayerEntity({
    this.id,
    this.gid,
    this.gameId,
    this.playerId,
    this.dtCreate,
    this.dtUpdate,
    this.dtUpload,
  });

  GamePlayerEntity copy({
    int? id,
    String? gid,
    int? gameId,
    int? playerId,
    DateTime? dtCreate,
    DateTime? dtUpdate,
    DateTime? dtUpload,
  }) =>
      GamePlayerEntity(
        id: id ?? this.id,
        gid: gid ?? this.gid,
        gameId: gameId ?? this.gameId,
        playerId: playerId ?? this.playerId,
        dtCreate: dtCreate ?? this.dtCreate,
        dtUpdate: dtUpdate ?? this.dtUpdate,
        dtUpload: dtUpload ?? this.dtUpload,
      );

  static GamePlayerEntity fromJson(Map<String, Object?> json) => GamePlayerEntity(
    id: json[GamePlayerFields.id] as int?,
    gid: json[GamePlayerFields.gid] as String?,
    gameId: json[GamePlayerFields.gameId] as int?,
    playerId: json[GamePlayerFields.playerId] as int?,

    dtCreate: DateTime.parse(json[GamePlayerFields.dtCreate] as String),
    dtUpdate: DateTime.parse(json[GamePlayerFields.dtUpdate] as String),
    dtUpload: json[GamePlayerFields.dtCreate] == null
        ? DateTime.parse(json[GamePlayerFields.dtCreate] as String)
        : null,
  );

  Map<String, Object?> toJson() => {
    GamePlayerFields.id: id,
    GamePlayerFields.gid: gid,
    GamePlayerFields.gameId: gameId,
    GamePlayerFields.playerId: playerId,
    GamePlayerFields.dtCreate: dtCreate == null
        ? DateTime.now().toIso8601String()
        : dtCreate!.toIso8601String(),
    GamePlayerFields.dtUpdate: dtUpdate == null
        ? DateTime.now().toIso8601String()
        : dtUpdate!.toIso8601String(),
    GamePlayerFields.dtUpload: dtUpload?.toIso8601String(),
  };
}
