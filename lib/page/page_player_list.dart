import 'package:blitz_stat/db/database.dart';
import 'package:blitz_stat/entity/game_entity.dart';
import 'package:blitz_stat/entity/game_player_entity.dart';
import 'package:blitz_stat/entity/player_entity.dart';
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
            'Players',
            style: TextStyle(fontSize: 24),
          ),
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
              child: const Icon(Icons.flag),
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
              child: const Icon(Icons.person_add),
              onPressed: () async {
                if (players.isEmpty) {
                  await BlitzStatDatabase.instance.generateBasicPlayers();
                } else {
                  await BlitzStatDatabase.instance
                      .createPlayer(PlayerEntity(firstname: 'PLAYER'));
                }
                await refreshPlayers();
              },
            ),
          ],
        ),
      );

  Widget buildPlayers() => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];

          return GestureDetector(
            onTap: () {
              if (selectedPlayers.contains(player)) {
                selectedPlayers.remove(player);
              } else {
                selectedPlayers.add(player);
              }
              setState(() {});
            },
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: index == players.length - 1
                    ? const EdgeInsets.symmetric(vertical: 16)
                    : const EdgeInsets.only(top: 16),
                elevation: 8,
                color: selectedPlayers.contains(player) ? Colors.green : null,
                child: Column(
                  children: [
                    Container(
                      // color: Colors.red,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        '${player.firstname} ${player.id}',
                      ),
                    ),
                    Container(
                        color: Colors.green,
                        child: Text(player.dtCreate.toString())),
                  ],
                )),
          );
        },
      );
}
