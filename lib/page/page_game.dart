import 'dart:math';

import 'package:blitz_stat/db/database.dart';
import 'package:blitz_stat/entity/game_entity.dart';
import 'package:blitz_stat/entity/round_entity.dart';
import 'package:blitz_stat/entity/round_score_entity.dart';
import 'package:blitz_stat/entity/round_winner_entity.dart';
import 'package:blitz_stat/model/game_model.dart';
import 'package:blitz_stat/entity/player_entity.dart';
import 'package:blitz_stat/model/round_model.dart';
import 'package:blitz_stat/page/widget/grid_delegate.dart';
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
        title: Text(
          'Игра #${gameEntity.id}',
          style: const TextStyle(fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              refreshGame();
            },
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  _getPlayerNameRow(),
                  buildGameRounds(),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add_chart),
        onPressed: () async {
          _generateNewRound(gameModel);
          refreshGame();
        },
      ),
    );
  }

  Widget buildGameRounds() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
          crossAxisCount: gameModel.players.length,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          height: 50,
        ),
        padding: const EdgeInsets.all(2),
        itemCount: gameModel.rounds.length * gameModel.players.length,
        itemBuilder: (context, index) {
          int row = index ~/ gameModel.players.length;
          int col = index % gameModel.players.length;
          return Container(
            alignment: Alignment.center,
            color: Colors.red,
            child: Text(
              gameModel.rounds[row].scores[col].score.toString(),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: gameModel.rounds[row].winners
                          .contains(gameModel.players[col])
                      // fontWeight: col == 2
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          );
        },
      ),
    );
  }

  Row _getPlayerNameRow() {
    List<Widget> list = [];
    for (PlayerEntity player in gameModel.players) {
      list.add(Expanded(
          child: Container(
        alignment: Alignment.center,
        child: Text(
          '${player.firstname!} ${player.id}',
          softWrap: false,
          style: const TextStyle(fontSize: 24),
        ),
      )));
    }
    return Row(
      children: list,
    );
  }

  void _generateNewRound(GameModel gameModel) async {
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

    // todo: prepare/develop function that uses not numbers, but arrays
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
      RoundWinnerEntity roundWinnerEntity = RoundWinnerEntity(
          roundId: round.id, playerId: gameModel.players[winnerNumber].id);
      winners.add(roundWinnerEntity);
      BlitzStatDatabase.instance.createRoundWinner(roundWinnerEntity);
    }
  }
}
