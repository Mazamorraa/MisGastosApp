import 'package:flutter/material.dart';
import 'package:misgastosapp/app/data/models/expense_model.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(expense.descripcion),
      subtitle: Text('${expense.fecha.toLocal()}'.split(' ')[0]),
      trailing: Text('\$${expense.monto.toStringAsFixed(2)}'),
    );
  }
}
