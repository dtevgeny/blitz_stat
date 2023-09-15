import 'package:blitz_stat/core/constants.dart';
import 'package:blitz_stat/db/database.dart';
import 'package:blitz_stat/entity/game_entity.dart';
import 'package:blitz_stat/entity/game_player_entity.dart';
import 'package:blitz_stat/entity/player_entity.dart';
import 'package:blitz_stat/entity/round_score_entity.dart';
import 'package:blitz_stat/model/game_model.dart';
import 'package:blitz_stat/model/game_player_result_model.dart';
import 'package:blitz_stat/model/round_model.dart';
import 'package:blitz_stat/page/page_game.dart';
import 'package:blitz_stat/page/page_player_list.dart';
import 'package:blitz_stat/page/widget/drawer.dart';
import 'package:flutter/material.dart';

import 'package:blitz_stat/core/constants.dart' as constants;

class GameListPage extends StatefulWidget {
  GameListPage();

  @override
  State<GameListPage> createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  bool isLoading = false;

  late List<GameModel> listGameModel;
  late GameModel selected;

  _GameListPageState();

  @override
  void initState() {
    super.initState();

    refreshGames();
  }

  Future refreshGames() async {
    setState(() => isLoading = true);

    listGameModel = await BlitzStatDatabase.instance.listGame();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Блиц!',
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              refreshGames();
            },
          ),
        ],
      ),
      // backgroundColor: Colors.deepPurpleAccent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.flag, color: Colors.white),
        // backgroundColor: primaryColor,
        // child: Icon(Icons.flag, color: constants.accentColor),
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PlayerListPage()));

          // refreshGames();
        },
      ),
      drawer: buildDrawer(null),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : listGameModel.isEmpty
                ? const Text('no games')
                : buildGames(),
      ),
    );
  }

  Widget buildGames() {
    // return buildGames2();
    return ListView.builder(
      padding: const EdgeInsets.all(4),
      itemCount: listGameModel.length,
      itemBuilder: (context, index) {
        return _getGameResultLine(listGameModel[index]);
      },
    );
  }

  Widget _getGameResultLine(GameModel gameModel) {
    GamePlayerResultModel _getWinner() {
      List<GamePlayerResultModel> scores = List.generate(
          gameModel.players.length,
          (index) =>
              GamePlayerResultModel(gameModel, gameModel.players[index]));

      scores.sort((a, b) => -a.totalScore.compareTo(b.totalScore));
      return scores[0];
    }

    GamePlayerResultModel _winner = _getWinner();

    Widget _getIconText(IconData iconData, String text) {
      return Flexible(
        child: Row(
          children: [
            Icon(iconData),
            Text(
              text,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () async {
        GameEntity gameEntity =
            await BlitzStatDatabase.instance.getGameEntity(gameModel.game.id!);
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GamePage(gameEntity: gameEntity)));
      },
      child: Card(
        shadowColor: _getWinner().totalScore <= 100 ? Colors.red : null,
        // shape: const BeveledRectangleBorder(),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8 * 1)),
        ),
        elevation: _getWinner().totalScore <= 100 ? 8 : 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // todo: remove this Row
                        Row(
                          children: [
                            Text(_winner.playerEntity.firstname!,
                                // style: const TextStyle(fontSize: 24),
                                style: const TextStyle(fontSize: 24)),
                          ],
                        ),
                        // todo: change Divider for Padding
                        // const Divider(endIndent: 8, color: Colors.white),
                        const Divider(endIndent: 8),
                        Row(
                          children: [
                            _getIconText(
                                Icons.group_outlined,
                                // _getIconText(Icons.groups,
                                // _getIconText(Icons.person_outline,
                                gameModel.players.length.toString()),
                            _getIconText(Icons.update,
                                gameModel.rounds.length.toString()),
                            _getIconText(Icons.star_outline,
                                _winner.roundWinCount.toString()),
                            _getIconText(Icons.vertical_align_top,
                                _winner.maximumRoundScore.toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage(
                        "assets/images/${_winner.playerEntity.id! > 4 ? 'avatar' : _winner.playerEntity.id.toString()}.jpg"),
                    radius: 40,
                    // backgroundColor: Colors.red,
                    // child: Text('game_id = ${gameModel.game.id}'),
                    child: Text(_winner.totalScore.toString(),
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)
                        // .copyWith(
                        //     foreground: Paint()
                        //       ..style = PaintingStyle.stroke
                        //       ..color = Colors.amber
                        //       ..strokeWidth = 1)
                        ),
                  ),
                ],
              ),
              // todo: change Divider for Padding
              const Divider(color: Colors.white),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(_winner.timeAgo,
                      style: TextStyle(color: Colors.grey.shade400)),
                  const VerticalDivider(width: 4,),
                  Icon(Icons.done_all, color: Colors.grey.shade400),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
