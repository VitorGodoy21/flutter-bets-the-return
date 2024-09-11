class Author {
  String name;
  String alias;
  double profit;
  double profitInBetUnit;
  int totalBets;
  int totalGreen;
  int totalRed;
  int totalOpen;
  int totalVoid;
  int totalCashout;

  Author(
      {required this.name,
      required this.alias,
      required this.profit,
      required this.profitInBetUnit,
      required this.totalBets,
      required this.totalGreen,
      required this.totalRed,
      required this.totalOpen,
      required this.totalVoid,
      required this.totalCashout});

  Author.fromMap(Map<String, dynamic> map)
      : name = map["name"],
        alias = map["alias"],
        profit = 0,
        profitInBetUnit = 0,
        totalBets = 0,
        totalGreen = 0,
        totalRed = 0,
        totalOpen = 0,
        totalVoid = 0,
        totalCashout = 0;

  Map<String, dynamic> toMap() {
    return {"name": name, "alias": alias};
  }
}
