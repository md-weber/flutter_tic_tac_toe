import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/provider/game_board_provider.dart';
import 'package:flutter_tic_tac_toe/services/game_service.dart';
import 'package:flutter_tic_tac_toe/views/home_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return GameBoardProvider(service: GameService());
      },
      child: MaterialApp(
        title: 'TicTacToe in Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeView(),
      ),
    );
  }
}
