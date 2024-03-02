import 'dart:math';

import 'package:minesweeper/board_square.dart';

class Board {
  late List<List<BoardSquare>> board;
  int rowCount = 18;
  int columnCount = 10;

  Board() {
    board = List.generate(rowCount, (i) {
      return List.generate(columnCount, (j) {
        return BoardSquare();
      });
    });
  }

  void generateBombs() {
    int bombProbability = 3;
    int maxProbability = 15;
    Random random = Random();

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (random.nextInt(maxProbability) < bombProbability) {
          board[i][j].hasBomb = true;
        }
      }
    }
  }

  void calculateBombsAround() {
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (board[i][j].hasBomb) {
          continue;
        }
        int count = 0;
        for (int ii = -1; ii <= 1; ii++) {
          for (int jj = -1; jj <= 1; jj++) {
            if (ii == 0 && jj == 0) {
              continue;
            }
            int x = i + ii;
            int y = j + jj;
            if (x < 0 || x >= rowCount || y < 0 || y >= columnCount) {
              continue;
            }
            if (board[x][y].hasBomb) {
              count++;
            }
          }
        }
        board[i][j].bombsAround = count;
      }
    }
  }

  void expandZeros(int row, int col) {
    if (row < 0 || row >= rowCount || col < 0 || col >= columnCount) {
      return;
    }
    if (board[row][col].isRevealed) {
      return;
    }
    board[row][col].isRevealed = true;
    if (board[row][col].bombsAround == 0) {
      expandZeros(row - 1, col - 1);
      expandZeros(row - 1, col);
      expandZeros(row - 1, col + 1);
      expandZeros(row, col - 1);
      expandZeros(row, col + 1);
      expandZeros(row + 1, col - 1);
      expandZeros(row + 1, col);
      expandZeros(row + 1, col + 1);
    }
  }

  void revealBombs() {
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (board[i][j].hasBomb) {
          board[i][j].isBombRevealed = true;
        }
      }
    }
  }
}
