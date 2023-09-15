import 'dart:math';
import 'package:blitz_stat/core/constants.dart' as constants;
import 'package:blitz_stat/db/database.dart';
import 'package:blitz_stat/entity/player_entity.dart';
import 'package:blitz_stat/entity/round_entity.dart';
import 'package:blitz_stat/entity/round_score_entity.dart';
import 'package:blitz_stat/entity/round_winner_entity.dart';

import 'package:blitz_stat/model/game_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// todo: switch visibislity of keyboard through action button. With "isChecked" property-variant
class AddRoundPage extends StatefulWidget {
  GameModel gameModel;

  AddRoundPage({required this.gameModel});

  @override
  State<AddRoundPage> createState() => _AddRoundPageState(gameModel: gameModel);
}

class _AddRoundPageState extends State<AddRoundPage> {
  bool isLoading = false;

  GameModel gameModel;
  int selectedPlayer = -1;
  late List<int> scores = List.generate(gameModel.players.length, (index) => 0);
  late List<bool> winners =
      List.generate(gameModel.players.length, (index) => false);

  _AddRoundPageState({required this.gameModel});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новый раунд', style: TextStyle(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              // refreshGame();
            },
          ),
        ],
      ),
      // body: const Center(child: Text('AddRoundPage')),
      body: Column(
        children: [
          _buildPlayers(),
          _buildButtons(),
        ],
      ),
    );
  }

  // todo: button switch to fit all players in one grid
  Widget _buildPlayers() {
    return Expanded(
      child: ListView.builder(
        itemCount: gameModel.players.length,
        itemBuilder: (context, index) {
          PlayerEntity player = gameModel.players[index];
          String fio =
              '${player.firstname!} ${player.lastname ?? player.id.toString()}';

          return GestureDetector(
            onTap: () {
              selectedPlayer = selectedPlayer == index ? -1 : index;
              setState(() {});
            },
            child: Card(
                // todo: change backGroundColor to Border
                color: selectedPlayer == index ? Colors.green : null,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                          "assets/images/${player.id! > 4 ? 'avatar' : player.id.toString()}.jpg",
                        ),
                        radius: 30,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        // '${player.firstname!} ${player.lastname}',
                        fio,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        winners[index] ? Icons.star : Icons.star_outline,
                        color: winners[index] ? Colors.amber : null,
                      ),
                      onPressed: () {
                        winners[index] = !winners[index];
                        selectedPlayer = index;
                        setState(() {});
                      },
                    ),
                    SizedBox(
                      width: 50,
                      child: Center(
                        child: Text(
                          scores[index].toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }

  Future<void> _saveRound() async {
    DateTime dt = DateTime.now();
    RoundEntity roundEntity = await RoundEntity(
      gameId: gameModel.game.id,
      dtCreate: dt,
      dtUpdate: dt,
    ).save();

    for (int i = 0; i < gameModel.players.length; i++) {
      await RoundScoreEntity(
        roundId: roundEntity.id,
        playerId: gameModel.players[i].id,
        score: scores[i],
        dtCreate: dt,
        dtUpdate: dt,
      ).save();

      if (winners[i]) {
        await RoundWinnerEntity(
          roundId: roundEntity.id,
          playerId: gameModel.players[i].id,
          dtCreate: dt,
          dtUpdate: dt,
        ).save();
      }
    }
    // todo: game finish check
    // todo: round winner check and notification
  }

  Widget _buildButtons() {
    const double defaultHeight = 65;
    const double defaultMargin = 6;

    ButtonStyle defaultButtonStyle = TextButton.styleFrom(
      primary: constants.primaryColor,
      elevation: 1,
      backgroundColor: Colors.white,
    );

    ButtonStyle accentButtonStyle = TextButton.styleFrom(
      primary: constants.accentColor,
      elevation: 1,
      backgroundColor: Colors.white,
    );

    Future<void> _buttonPressed(value) async {
      /*
      todo: iconDate:
        check:
          2 блицанувших - серьезно?
          3 блицанувших - А не 3,14здишь ли ты часом?
          3+ - ??? можно, конечно, но кто терпила... проверка на вымгрыш после подсчёта
      // todo: возможно надо придумать новую логику для нароче через TextButton если та уже есть две цифры
      // todo: если после нажатия получается больше 40 очков, ...
         то должно надо заменять значение;
         Хотя надо учитывать double_click по одной кнопке для установления 40 очков...

         бред...

         Не факт, что так будет лучше, чем я думаю.
         Идея уточнить у девчОнок - не совсем корректная, а уж тем более неправильная!

         -----------------------------------

         Может преобразовывать значение больше 40?
         Подсвечиватль легче, но не давая нажать "DONE" ещё правильней.
       */
      if (value is IconData) {
        // todo: if done then check gameRound; after that it could be saved;
        if (value == Icons.check) {
          await _saveRound();
          print('iconData "Icons.check" pressed');
        } else if (selectedPlayer > -1) {
          if (value == Icons.arrow_back) {
            selectedPlayer = selectedPlayer == 0
                ? gameModel.players.length - 1
                : selectedPlayer - 1;
          } else if (value == Icons.arrow_forward) {
            selectedPlayer = selectedPlayer == gameModel.players.length - 1
                ? 0
                : selectedPlayer + 1;
          } else if (value == Icons.backspace_outlined) {
            String s = scores[selectedPlayer]
                .toString()
                .substring(0, scores[selectedPlayer].toString().length - 1);
            scores[selectedPlayer] = int.tryParse(s) ?? 0;
          } else {
            throw Exception(
                "AddRoundPage._buttonPressed.Exception.IconData.unknown");
          }
        }
      } else if (value is int || value is String) {
        if (selectedPlayer > -1) {
          String result = scores[selectedPlayer].toString() + value.toString();
          if (value is int) {
            result = (result.startsWith('-') ? '-' : '') +
                result.substring(result.length - 2);
            // todo: replace with accordance that MAX point per round could be other
            scores[selectedPlayer] =
                min(max(int.tryParse(result) ?? 0, -20), 40);
          } else if (value is String) {
            if ('+/-' == value) {
              scores[selectedPlayer] = max(-20, -scores[selectedPlayer]);
            } else {
              throw Exception(
                  "AddRoundPage._buttonPressed.Exception.String.content");
            }
          }
        }
      } else {
        throw Exception('AddRoundPage._buttonPressed.Exception.type');
      }
    }

    // Widget _button(value, {[ButtonStyle buttonStyle = defaultButtonStyle], double? height}) {
    Widget _button(value, {ButtonStyle? buttonStyle, double? height}) {
      return StaggeredGridTile.extent(
        crossAxisCellCount: 1,
        mainAxisExtent: height ?? defaultHeight,
        child: TextButton(
          onPressed: () {
            _buttonPressed(value);
            setState(() {});
          },
          child: value is IconData
              ? Icon(value, color: Colors.black)
              : Text(
                  value is int
                      ? value.toString()
                      : value is String
                          ? value
                          : 'WRONG TYPE',
                  style: const TextStyle(color: Colors.black, fontSize: 24)),
          style: buttonStyle ?? defaultButtonStyle,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(defaultMargin),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: defaultMargin,
        crossAxisSpacing: defaultMargin,
        children: [
          _button(7),
          _button(8),
          _button(9),
          _button(Icons.backspace_outlined),
          _button(4),
          _button(5),
          _button(6),
          _button('+/-'),
          _button(3),
          _button(2),
          _button(1),
          _button(
            Icons.check,
            height: defaultHeight * 2 + defaultMargin,
            buttonStyle: accentButtonStyle,
          ),
          _button(Icons.arrow_back),
          _button(0),
          _button(Icons.arrow_forward),
        ],
      ),
    );
  }
}
