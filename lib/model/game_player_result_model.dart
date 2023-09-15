import 'package:blitz_stat/entity/player_entity.dart';
import 'package:blitz_stat/model/game_model.dart';
import 'package:blitz_stat/model/round_model.dart';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class GamePlayerResultModel {
  late GameModel gameModel;
  late PlayerEntity playerEntity;
  bool isWinner = false;
  int totalScore = 0;
  int roundWinCount = 0;
  int averageRoundScore = 0;
  int maximumRoundScore = 0;
  int aboveAverageRoundScore = 0;
  String timeAgo = "";

  GamePlayerResultModel(GameModel game, PlayerEntity player) {
    gameModel = game;
    playerEntity = player;

    for (RoundModel roundModel in gameModel.rounds) {
      if (roundModel.winners
              .firstWhereOrNull((element) => element.id == playerEntity.id) !=
          null) {
        roundWinCount += 1;
      }

      int score = roundModel.scores
          .firstWhere((element) => element.playerId == playerEntity.id)
          .score!;
      totalScore += score;
      if (score > maximumRoundScore) {
        maximumRoundScore = score;
      }
    }

    isWinner = totalScore > 100;

    averageRoundScore = totalScore ~/ gameModel.rounds.length;

    for (RoundModel roundModel in gameModel.rounds) {
      if (roundModel.scores
              .firstWhere((element) => element.playerId == playerEntity.id)
              .score! >=
          averageRoundScore) {
        aboveAverageRoundScore += 1;
      }
    }

    // timeAgo = gameModel.game.dtCreate!.toIso8601String();
    timeAgo = DateFormat('dd.MM.yyyy HH:mm:ss').format(gameModel.game.dtCreate!);
  }

  @override
  String toString() {
    return '{isWinner = $isWinner, '
        'totalScore = $totalScore, '
        'roundWinCount = $roundWinCount, '
        'averageRoundScore = $averageRoundScore, '
        'maximumRoundScore = $maximumRoundScore, '
        'aboveAverageRoundScore = $aboveAverageRoundScore}';
  }
}
