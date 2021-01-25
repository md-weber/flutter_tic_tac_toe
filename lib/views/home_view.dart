import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/provider/game_board_provider.dart';
import 'package:flutter_tic_tac_toe/views/game_board.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe the Game!"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text("Play yourself"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<GameBoardProvider>().user = "X";
                    GameBoard.navigateToGameBoard(context);
                  },
                  child: const Text("Play as X"),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<GameBoardProvider>().user = "X";
                    context.read<GameBoardProvider>().twoPlayerGame = true;
                    GameBoard.navigateToGameBoard(context);
                  },
                  child: const Text("2 Player Game"),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<GameBoardProvider>().user = "O";
                    context.read<GameBoardProvider>().aiTurn();
                    GameBoard.navigateToGameBoard(context);
                  },
                  child: const Text("Play as O"),
                )
              ],
            ),
            const SizedBox(height: 16),
            const Text("Let the AI play for you!"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<GameBoardProvider>().user = null;
                    context.read<GameBoardProvider>().aiTurn();
                    GameBoard.navigateToGameBoard(context);
                  },
                  child: const Text("AI Wars"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
