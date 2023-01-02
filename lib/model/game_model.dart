import 'package:blitz_stat/entity/game_entity.dart';
import 'package:blitz_stat/entity/player_entity.dart';
import 'package:blitz_stat/model/round_model.dart';

class GameModel {
  GameEntity game;
  List<PlayerEntity> players;
  List<RoundModel> rounds;

  GameModel(this.game, this.players, this.rounds);
}
