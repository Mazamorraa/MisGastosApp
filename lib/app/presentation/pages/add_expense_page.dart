import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:misgastosapp/app/domain/entities/expense.dart';
import 'package:misgastosapp/app/presentation/controllers/expense_controller.dart';

class AddExpensePage extends StatelessWidget {
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController amountCtrl = TextEditingController();

  AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExpenseController>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: descriptionCtrl,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monto'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final desc = descriptionCtrl.text;
                final amt = double.tryParse(amountCtrl.text) ?? 0.0;

                if (desc.isNotEmpty && amt > 0) {
                  controller.agregarGasto(
                    Expense(
                      monto: double.parse(amountCtrl.text),
                      descripcion: descriptionCtrl.text,
                      fecha: DateTime.now(),
                    ),
                  );

                  Get.snackbar(
                    'Gasto agregado',
                    '$desc - \$${amt.toStringAsFixed(2)}',
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.white,
                    margin: const EdgeInsets.all(12),
                    colorText: Colors.black,
                    duration: const Duration(seconds: 2),
                  );
                  descriptionCtrl.clear();
                  amountCtrl.clear();
                }
              },
              child: const Text('Guardar Gasto'),
            ),
          ],
        ),
      ),
    );
  }
}
