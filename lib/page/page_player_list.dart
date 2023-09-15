import 'package:blitz_stat/core/constants.dart' as constants;
import 'package:blitz_stat/db/database.dart';
import 'package:blitz_stat/entity/game_entity.dart';
import 'package:blitz_stat/entity/game_player_entity.dart';
import 'package:blitz_stat/entity/player_entity.dart';
import 'package:blitz_stat/page/page_add_player.dart';
import 'package:blitz_stat/page/widget/grid_delegate.dart';
import 'package:flutter/material.dart';

import 'page_game.dart';

class PlayerListPage extends StatefulWidget {
  @override
  _PlayerListPageState createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State<PlayerListPage> {
  late List<PlayerEntity> players;
  List<PlayerEntity> selectedPlayers = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshPlayers();
  }

  Future refreshPlayers() async {
    setState(() => isLoading = true);

    selectedPlayers = [];
    players = await BlitzStatDatabase.instance.readAllPlayers();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Игроки',
            style: TextStyle(fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : players.isEmpty
                  ? const Text(
                      'No players',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildPlayers(),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'fab_page_player_list_start',
              backgroundColor:
                  selectedPlayers.length > 1 ? Colors.blue : Colors.grey,
              child: const Icon(Icons.flag, color: Colors.white),
              onPressed: () async {
                if (selectedPlayers.length > 1) {
                  DateTime dt = DateTime.now();
                  GameEntity game =
                      GameEntity(status: 100, dtCreate: dt, dtUpdate: dt);
                  game = await BlitzStatDatabase.instance.createGame(game);

                  for (PlayerEntity player in selectedPlayers) {
                    GamePlayerEntity gamePlayer = GamePlayerEntity(
                        gameId: game.id,
                        playerId: player.id,
                        dtCreate: dt,
                        dtUpdate: dt);
                    BlitzStatDatabase.instance.createGamePlayer(gamePlayer);
                  }

                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GamePage(
                      gameEntity: game,
                    ),
                  ));
                }
              },
            ),
            const SizedBox(
              height: 8,
            ),
            FloatingActionButton(
              heroTag: 'fab_page_player_list_new_player',
              backgroundColor: Colors.green,
              child: const Icon(Icons.person_add, color: Colors.white),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddPlayerPage(),
                  ),
                );

                // todo: remove unnecessary functions and code
                // if (players.isEmpty) {
                //   await BlitzStatDatabase.instance.generateBasicPlayers();
                // } else {
                //   await BlitzStatDatabase.instance
                //       .createPlayer(PlayerEntity(firstname: 'PLAYER'));
                // }
                // await refreshPlayers();
              },
            ),
          ],
        ),
      );

  Widget buildPlayers() {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
        crossAxisCount: 2,
        height: 196,
      ),
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: players.length,
      itemBuilder: (context, index) {
        return _buildPlayerItem(players[index]);
      },
    );
  }

  // todo: change to PlayerListItem
  Widget _buildPlayerItem(PlayerEntity playerEntity) {
    return GestureDetector(
      onTap: () {
        if (selectedPlayers.contains(playerEntity)) {
          selectedPlayers.remove(playerEntity);
        } else {
          selectedPlayers.add(playerEntity);
        }
        setState(() {});
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          color: selectedPlayers.contains(playerEntity) ? Colors.green : null,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                      "assets/images/${playerEntity.id! > 4 ? 'avatar' : playerEntity.id.toString()}.jpg"),
                  radius: 40,
                ),
                Text('${playerEntity.firstname}',
                    style: const TextStyle(fontSize: 24)),
                Text(playerEntity.lastname ?? '',
                    style: const TextStyle(fontSize: 24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      // color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.star_outline,
                                color: constants.accentColor),
                            Text('99', style: TextStyle(fontSize: 24)),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      // color: Colors.yellow,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.functions,
                                color: constants.primaryColor),
                            Text('99', style: TextStyle(fontSize: 24)),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
