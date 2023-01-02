import 'dart:math';

import 'package:blitz_stat/db/database.dart';
import 'package:blitz_stat/entity/game_entity.dart';
import 'package:blitz_stat/entity/round_entity.dart';
import 'package:blitz_stat/entity/round_score_entity.dart';
import 'package:blitz_stat/entity/round_winner_entity.dart';
import 'package:blitz_stat/model/game_model.dart';
import 'package:blitz_stat/entity/player_entity.dart';
import 'package:blitz_stat/model/round_model.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  GameEntity gameEntity;

  GamePage({required this.gameEntity});

  @override
  State<GamePage> createState() => _GamePageState(gameEntity: gameEntity);
}

class _GamePageState extends State<GamePage> {
  bool isLoading = false;

  GameEntity gameEntity;
  late GameModel gameModel;

  _GamePageState({required this.gameEntity});

  @override
  void initState() {
    super.initState();

    refreshGame();
  }

  Future refreshGame() async {
    setState(() => isLoading = true);

    gameModel = await BlitzStatDatabase.instance.getGame(gameEntity.id!);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Игра #NNN',
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              setState(() => isLoading = true);

              gameModel =
                  await BlitzStatDatabase.instance.getGame(gameEntity.id!);
              print("gameEntity.id = ${gameEntity.id.toString()}");

              setState(() => isLoading = false);
            },
          ),
        ],
      ),
      body: Center(
        child: isLoading ? const CircularProgressIndicator() : buildGame4(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add_chart),
        onPressed: () async {
          RoundEntity round = RoundEntity(gameId: gameModel.game.id);
          round = await BlitzStatDatabase.instance.createRound(round);

          for (PlayerEntity player in gameModel.players) {
            RoundScoreEntity roundScore = RoundScoreEntity(
                roundId: round.id,
                playerId: player.id,
                score: Random().nextInt(60) - 20);

            roundScore =
                await BlitzStatDatabase.instance.createRoundScore(roundScore);
          }

          ////////////////////////////////////////////////////////////////////

          List<int> winnerNumbers = [];
          bool flag = false;
          while (!flag) {
            int rnd = Random().nextInt(gameModel.players.length - 1);

            if (!winnerNumbers.contains(rnd)) {
              winnerNumbers.add(rnd);
            } else {
              if (Random().nextInt(100 - 1) >= 30) {
                flag = true;
              }
            }
          }
          List<RoundWinnerEntity> winners = [];
          for (int winnerNumber in winnerNumbers) {
            winners.add(RoundWinnerEntity(
                roundId: round.id,
                playerId: gameModel.players[winnerNumber].id));
          }

          print(
              'page_game fab clicked; new round, List<roundScore>, List<roundWinner> inserted');
        },
      ),
    );
  }

  Row _getRoundScoreRow(RoundModel roundModel) {
    // adhesive - клей
    List<Widget> result = [];
    for (RoundScoreEntity roundScoreEntity in roundModel.scores) {
      result.add(
        Expanded(
            child: Container(
                alignment: Alignment.center,
                child: Text('${roundScoreEntity.score.toString()}'))),
      );
    }

    return Row(children: result);
  }

  Widget buildGame4() {
    return ListView.builder(
        itemCount: gameModel.rounds.length,
        itemBuilder: (context, index) {
          return _getRoundScoreRow(gameModel.rounds[index]);
        });
  }

  Widget buildGame3() {
    return ListView.builder(
        itemCount: gameModel.rounds.length,
        itemBuilder: (context, index) {
          int row = index ~/ gameModel.players.length;
          int col = index % gameModel.players.length;
          print('$index[$col,$row]');

          MaterialColor color = col % 2 == 0
              ? (row % 2 == 0 ? Colors.red : Colors.green)
              : (row % 2 == 0 ? Colors.blue : Colors.yellow);

          // return Text('row $row | round ${gameModel.rounds[row].scores[col].score.toString()}');
          return Text(
              'index $index row $row | col $col | round ${gameModel.rounds[row].round.id!.toString()}');
        });
  }

  Widget buildGame2() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gameModel.players.length,
        childAspectRatio: 2,
      ),
      itemCount: gameModel.players.length * gameModel.rounds.length,
      itemBuilder: (context, index) {
        int row = index ~/ gameModel.players.length;
        int col = index % gameModel.players.length;
        print('$index[$col,$row]');
        MaterialColor color = col % 2 == 0
            ? (row % 2 == 0 ? Colors.red : Colors.green)
            : (row % 2 == 0 ? Colors.blue : Colors.yellow);

        return Container(
          // color: color,
          color: col % 2 == 0
              ? (row % 2 == 0 ? Colors.red : Colors.green)
              : (row % 2 == 0 ? Colors.blue : Colors.yellow),
          child: Text(
              '$index: $col-$row | ${gameModel.rounds[row].scores[col].score.toString()}'),
          // child: Text('$index: $col-$row'),
        );
      },
    );
  }

// Widget buildGame() {
//   print('gameModel.players.length = ${gameModel.players.length}');
//
//   return Row(
//     children: [
//       Flexible(
//         child: ListView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             itemCount: gameModel.players.length,
//             itemBuilder: (context, index) {
//               return Container(
//                   color: index % 2 == 0 ? Colors.red : Colors.green,
//                   child: Text(
//                       '${gameModel.players[index].firstname} ${gameModel.players[index].id}'));
//             }),
//       ),
//     ],
//   );
// }
}
