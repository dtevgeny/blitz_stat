import 'package:flutter/material.dart';

Drawer buildDrawer(int? selected) {
  ListTile _getListTile(
      String title, IconData iconData, Color iconColor, bool isSelected) {
    TextStyle _textStyle = TextStyle(
      fontSize: 20,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    );
    return ListTile(
      trailing: Icon(iconData, color: iconColor),
      title: Text(title, style: _textStyle),
      tileColor: isSelected ? Colors.grey.shade300 : Colors.white,
      onTap: () {},
    );
  }

  return Drawer(
    child: ListView(
      children: [
        _getListTile('Новая игра', Icons.flag, Colors.green, selected == 0),
        _getListTile('Игроки', Icons.group, Colors.blue, selected == 1),
        const Divider(),
        _getListTile('История', Icons.history, Colors.blue, selected == 2),
        _getListTile('Статистика', Icons.bar_chart, Colors.orange, selected == 3),
        const Divider(),
        _getListTile('Синхронизация', Icons.sync, Colors.blue, selected == 4),
        const Divider(),
        _getListTile('Выйти', Icons.exit_to_app, Colors.red, selected == 4),
      ],
    ),
  );
}
