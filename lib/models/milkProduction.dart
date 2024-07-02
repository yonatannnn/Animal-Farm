class MilkProductionEntry {
  DateTime date;
  double amount;

  MilkProductionEntry({required this.date, required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'amount': amount,
    };
  }

  static MilkProductionEntry fromMap(Map<String, dynamic> map) {
    return MilkProductionEntry(
      date: DateTime.parse(map['date']),
      amount: map['amount'],
    );
  }
}
