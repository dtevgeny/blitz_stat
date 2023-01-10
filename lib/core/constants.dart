import 'dart:math';

import 'package:flutter/material.dart';
////////////////////////////////////////////////////////////////////////////////
bool dev = true;
// bool dev = false;
////////////////////////////////////////////////////////////////////////////////

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

Color platinumColor = const Color(0xffe5e4e2);
Color goldColor = const Color(0xffd4af37);
Color silverColor = const Color(0xffc0c0c0);
Color bronzeColor = const Color(0xffcd7f32);
Color brassColor = const Color(0xffb5a642);

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