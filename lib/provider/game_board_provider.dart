import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tic_tac_toe/services/game_service.dart';
import 'package:tuple/tuple.dart';

class GameBoardProvider extends ChangeNotifier {
  GameService service;

  GameBoardProvider({this.service});

  List<List<String>> _boardState = [
    [null, null, null],
    [null, null, null],
    [null, null, null]
  ];

  final playerX = "X";
  final playerO = "O";

  String user;
  bool twoPlayerGame = false;
  String _activePlayer = "X";
  bool _gameOver = false;
  String _winner;
  StreamSubscription _streamSubscription;

  List<List<String>> get boardState => _boardState;

  String get activePlayer => _activePlayer;

  bool get gameOver => _gameOver;

  String get winner => _winner;

  Future<void> aiTurn() async {
    _streamSubscription = Stream.fromFuture(
      Future.delayed(const Duration(milliseconds: 500)),
    ).listen((event) {
      final Tuple2<int, int> move = service.miniMax(_boardState, _activePlayer);
      if (_gameOver != true) turn(move.item1, move.item2);
      if (user == null) aiTurn();
    });
  }

  void userTurn(int ix, int iy) {
    turn(ix, iy);
    if (_gameOver != true && !twoPlayerGame) aiTurn();
  }

  void turn(int ix, int jy) {
    _boardState[ix][jy] = _activePlayer;

    if (service.terminal(_boardState)) {
      _gameOver = true;
      _winner = service.winner(_boardState);
    } else {
      switchPlayers();
    }

    notifyListeners();
  }

  void switchPlayers() {
    if (_activePlayer == "X") {
      _activePlayer = "O";
    } else {
      _activePlayer = "X";
    }
  }

  void restartGame() {
    user = null;
    _activePlayer = playerX;
    _boardState = [
      [null, null, null],
      [null, null, null],
      [null, null, null]
    ];
    _winner = null;
    _gameOver = false;
    twoPlayerGame = false;
    _streamSubscription.cancel();
  }
}
