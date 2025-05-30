import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:misgastosapp/app/domain/entities/income.dart';
import 'package:misgastosapp/app/presentation/controllers/income_controller.dart';

class IncomeListPage extends StatelessWidget {
  IncomeListPage({super.key});

  final descCtrl = TextEditingController();
  final montoCtrl = TextEditingController();

  void _mostrarDialogoNuevoIngreso(BuildContext context) {
    final controller = Get.find<IncomeController>();
    final descCtrl = TextEditingController();
    final montoCtrl = TextEditingController();
    FrecuenciaIngreso frecuenciaSeleccionada = FrecuenciaIngreso.unico;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Añadir ingreso'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: montoCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Monto'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<FrecuenciaIngreso>(
                value: frecuenciaSeleccionada,
                decoration: const InputDecoration(labelText: 'Frecuencia'),
                items: FrecuenciaIngreso.values
                    .map(
                      (f) => DropdownMenuItem(
                        value: f,
                        child: Text(f.name.capitalizeFirst!),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    frecuenciaSeleccionada = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (descCtrl.text.isNotEmpty && montoCtrl.text.isNotEmpty) {
                  controller.agregarIngreso(
                    Income(
                      descripcion: descCtrl.text,
                      monto: double.parse(montoCtrl.text),
                      fechaInicio: DateTime.now(),
                      frecuencia: frecuenciaSeleccionada,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<IncomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis ingresos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _mostrarDialogoNuevoIngreso(context),
          ),
        ],
      ),
      body: Obx(() {
        print('📦 Lista de ingresos: ${controller.incomes.length}');
        if (controller.incomes.isEmpty) {
          return const Center(child: Text('No hay ingresos registrados'));
        }

        return ListView.builder(
          itemCount: controller.incomes.length,
          itemBuilder: (_, index) {
            final income = controller.incomes[index];
            return ListTile(
              title: Text(income.descripcion),
              subtitle: Text(
                '\$${income.monto.toStringAsFixed(2)} - ${income.frecuencia.name.capitalizeFirst}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  controller.eliminarIngreso(income.id!);
                  Get.snackbar('Ingreso eliminado', income.descripcion);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
