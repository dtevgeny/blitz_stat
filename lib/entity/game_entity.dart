const String tableGames = 'game';

class GameFields {
  static final List<String> values = [
    id,
    gid,
    status,
    dtCreate,
    dtUpdate,
    dtUpload
  ];

  static const String id = "_id";
  static const String gid = "gid";
  static const String status = "status";
  static const String dtCreate = "dtCreate";
  static const String dtUpdate = "dtUpdate";
  static const String dtUpload = "dtUpload";
}

class GameEntity {
  int? id;
  String? gid;
  int? status;
  DateTime? dtCreate = DateTime.now();
  DateTime? dtUpdate;
  DateTime? dtUpload;

  GameEntity({
    this.id,
    this.gid,
    this.status,
    this.dtCreate,
    this.dtUpdate,
    this.dtUpload,
  });

  GameEntity copy({
    int? id,
    String? gid,
    int? status,
    DateTime? dtCreate,
    DateTime? dtUpdate,
    DateTime? dtUpload,
  }) =>
      GameEntity(
        id: id ?? this.id,
        gid: gid ?? this.gid,
        status: status ?? this.status,
        dtCreate: dtCreate ?? this.dtCreate,
        dtUpdate: dtUpdate ?? this.dtUpdate,
        dtUpload: dtUpload ?? this.dtUpload,
      );

  static GameEntity fromJson(Map<String, Object?> json) => GameEntity(
        id: json[GameFields.id] as int?,
        gid: json[GameFields.gid] as String?,
        status: json[GameFields.status] as int?,
        dtCreate: DateTime.parse(json[GameFields.dtCreate] as String),
        dtUpdate: DateTime.parse(json[GameFields.dtUpdate] as String),
        dtUpload: json[GameFields.dtCreate] == null
            ? DateTime.parse(json[GameFields.dtCreate] as String)
            : null,
      );

  Map<String, Object?> toJson() => {
        GameFields.id: id,
        GameFields.gid: gid,
        GameFields.status: status,
        GameFields.dtCreate: dtCreate == null
            ? DateTime.now().toIso8601String()
            : dtCreate!.toIso8601String(),
        GameFields.dtUpdate: dtUpdate == null
            ? DateTime.now().toIso8601String()
            : dtUpdate!.toIso8601String(),
        GameFields.dtUpload: dtUpload?.toIso8601String(),
      };
}
