import 'package:flutter/material.dart';

Drawer buildDrawer(int? selected) {
  ListTile _getListTile(
      String title, IconData iconData, Color iconColor, bool isSelected) {
    TextStyle _textStyle = TextStyle(
      fontSize: 20,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    );
    return ListTile(
      leading: Icon(iconData, color: iconColor, size: 40),
      // trailing: Icon(iconData, color: iconColor, size: 40),
      title: Text(title, style: _textStyle),
      tileColor: isSelected ? Colors.grey.shade300 : Colors.white,
      onTap: () {},
    );
  }

  return Drawer(
    // width: 250,
    child: Container(
      color: Colors.white,
      child: ListView(
        children: [
          _getListTile(
              'Новая игра', Icons.flag_outlined, Colors.green, selected == 0),
          _getListTile(
              'Игроки', Icons.badge_outlined, Colors.blue, selected == 1),
          const Divider(),
          // todo: change purple color
          _getListTile('История', Icons.history, Colors.purple, selected == 2),
          _getListTile(
              'Статистика', Icons.bar_chart, Colors.orange, selected == 3),
          const Divider(),
          _getListTile('Синхронизация', Icons.sync, Colors.blue, selected == 4),
          const Divider(),
          _getListTile('Выйти', Icons.exit_to_app, Colors.red, selected == 4),
        ],
      ),
    ),
  );
}
