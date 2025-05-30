import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:misgastosapp/app/data/models/expense_model.dart';
import 'package:misgastosapp/app/data/models/income_model.dart';
import 'package:misgastosapp/app/presentation/controllers/expense_controller.dart';
import 'package:misgastosapp/app/presentation/controllers/income_controller.dart'
    show IncomeController;

class ExpenseHistoryPage extends StatelessWidget {
  final bool modoSoloLectura;
  const ExpenseHistoryPage({super.key, this.modoSoloLectura = false});

  @override
  Widget build(BuildContext context) {
    final expenseCtrl = Get.find<ExpenseController>();
    final incomeCtrl = Get.find<IncomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de movimientos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        final gastos = expenseCtrl.expenses;
        final ingresos = incomeCtrl.incomes;

        final movimientos = [
          ...gastos.map((e) => {'tipo': 'gasto', 'obj': e}),
          ...ingresos.map((e) => {'tipo': 'ingreso', 'obj': e}),
        ];

        movimientos.sort((a, b) {
          final dateA = a['tipo'] == 'gasto'
              ? (a['obj'] as ExpenseModel).fecha
              : (a['obj'] as IncomeModel).fechaInicio!;
          final dateB = b['tipo'] == 'gasto'
              ? (b['obj'] as ExpenseModel).fecha
              : (b['obj'] as IncomeModel).fechaInicio!;
          return dateB.compareTo(dateA);
        });

        if (movimientos.isEmpty) {
          return const Center(child: Text('Sin movimientos registrados'));
        }

        return ListView.builder(
          itemCount: movimientos.length,
          itemBuilder: (context, index) {
            final mov = movimientos[index];
            final tipo = mov['tipo'];

            if (tipo == 'gasto') {
              final gasto = mov['obj'] as ExpenseModel;

              return Dismissible(
                key: Key('gasto-${gasto.id ?? UniqueKey().toString()}'),
                direction: modoSoloLectura
                    ? DismissDirection.none
                    : DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('¿Eliminar gasto?'),
                      content: const Text(
                        '¿Estás seguro de que deseas eliminar este gasto? Esta acción no se puede deshacer.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) {
                  expenseCtrl.deleteExpense(gasto.id!);
                  Get.snackbar('Gasto eliminado', gasto.descripcion);
                },
                child: ListTile(
                  leading: const Icon(Icons.arrow_downward, color: Colors.red),
                  title: Text(gasto.descripcion),
                  subtitle: Text(
                    gasto.fecha.toLocal().toString().split(' ')[0],
                  ),
                  trailing: Text('-\$${gasto.monto.toStringAsFixed(2)}'),
                ),
              );
            } else {
              final ingreso = mov['obj'] as IncomeModel;

              return Dismissible(
                key: Key('ingreso-${ingreso.id ?? UniqueKey().toString()}'),
                direction: modoSoloLectura
                    ? DismissDirection.none
                    : DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('¿Eliminar ingreso?'),
                      content: const Text(
                        '¿Estás seguro de que deseas eliminar este ingreso? Esta acción no se puede deshacer.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) {
                  incomeCtrl.eliminarIngreso(ingreso.id!);
                  Get.snackbar('Ingreso eliminado', ingreso.descripcion);
                },
                child: ListTile(
                  leading: const Icon(Icons.arrow_upward, color: Colors.green),
                  title: Text(ingreso.descripcion),
                  subtitle: Text(
                    ingreso.fechaInicio!.toLocal().toString().split(' ')[0],
                  ),
                  trailing: Text('+\$${ingreso.monto.toStringAsFixed(2)}'),
                ),
              );
            }
          },
        );
      }),
    );
  }
}
