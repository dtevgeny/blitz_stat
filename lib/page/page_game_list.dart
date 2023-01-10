import 'dart:math';

import 'package:blitz_stat/core/constants.dart';
import 'package:blitz_stat/db/database.dart';
import 'package:blitz_stat/entity/game_entity.dart';
import 'package:blitz_stat/model/game_model.dart';
import 'package:blitz_stat/page/page_game.dart';
import 'package:blitz_stat/page/page_player_list.dart';
import 'package:blitz_stat/page/widget/drawer.dart';
import 'package:blitz_stat/page/widget/grid_delegate.dart';
import 'package:flutter/material.dart';

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
      drawer: buildDrawer(null),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : listGameModel.isEmpty
                ? const Text('no games')
                : buildGames(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.flag),
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PlayerListPage()));

          // refreshGames();
        },
      ),
    );
  }

  Widget buildGames() {
    return buildGamesListView();
    // return buildGamesGridView();
  }

  Widget buildGamesGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: listGameModel.length,
      itemBuilder: (context, index) {
        return _r(index, listGameModel[index]);
      },
    );
  }

  Widget _r(int index, GameModel gameModel) {
    return Container(
      padding: EdgeInsets.all(8),
      color: playerColors[index % playerColors.length],
      // child: Text('game ${gameModel.game.id} pressed'),
      child: CircleAvatar(child: Text('game ${gameModel.game.id}')),
    );
  }

  Widget buildGamesListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(4),
      itemCount: listGameModel.length,
      itemBuilder: (context, index) {
        return _getGameResultLine(listGameModel[index]);
      },
    );
  }

  Widget _getGameResultLine(GameModel gameModel) {
    return Card(
      shape: const BeveledRectangleBorder(),
      elevation: 4,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Татьяна',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        Row(children: [
                          Row(
                            children: const [
                              Icon(Icons.ac_unit),
                              Text('139'),
                            ],
                          ),
                          Row(
                            children: const [
                              Icon(Icons.ac_unit),
                              Text('139'),
                            ],
                          ),
                        ]),
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.ac_unit),
                            Text('99'),
                          ],
                        ),
                        Row(
                          children: const [
                            Icon(Icons.ac_unit),
                            Text('99'),
                          ],
                        ),
                        Row(
                          children: const [
                            Icon(Icons.ac_unit),
                            Text('99'),
                          ],
                        ),
                        Row(
                          children: const [
                            Icon(Icons.ac_unit),
                            Text('99'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundImage: const AssetImage("assets/images/avatar.jpg"),
                radius: 50,
                // backgroundColor: Colors.red,
                // child: Text('game_id = ${gameModel.game.id}'),
                child: const Text('139'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('999 минут'),
              Text('999 дней назад'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getGameResultLine1(GameModel gameModel) {
    int _getPlayerTotalScore(int index) {
      return 101 - 10 * index;
    }

    return GestureDetector(
      onTap: () async {
        print('game ${gameModel.game.id} pressed');
        // todo: getGame directly without db access
        GameEntity gameEntity =
            await BlitzStatDatabase.instance.getGameEntity(gameModel.game.id!);
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => GamePage(gameEntity: gameEntity)),
        );
      },
      child: SizedBox(
        height: 152,
        child: Card(
          margin: const EdgeInsets.all(8),
          elevation: 8,
          //
          child: Row(
            children: [
              // todo: remove SizedBox
              const SizedBox(width: 8),
              Container(
                color: dev ? Colors.white : devColor(0),
                child: Container(
                  decoration: _boxDecoration(goldColor),
                  clipBehavior: Clip.hardEdge,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage:
                        const AssetImage("assets/images/avatar.jpg"),
                    child: Container(
                      child: Text(
                        '139',
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                color: Colors.blue,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  // color: devColor(null),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _getLoserLine(0),
                      Divider(color: Colors.red),
                      _getLoserLine(1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration(Color _boxDecorationColor) {
    return BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          blurRadius: 8,
          color: _boxDecorationColor,
          spreadRadius: 4,
        ),
      ],
    );
  }

  Widget _getLoserLine(int i) {
    return Container(
      height: 52,
      // color: i == 0 ? Colors.green : Colors.purple,
      // color: devColor(i + 1),
      child: Row(
        children: [
          // todo: remove SizedBox
          const SizedBox(width: 8),
          Container(
            decoration: _boxDecoration(i == 0 ? silverColor : bronzeColor),
            child: CircleAvatar(
              backgroundColor: bronzeColor,
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/avatar.jpg"),
              ),
            ),
          ),
          Expanded(
              child: Center(
                  child: Text(
            '${listGameModel[0].players[0].firstname!} ',
            style: const TextStyle(fontSize: 24),
          ))),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 19,
              backgroundColor: i == 0 ? silverColor : bronzeColor,
              child: const Text(
                '68',
                style: TextStyle(color: Colors.white, fontSize: 24),
                // style: TextStyle(color: i == 0 ? silverColor : bronzeColor, fontSize: 24),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
        // children: const [
        //   Icon(Icons.account_circle),
        //   Text('data'),
        // ],
      ),
    );
  }
}
