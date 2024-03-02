class BoardSquare {
  bool hasBomb;
  int bombsAround;
  bool isRevealed;
  bool isBombRevealed;
  BoardSquare(
      {this.hasBomb = false,
      this.bombsAround = 0,
      this.isRevealed = false,
      this.isBombRevealed = false});
}
