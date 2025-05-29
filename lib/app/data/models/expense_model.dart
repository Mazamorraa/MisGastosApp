class ExpenseModel {
  final String id;
  final String description;
  final double amount;
  final DateTime date;

  ExpenseModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory ExpenseModel.fromMap(String id, Map<String, dynamic> map) {
    return ExpenseModel(
      id: id,
      description: map['description'],
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date']),
    );
  }
}
