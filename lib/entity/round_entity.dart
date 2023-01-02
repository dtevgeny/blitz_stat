const String tableRounds = 'round';

class RoundFields {
  static final List<String> values = [
    id,
    gid,
    gameId,
    dtCreate,
    dtUpdate,
    dtUpload
  ];

  static const String id = "_id";
  static const String gid = "gid";
  static const String gameId = "gameId";
  static const String dtCreate = "dtCreate";
  static const String dtUpdate = "dtUpdate";
  static const String dtUpload = "dtUpload";
}

class RoundEntity {
  int? id;
  String? gid;
  int? gameId;
  DateTime? dtCreate = DateTime.now();
  DateTime? dtUpdate;
  DateTime? dtUpload;

  RoundEntity({
    this.id,
    this.gid,
    this.gameId,
    this.dtCreate,
    this.dtUpdate,
    this.dtUpload,
  });

  RoundEntity copy({
    int? id,
    String? gid,
    int? gameId,
    DateTime? dtCreate,
    DateTime? dtUpdate,
    DateTime? dtUpload,
  }) =>
      RoundEntity(
        id: id ?? this.id,
        gid: gid ?? this.gid,
        gameId: gameId ?? this.gameId,
        dtCreate: dtCreate ?? this.dtCreate,
        dtUpdate: dtUpdate ?? this.dtUpdate,
        dtUpload: dtUpload ?? this.dtUpload,
      );

  static RoundEntity fromJson(Map<String, Object?> json) => RoundEntity(
    id: json[RoundFields.id] as int?,
    gid: json[RoundFields.gid] as String?,
    gameId: json[RoundFields.gameId] as int?,
    dtCreate: DateTime.parse(json[RoundFields.dtCreate] as String),
    dtUpdate: DateTime.parse(json[RoundFields.dtUpdate] as String),
    dtUpload: json[RoundFields.dtCreate] == null
        ? DateTime.parse(json[RoundFields.dtCreate] as String)
        : null,
  );

  Map<String, Object?> toJson() => {
    RoundFields.id: id,
    RoundFields.gid: gid,
    RoundFields.gameId: gameId,
    RoundFields.dtCreate: dtCreate == null
        ? DateTime.now().toIso8601String()
        : dtCreate!.toIso8601String(),
    RoundFields.dtUpdate: dtUpdate == null
        ? DateTime.now().toIso8601String()
        : dtUpdate!.toIso8601String(),
    RoundFields.dtUpload: dtUpload?.toIso8601String(),
  };
}