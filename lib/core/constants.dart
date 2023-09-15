import 'dart:math';

import 'package:flutter/material.dart';
////////////////////////////////////////////////////////////////////////////////
bool dev = true;
// bool dev = false;
////////////////////////////////////////////////////////////////////////////////


// hints:
// 1. Когда стартует игра с Иришкой
// 2. Когда время между раундами еджу 1 часом и 1 днём - "Отвлеклись, да девчонки?"


Color devColor(int? index){
  if (dev) {
    if (index == null || index > playerColors.length - 1) {
      return playerColors[Random().nextInt(playerColors.length - 1)];
    } else {
      return playerColors[index];
    }
  } else {
    return Colors.white;
  }
}

Text _getColoredText(String text, Color? color) {
  return Text(text, style: TextStyle(color: color),);
}

Text getColoredText(String text, int? index) {
  return _getColoredText(text, playerColors[index ?? 0]);
}

int devConsts(int index){
  return index;
}

// Color primaryColor = const Color(0xff103366);
// Color accentColor = const Color(0xffFFD100);
const Color primaryColor = Color(0xff303E9F);
const Color accentColor = Color(0xffFDC72F);

const Color platinumColor = Color(0xffe5e4e2);
const Color goldColor = Color(0xffd4af37);
const Color silverColor = Color(0xffc0c0c0);
const Color bronzeColor = Color(0xffcd7f32);
const Color brassColor = Color(0xffb5a642);

List<Color> playerColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.purple,
  Colors.yellow,
  Colors.cyan,
  Colors.teal,
  Colors.black,
];

Widget returnC(String? text){
  return Container(
    child: Text('$text'),
  );
}