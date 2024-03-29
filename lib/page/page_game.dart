import 'dart:math';

import 'package:blitz_stat/core/constants.dart';
import 'package:blitz_stat/db/database.dart';
import 'package:blitz_stat/entity/game_entity.dart';
import 'package:blitz_stat/entity/round_entity.dart';
import 'package:blitz_stat/entity/round_score_entity.dart';
import 'package:blitz_stat/entity/round_winner_entity.dart';
import 'package:blitz_stat/model/game_model.dart';
import 'package:blitz_stat/entity/player_entity.dart';
import 'package:blitz_stat/page/page_add_round.dart';
import 'package:blitz_stat/page/widget/grid_delegate.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

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
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
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
                  _getChart(),
                  _getPlayerNameRow(),
                  buildGameRounds(),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add_chart, color: Colors.white),
        onPressed: () async {
          // _generateNewRound(gameModel);
          // refreshGame();
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddRoundPage(
              gameModel: gameModel,
            ),
          ));
        },
      ),
    );
  }

  Widget _getChart() {
    int _getSubtotal(int row, int col) {
      int result = 0;
      for (int i = gameModel.rounds.length - 1; i > row - 1; i--) {
        result += gameModel.rounds[i].scores[col].score!;
      }
      return result;
    }

    List<List<FlSpot>> spots = [];
    for (int i = 0; i < gameModel.players.length; i++) {
      List<FlSpot> _currentSpot = [];
      for (int n = 0; n <= gameModel.rounds.length; n++) {
        _currentSpot.add(FlSpot(n.toDouble(),
            _getSubtotal(gameModel.rounds.length - n, i).toDouble()));
      }
      spots.add(_currentSpot);
    }

    List<LineChartBarData> listLineChartBarData = [];
    for (int i = 0; i < gameModel.players.length; i++) {
      listLineChartBarData.add(LineChartBarData(
        color: playerColors[i],
        barWidth: 3,
        spots: spots[i],
        isCurved: true,
        dotData: FlDotData(
          show: false,
        ),
      ));
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(

        LineChartData(
          lineTouchData: LineTouchData(
            enabled: false,
          ),
          lineBarsData: listLineChartBarData,
        ),
      ),
    );
  }

  Widget buildGameRounds() {
    int _getSubtotal(int index) {
      int row = index ~/ gameModel.players.length;
      int col = index % gameModel.players.length;

      int result = 0;
      for (int i = gameModel.rounds.length - 1; i > row - 1; i--) {
        result += gameModel.rounds[i].scores[col].score!;
      }

      return result;
    }

    return Expanded(
      child: Container(
        color: Colors.blue,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
            crossAxisCount: gameModel.players.length,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            height: 50,
          ),
          padding: const EdgeInsets.all(1),
          itemCount: gameModel.rounds.length * gameModel.players.length,
          itemBuilder: (context, index) {
            int row = index ~/ gameModel.players.length;
            int col = index % gameModel.players.length;
            return Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                _getSubtotal(index).toString(),
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: gameModel.rounds[row].winners
                            .map((e) => e.id!)
                            .toList()
                            .contains(gameModel.players[col].id)
                        ? FontWeight.bold
                        : FontWeight.normal),
              ),
            );
          },
        ),
      ),
    );
  }

  Row _getPlayerNameRow() {
    List<Widget> list = [];
    for (int i = 0; i < gameModel.players.length; i++) {
      list.add(Expanded(
          child: Container(
        alignment: Alignment.center,
        child: Text(
          '${gameModel.players[i].firstname} ${gameModel.players[i].firstname == 'PLAYER' ? gameModel.players[i].id : ''}',
          softWrap: false,
          style: TextStyle(
            fontSize: 24,
            color: playerColors[i],
          ),
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
          score: Random().nextInt(30) - 10);

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
