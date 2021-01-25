import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_tic_tac_toe/provider/game_board_provider.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatelessWidget {
  static Future<void> navigateToGameBoard(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GameBoard(),
    ));
    context.read<GameBoardProvider>().restartGame();
  }

  @override
  Widget build(BuildContext context) {
    final gameBoardProvider = context.watch<GameBoardProvider>();
    final activePlayer = gameBoardProvider.activePlayer;
    final user = gameBoardProvider.user;
    final boardState = gameBoardProvider.boardState;
    final gameOver = gameBoardProvider.gameOver;
    final winner = gameBoardProvider.winner;
    final isTwoPlayerGame = gameBoardProvider.twoPlayerGame;

    if (gameOver == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  context.read<GameBoardProvider>().restartGame();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("Restart"),
              ),
            ],
            content: Text(
              _getResultMessage(winner, user, isTwoPlayerGame),
            ),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Your turn $activePlayer"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GridView.builder(
                  itemCount: 9,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: isCellActive(boardState, index) &&
                              isUserActivePlayer(
                                user,
                                activePlayer,
                                isTwoPlayerGame,
                              )
                          ? () {
                              context
                                  .read<GameBoardProvider>()
                                  .userTurn(index % 3, index ~/ 3);
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        height: 50,
                        width: 50,
                        child: Center(
                            child: Text(
                          isCellActive(boardState, index)
                              ? ""
                              : boardState[index % 3][index ~/ 3].toString(),
                          style: const TextStyle(fontSize: 62),
                        )),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getResultMessage(String winner, String user, bool isTwoPlayerGame) {
    // Win Message - That announce us as winner
    // Tie Message - Nobody one
    // Lose Message - Which tells us that the player / user has not one
    if (isTwoPlayerGame && winner != null) {
      return "Congratulations $winner, you won the game";
    } else if (user != null && user == winner) {
      return "Congratulations $winner, you won the game";
    } else if (user != winner && winner != null) {
      return "The AI is unbeatable, sorry you lost. Try again!";
    } else {
      return "Tie, nobody wins";
    }
  }

  bool isCellActive(List<List<String>> boardState, int index) =>
      boardState[index % 3][index ~/ 3] == null;

  bool isUserActivePlayer(
      String user, String activePlayer, bool isTwoPlayerGame) {
    if (isTwoPlayerGame) {
      return true;
    } else {
      return user == activePlayer;
    }
  }
}
