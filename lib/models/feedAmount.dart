class FeedAmount {
  String ingredient;
  double amount;

  FeedAmount({required this.ingredient, required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'ingredient': ingredient,
      'amount': amount,
    };
  }

  static FeedAmount fromMap(Map<String, dynamic> map) {
    return FeedAmount(
      ingredient: map['ingredient'],
      amount: map['amount'],
    );
  }
}
