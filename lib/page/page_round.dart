import 'package:blitz_stat/entity/round_entity.dart';
import 'package:blitz_stat/model/round_model.dart';
import 'package:flutter/material.dart';

class RoundPage extends StatefulWidget {
  RoundEntity roundEntity;

  RoundPage({required this.roundEntity});

  @override
  State<RoundPage> createState() => _RoundPageState(roundEntity: roundEntity);
}

class _RoundPageState extends State<RoundPage> {
  bool isLoading = false;

  RoundEntity roundEntity;
  late RoundModel roundModel;

  _RoundPageState({required this.roundEntity});

  @override
  void initState() {
    super.initState();

    // refreshGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Раунд #${roundEntity.id}',
          style: const TextStyle(fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              // refreshGame();
            },
          ),
        ],
      ),
      body: const Center(child: Text('RoundPage')),
    );
  }
}
