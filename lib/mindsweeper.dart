import 'package:flutter/material.dart';
import 'package:minesweeper/board.dart';

class Minesweeper extends StatefulWidget {
  const Minesweeper({super.key});

  @override
  State<StatefulWidget> createState() => _MinesweeperState();
}

class _MinesweeperState extends State<Minesweeper> {
  Board board = Board();

  @override
  void initState() {
    super.initState();
    board.generateBombs();
    board.calculateBombsAround();
  }

  void resetGame() {
    setState(() {
      board = Board();
      board.generateBombs();
      board.calculateBombsAround();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minesweeper',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Minesweeper'),
          actions: [
            IconButton(onPressed: resetGame, icon: const Icon(Icons.refresh))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: board.rowCount * board.columnCount,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: board.columnCount,
                ),
                itemBuilder: (BuildContext context, int index) {
                  int row = index ~/ board.columnCount;
                  int col = index % board.columnCount;
                  return _buildGridViewItem(row, col);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridViewItem(int row, int col) {
    return GestureDetector(
      onTap: () {
        if (board.board[row][col].hasBomb) {
          setState(() {
            board.revealBombs();
            board.board[row][col].isBombRevealed = true;
          });
        } else {
          setState(() {
            if (board.board[row][col].bombsAround == 0) {
              board.expandZeros(row, col);
            } else {
              board.board[row][col].isRevealed = true;
            }
          });
        }
      },
      child: _buildSquareContent(row, col),
    );
  }

  Widget _buildSquareContent(int row, int col) {
    return Container(
      decoration: BoxDecoration(
        color: board.board[row][col].isRevealed
            ? Colors.white
            : Colors.grey.withAlpha(50),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: board.board[row][col].isBombRevealed
            ? const Icon(
                Icons.circle,
                color: Colors.red,
              )
            : Text(
                board.board[row][col].isRevealed
                    ? board.board[row][col].bombsAround.toString()
                    : '',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: board.board[row][col].isRevealed &&
                            board.board[row][col].bombsAround == 0
                        ? Colors.white
                        : Colors.black),
              ),
      ),
    );
  }
}
