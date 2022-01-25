class Score {
  final int score;
  final String name;
  const Score(this.score, this.name);

  @override
  String toString() {
    // Pretty string represntation for a score
    return '$name: $score';
  }
}
