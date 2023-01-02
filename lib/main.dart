// https://www.flaticon.com/free-icon/finish-flag_1247820

import 'package:blitz_stat/db/database.dart';
import 'package:blitz_stat/entity/game_entity.dart';
import 'package:blitz_stat/entity/player_entity.dart';
import 'package:blitz_stat/page/page_game.dart';
import 'package:blitz_stat/page/page_player_list.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BLoC App",
      // home : MyHomePage(),
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        fontFamily: 'RobotoCondensed',
      ),
      // home : PlayerListPage(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Блиц!"),
          centerTitle: true,
        ),
        body: Center(
          child: GridView.count(
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [
              GestureDetector(
                onTap: () async {
                  // todo: remove hardcode route
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) => PlayerListPage()),
                  // );
                  GameEntity gameEntity =
                      await BlitzStatDatabase.instance.getGameEntity(1);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => GamePage(gameEntity: gameEntity)),
                  );
                },
                child: Card(
                  key: const Key('new_game'),
                  elevation: 8,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  borderOnForeground: true,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Image.asset("assets/images/game_start.png"),
                      ),
                      Container(
                        height: 25,
                        width: double.infinity,
                        // color: Colors.blue.withOpacity(0.8),
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                        child: const Center(
                          child: Text('Новая игра 1',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  GameEntity gameEntity =
                      await BlitzStatDatabase.instance.getGameEntity(2);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => GamePage(gameEntity: gameEntity)),
                  );
                },
                child: const Card(
                  child: Text('Игроки 2'),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  GameEntity gameEntity =
                  await BlitzStatDatabase.instance.getGameEntity(3);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => GamePage(gameEntity: gameEntity)),
                  );
                },
                child: const Card(
                  child: Text('История 3'),
                ),
              ),
              const Card(
                child: Text('Статистика'),
              ),
              const Card(
                child: Text('Синхронизация'),
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PlayerListPage()),
                  );
                },
                child: Card(
                  child: Text('Выйти'),
                ),
              ),
            ],
          ),
        ));
  }
}
