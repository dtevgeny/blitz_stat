import 'package:blitz_stat/entity/round_entity.dart';
import 'package:blitz_stat/entity/round_score_entity.dart';
import 'package:blitz_stat/entity/player_entity.dart';

class RoundModel {
  RoundEntity round;
  List<RoundScoreEntity> scores;
  List<PlayerEntity> winners;

  RoundModel(this.round, this.scores, this.winners);
}
