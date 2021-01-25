import 'dart:math';

import 'package:tuple/tuple.dart';

class Result {
  final double value;
  final Tuple2<int, int> action;

  Result(this.value, this.action);
}

class GameService {
  final playerX = "X";
  final playerO = "O";

  bool terminal(List<List<String>> board) {
    final winningPlayer = winner(board);
    if (winningPlayer == playerX || winningPlayer == playerO) {
      return true;
    }

    for (final row in board) {
      if (row.contains(null)) {
        return false;
      }
    }

    return true;
  }

  String winner(List<List<String>> board) {
    // Check for the Row winner
    for (final row in board) {
      int xCounter = 0;
      int oCounter = 0;

      for (final cell in row) {
        if (cell == playerX) {
          xCounter++;
        } else if (cell == playerO) {
          oCounter++;
        }
      }

      if (xCounter == 3) {
        return playerX;
      } else if (oCounter == 3) {
        return playerO;
      }
    }

    // Check for the Column Winner
    for (var i = 0; i < 3; i++) {
      int columnCountX = 0;
      int columnCountO = 0;
      for (var j = 0; j < 3; j++) {
        if (board[j][i] == playerX) {
          columnCountX++;
        } else if (board[j][i] == playerO) {
          columnCountO++;
        }
      }

      if (columnCountX == 3) return playerX;
      if (columnCountO == 3) return playerO;
    }

    // Check the Diagonal Winners
    for (final actor in [playerX, playerO]) {
      final diagonalWinOne =
          board[0][0] == actor && board[1][1] == actor && board[2][2] == actor;
      final diagonalWinTwo =
          board[0][2] == actor && board[1][1] == actor && board[2][0] == actor;

      if (diagonalWinOne || diagonalWinTwo) {
        return actor;
      }
    }
    return null;
  }

  double utility(List<List<String>> board) {
    final winningPlayer = winner(board);
    if (winningPlayer == playerX) {
      return 1;
    } else if (winningPlayer == playerO) {
      return -1;
    } else {
      return 0;
    }
  }

  Tuple2<int, int> miniMax(List<List<String>> boardState, String activePlayer) {
    if (activePlayer == playerX) {
      return maxValue(boardState).action;
    }

    return minValue(boardState).action;
  }

  Result maxValue(List<List<String>> boardState) {
    if (terminal(boardState)) {
      return Result(utility(boardState), null);
    }
    double v = -double.infinity;
    Tuple2<int, int> highestValuedAction;
    for (final action in actions(boardState)) {
      final lowResult = minValue(result(boardState, action));
      if (v != max(v, lowResult.value)) {
        highestValuedAction = action;
      }

      v = max(v, lowResult.value);
    }

    return Result(v, highestValuedAction);
  }

  Result minValue(List<List<String>> boardState) {
    if (terminal(boardState)) {
      return Result(utility(boardState), null);
    }

    double v = double.infinity;
    Tuple2<int, int> lowestValuedAction;

    for (final action in actions(boardState)) {
      final maxResult = maxValue(result(boardState, action));
      if (v != min(v, maxResult.value)) {
        lowestValuedAction = action;
      }

      v = min(v, maxResult.value);
    }
    return Result(v, lowestValuedAction);
  }

  Set<Tuple2<int, int>> actions(List<List<String>> boardState) {
    final Set<Tuple2<int, int>> possibleActions = {};

    for (var i = 0; i < boardState.length; i++) {
      for (var j = 0; j < boardState[i].length; j++) {
        if (boardState[i][j] == null) {
          possibleActions.add(Tuple2(i, j));
        }
      }
    }
    return possibleActions;
  }

  List<List<String>> result(
    List<List<String>> boardState,
    Tuple2<int, int> action,
  ) {
    if (boardState[action.item1][action.item2] != null) {
      throw ArgumentError("This cell is already used");
    }

    final String currentPlayer = getActivePlayer(boardState);

    final List<List<String>> newState = [];

    for (int i = 0; i < boardState.length; i++) {
      newState.add([]);
      for (int j = 0; j < boardState.length; j++) {
        newState[i].add(boardState[i][j]);
      }
    }

    newState[action.item1][action.item2] = currentPlayer;
    return newState;
  }

  String getActivePlayer(List<List<String>> boardState) {
    int countO = 0;
    int countX = 0;
    for (final row in boardState) {
      for (final cell in row) {
        if (cell == "O") countO++;
        if (cell == "X") countX++;
      }
    }

    return countO == 0 && countX == 0 || countO == countX ? playerX : playerO;
  }
}
