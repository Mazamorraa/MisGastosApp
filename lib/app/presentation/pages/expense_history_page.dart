import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:misgastosapp/app/presentation/controllers/expense_controller.dart';

class ExpenseHistoryPage extends StatelessWidget {
  const ExpenseHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExpenseController>();

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.expenses.isEmpty) {
          return const Center(child: Text('No hay gastos registrados.'));
        }

        return ListView.builder(
          itemCount: controller.expenses.length,
          itemBuilder: (context, index) {
            final exp = controller.expenses[index];
            return Dismissible(
              key: Key(exp.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) {
                controller.deleteExpense(exp.id);
                Get.snackbar('Gasto eliminado', exp.description);
              },
              child: ListTile(
                title: Text(exp.description),
                subtitle: Text('${exp.date.toLocal()}'.split(' ')[0]),
                trailing: Text('\$${exp.amount.toStringAsFixed(2)}'),
              ),
            );
          },
        );
      }),
    );
  }
}
