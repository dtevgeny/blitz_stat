import 'package:blitz_stat/core/constants.dart';
import 'package:blitz_stat/db/database.dart';
import 'package:blitz_stat/entity/game_entity.dart';
import 'package:blitz_stat/model/game_model.dart';
import 'package:blitz_stat/page/page_game.dart';
import 'package:blitz_stat/page/page_player_list.dart';
import 'package:blitz_stat/page/widget/drawer.dart';
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
      drawer: buildDrawer(2),
      body: Center(
        // child: isLoading ? const CircularProgressIndicator() : buildGames(),
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
        itemCount: listGameModel.length * 2,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              // todo: getGame directly without db access
              GameEntity gameEntity = await BlitzStatDatabase.instance
                  .getGameEntity(listGameModel[index].game.id!);
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => GamePage(gameEntity: gameEntity)),
              );
            },
            child: Container(
              height: 150,
              child: Card(
                margin: const EdgeInsets.all(8),
                elevation: 8,
                //
                child: Row(
                  children: [
                    Container(
                      color: Colors.red,
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.green,
                        // backgroundImage: AssetImage("assets/images/avatar.jpg"),
                      ),
                    ),
                    Text('[$index] id: ${listGameModel[index % 4].game.id}'),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
