const String tablePlayers = 'player';

class PlayerFields {
  static final List<String> values = [
    id,
    firstname,
    lastname,
    nickname,
    isFriend,
    dtCreate,
  ];

  static const String id = '_id';
  static const String firstname = 'firstname';
  static const String lastname = 'lastname';
  static const String nickname = 'nickname';
  static const String isFriend = 'isFriend';
  static const String dtCreate = 'dtCreate';
  static const String dtUpdate = 'dtUpdate';
}

class PlayerEntity {
  int? id;
  String? firstname;
  String? lastname;
  String? nickname;
  int? isFriend;
  DateTime? dtCreate = DateTime.now();
  DateTime? dtUpdate;

  PlayerEntity({
    this.id,
    this.firstname,
    this.lastname,
    this.nickname,
    this.isFriend,
    this.dtCreate,
    this.dtUpdate,
  });

  PlayerEntity copy({
    int? id,
    String? firstname,
    String? lastname,
    String? nickname,
    int? isFriend,
    DateTime? dtCreate,
    DateTime? dtUpdate,
  }) =>
      PlayerEntity(
        id: id ?? this.id,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        nickname: nickname ?? this.nickname,
        isFriend: isFriend ?? this.isFriend,
        dtCreate: dtCreate ?? this.dtCreate,
        dtUpdate: dtUpdate ?? this.dtUpdate,
      );

  static PlayerEntity fromJson(Map<String, Object?> json) => PlayerEntity(
        id: json[PlayerFields.id] as int?,
        firstname: json[PlayerFields.firstname] as String,
        lastname: json[PlayerFields.lastname] as String?,
        nickname: json[PlayerFields.nickname] as String?,
        isFriend: json[PlayerFields.isFriend] as int?,
        dtCreate: DateTime.parse(json[PlayerFields.dtCreate] as String),
        dtUpdate: json[PlayerFields.dtCreate] == null
            ? DateTime.parse(json[PlayerFields.dtCreate] as String)
            : null,
      );

  Map<String, Object?> toJson() => {
        PlayerFields.id: id,
        PlayerFields.firstname: firstname,
        PlayerFields.lastname: lastname,
        PlayerFields.nickname: nickname,
        PlayerFields.isFriend: isFriend,
        PlayerFields.dtCreate: dtCreate == null
            ? DateTime.now().toIso8601String()
            : dtCreate!.toIso8601String(),
        PlayerFields.dtUpdate: dtUpdate?.toIso8601String(),
      };
}
