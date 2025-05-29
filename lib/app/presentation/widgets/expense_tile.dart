import 'package:flutter/material.dart';
import 'package:misgastosapp/app/data/models/expense_model.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(expense.description),
      subtitle: Text('${expense.date.toLocal()}'.split(' ')[0]),
      trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
    );
  }
}
