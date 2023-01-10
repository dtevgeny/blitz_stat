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
              const CircleAvatar(
                backgroundImage: AssetImage("assets/images/avatar.jpg"),
                radius: 50,
                // backgroundColor: Colors.red,
                // child: Text('game_id = ${gameModel.game.id}'),
                child: Text('139'),
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
}
