import 'dart:async';
import 'package:blitz_stat/entity/game_entity.dart';
import 'package:blitz_stat/entity/game_player_entity.dart';
import 'package:blitz_stat/entity/round_entity.dart';
import 'package:blitz_stat/entity/round_score_entity.dart';
import 'package:blitz_stat/entity/round_winner_entity.dart';
import 'package:blitz_stat/model/game_model.dart';
import 'package:blitz_stat/entity/player_entity.dart';
import 'package:blitz_stat/model/round_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BlitzStatDatabase {
  static final BlitzStatDatabase instance = BlitzStatDatabase._init();

  static Database? _database;

  BlitzStatDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('blitzStat.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    print('_createDB begin');

    const idType = 'integer primary key autoincrement';
    const textType = 'text';
    const integerType = 'integer';

    const notNull = 'not null';
    const defaultNow = 'default current_timestamp';

    await db.execute('''
      CREATE TABLE $tablePlayers (
        ${PlayerFields.id} $idType,
        ${PlayerFields.firstname} $textType $notNull,
        ${PlayerFields.lastname} $textType,
        ${PlayerFields.nickname} $textType,
        ${PlayerFields.isFriend} $integerType,
        ${PlayerFields.dtCreate} $textType $defaultNow,
        ${PlayerFields.dtUpdate} $textType
      )''');

    await db.execute('''
      CREATE TABLE $tableGames (
        ${GameFields.id} $idType,
        ${GameFields.gid} $textType,
        ${GameFields.status} $integerType,
        ${GameFields.dtCreate} $textType $defaultNow,
        ${GameFields.dtUpdate} $textType $defaultNow,
        ${GameFields.dtUpload} $textType
      )''');

    await db.execute('''
      CREATE TABLE $tableGamePlayers (
        ${GamePlayerFields.id} $idType,
        ${GamePlayerFields.gid} $textType,
        ${GamePlayerFields.gameId} $integerType,
        ${GamePlayerFields.playerId} $integerType,
        ${GamePlayerFields.dtCreate} $textType $defaultNow,
        ${GamePlayerFields.dtUpdate} $textType $defaultNow,
        ${GamePlayerFields.dtUpload} $textType
      )''');

    await db.execute('''
      CREATE TABLE $tableRounds (
        ${RoundFields.id} $idType,
        ${RoundFields.gid} $textType,
        ${RoundFields.gameId} $integerType,
        ${RoundFields.dtCreate} $textType $defaultNow,
        ${RoundFields.dtUpdate} $textType $defaultNow,
        ${RoundFields.dtUpload} $textType
      )''');

    await db.execute('''
      CREATE TABLE $tableRoundScores (
        ${RoundScoreFields.id} $idType,
        ${RoundScoreFields.gid} $textType,
        ${RoundScoreFields.roundId} $integerType,
        ${RoundScoreFields.playerId} $integerType,
        ${RoundScoreFields.score} $integerType,
        ${RoundScoreFields.dtCreate} $textType $defaultNow,
        ${RoundScoreFields.dtUpdate} $textType $defaultNow,
        ${RoundScoreFields.dtUpload} $textType
      )''');

    await db.execute('''
      CREATE TABLE $tableRoundWinners (
        ${RoundWinnerFields.id} $idType,
        ${RoundWinnerFields.gid} $textType,
        ${RoundWinnerFields.roundId} $integerType,
        ${RoundWinnerFields.playerId} $integerType,
        ${RoundWinnerFields.dtCreate} $textType $defaultNow,
        ${RoundWinnerFields.dtUpdate} $textType $defaultNow,
        ${RoundWinnerFields.dtUpload} $textType
      )''');

    print('_createDB finished');
  }

  // todo: create basic class constructor
  Future<Object> create(Object object) async {
    final db = await instance.database;
    return object;
  }

  Future<GameEntity> createGame(GameEntity game) async {
    final db = await instance.database;
    final id = await db.insert(tableGames, game.toJson());
    return game.copy(id: id);
  }

  Future<GamePlayerEntity> createGamePlayer(GamePlayerEntity player) async {
    final db = await instance.database;
    final id = await db.insert(tableGamePlayers, player.toJson());
    return player.copy(id: id);
  }

  Future<PlayerEntity> createPlayer(PlayerEntity player) async {
    final db = await instance.database;
    final id = await db.insert(tablePlayers, player.toJson());
    return player.copy(id: id);
  }

  Future<RoundEntity> createRound(RoundEntity round) async {
    final db = await instance.database;
    final id = await db.insert(tableRounds, round.toJson());
    return round.copy(id: id);
  }

  Future<RoundScoreEntity> createRoundScore(RoundScoreEntity roundScore) async {
    final db = await instance.database;
    final id = await db.insert(tableRoundScores, roundScore.toJson());
    return roundScore.copy(id: id);
  }

  Future<RoundWinnerEntity> createRoundWinner(
      RoundWinnerEntity roundWinner) async {
    final db = await instance.database;
    final id = await db.insert(tableRoundWinners, roundWinner.toJson());
    return roundWinner.copy(id: id);
  }

////////////////////////////////////////////////////////////////////////////////

  Future<GameEntity> getGameEntity(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableGames,
      columns: GameFields.values,
      where: '${GameFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return GameEntity.fromJson(maps.first);
    } else {
      throw Exception('Game with ID $id not found');
    }
  }

  Future<PlayerEntity> getPlayerEntity(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tablePlayers,
      columns: PlayerFields.values,
      where: '${PlayerFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PlayerEntity.fromJson(maps.first);
    } else {
      throw Exception('Player with ID $id not found');
    }
  }

  Future<RoundEntity> getRoundEntity(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableRounds,
      columns: RoundFields.values,
      where: '${RoundFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return RoundEntity.fromJson(maps.first);
    } else {
      throw Exception('Round with ID $id not found');
    }
  }

////////////////////////////////////////////////////////////////////////////////

  Future<List<PlayerEntity>> readAllPlayers() async {
    final db = await instance.database;
    const orderBy = '${PlayerFields.id} ASC';
    final result = await db.query(tablePlayers, orderBy: orderBy);

    return result.map((json) => PlayerEntity.fromJson(json)).toList();
  }

  Future<List<GamePlayerEntity>> listGamePlayerEntity(int gameId) async {
    final db = await instance.database;

    final result = await db.query(tableGamePlayers,
        columns: GamePlayerFields.values,
        where: '${GamePlayerFields.gameId} = ?',
        whereArgs: [gameId],
        // orderBy: '${GamePlayerFields.id} ASC'
        orderBy: '${GamePlayerFields.playerId} ASC');

    if (result.isNotEmpty) {
      return result.map((json) => GamePlayerEntity.fromJson(json)).toList();
    } else {
      throw Exception('listGamePlayerEntity with gameId $gameId not found');
    }
  }

  Future<List<RoundEntity>> listRoundEntity(int gameId) async {
    final db = await instance.database;

    final result = await db.query(tableRounds,
        columns: RoundFields.values,
        where: '${RoundFields.gameId} = ?',
        whereArgs: [gameId],
        orderBy: '${RoundFields.id} ASC');

    // if (result.isNotEmpty) {
    //   return result.map((json) => RoundEntity.fromJson(json)).toList();
    // } else {
    //   throw Exception('listRoundEntity with gameId $gameId not found');
    // }
    return result.map((json) => RoundEntity.fromJson(json)).toList();
  }

  Future<List<RoundScoreEntity>> listRoundScoreEntity(int roundId) async {
    final db = await instance.database;

    final result = await db.query(tableRoundScores,
        columns: RoundScoreFields.values,
        where: '${RoundScoreFields.roundId} = ?',
        whereArgs: [roundId],
        orderBy: '${RoundScoreFields.playerId} ASC');

    // if (result.isNotEmpty) {
    //   return result.map((json) => RoundScoreEntity.fromJson(json)).toList();
    // } else {
    //   throw Exception('listRoundEntity with roundId $roundId not found');
    // }
    return result.map((json) => RoundScoreEntity.fromJson(json)).toList();
  }

  Future<List<RoundWinnerEntity>> listRoundWinnerEntity(int roundId) async {
    final db = await instance.database;

    final result = await db.query(tableRoundWinners,
        columns: RoundWinnerFields.values,
        where: '${RoundWinnerFields.roundId} = ?',
        whereArgs: [roundId],
        orderBy: '${RoundScoreFields.playerId} ASC');

    // if (result.isNotEmpty) {
    //   return result.map((json) => RoundWinnerEntity.fromJson(json)).toList();
    // } else {
    //   throw Exception('listRoundWinnerEntity with roundId $roundId not found');
    // }
    return result.map((json) => RoundWinnerEntity.fromJson(json)).toList();
  }

////////////////////////////////////////////////////////////////////////////////

  Future<int> updatePlayer(PlayerEntity player) async {
    final db = await instance.database;

    return db.update(
      tablePlayers,
      player.toJson(),
      where: '${PlayerFields.id} = ?',
      whereArgs: [player.id],
    );
  }

  Future<int> deletePlayer(int id) async {
    final db = await instance.database;

    return await db.delete(
      tablePlayers,
      where: '${PlayerFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

  Future<RoundModel> getRound(int roundId) async {
    RoundEntity roundEntity = await getRoundEntity(roundId);
    List<RoundScoreEntity> roundScores = await listRoundScoreEntity(roundId);
    List<PlayerEntity> winners = [];

    return RoundModel(roundEntity, roundScores, winners);
  }

  Future<GameModel> getGame(int gameId) async {
    GameEntity _gameEntity = await getGameEntity(gameId);

    List<GamePlayerEntity> _listGamePlayerEntity =
        await listGamePlayerEntity(gameId);
    List<PlayerEntity> _listPlayerEntity = [];
    for (GamePlayerEntity gamePlayerEntity in _listGamePlayerEntity) {
      _listPlayerEntity.add(await getPlayerEntity(gamePlayerEntity.playerId!));
    }

    List<RoundModel> _listRoundModel = [];
    List<RoundEntity> _listRoundEntity = await listRoundEntity(gameId);
    for (RoundEntity roundEntity in _listRoundEntity) {
      _listRoundModel.add(await getRound(roundEntity.id!));
    }
    GameModel gameModel =
        GameModel(_gameEntity, _listPlayerEntity, _listRoundModel);

    return gameModel;
  }
}
