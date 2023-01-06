// https://www.flaticon.com/free-icon/finish-flag_1247820

import 'package:blitz_stat/db/database.dart';
import 'package:blitz_stat/entity/game_entity.dart';
import 'package:blitz_stat/entity/player_entity.dart';
import 'package:blitz_stat/page/page_game.dart';
import 'package:blitz_stat/page/page_player_list.dart';
import 'package:flutter/material.dart';

import 'page/page_game_list.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Блиц!",
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        fontFamily: 'RobotoCondensed',
      ),
      home: GameListPage(),
    );
  }
}
