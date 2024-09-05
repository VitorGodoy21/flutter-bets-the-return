class House {
  String name;
  double adjustment;
  double bonusCredits;
  double initialBankroll;
  double withdrawal;
  double profit = 0;
  double openValue = 0;
  double currentBankroll = 0;
  double availableBankroll = 0;

  House({
    required this.adjustment,
    required this.bonusCredits,
    required this.initialBankroll,
    required this.name,
    required this.withdrawal});

  House.fromMap(Map<String, dynamic> map)
      : adjustment = (map["adjustment"] as num).toDouble(),
        bonusCredits = (map["bonus_credits"] as num).toDouble(),
        initialBankroll = (map["initial_bankroll"] as num).toDouble(),
        name = map["name"],
        withdrawal = (map["withdrawal"] as num).toDouble(),
        profit = 0;

  Map<String, dynamic> toMap() {
    return {
      "adjustment": adjustment,
      "bonus_credits": bonusCredits,
      "initial_bankroll": initialBankroll,
      "name": name,
      "withdrawal": withdrawal
    };
  }
}
