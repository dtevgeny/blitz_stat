// https://www.flaticon.com/free-icon/finish-flag_1247820

import 'package:blitz_stat/core/constants.dart' as constants;
import 'package:flutter/material.dart';

import 'page/page_game_list.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

// todo: fix GameResults spacing between losers
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Блиц!",
      theme: ThemeData(
        primaryColor: constants.primaryColor,
        accentColor: constants.accentColor,
        fontFamily: 'RobotoCondensed',
      ),
      home: GameListPage(),
    );
  }
}
