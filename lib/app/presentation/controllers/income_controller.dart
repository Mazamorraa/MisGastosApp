import 'package:get/get.dart';
import 'package:misgastosapp/app/data/models/income_model.dart';
import 'package:misgastosapp/app/domain/entities/income.dart';
import 'package:misgastosapp/app/domain/repositories/income_repository.dart';

class IncomeController extends GetxController {
  final IncomeRepository repository;

  IncomeController({required this.repository});

  var incomes = <IncomeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    repository.getIncomes().listen((data) {
      incomes.value = data;
      print('📥 Ingresos actualizados: ${data.length}');
    });
  }

  double get total => incomes.fold(0, (sum, i) => sum + i.monto);

  Future<void> agregarIngreso(Income ingreso) async {
    await repository.addIncome(ingreso);
  }

  Future<void> eliminarIngreso(String id) async {
    await repository.deleteIncome(id);
  }

  List<IncomeModel> ingresosParaFecha(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);

    return incomes.where((ing) {
      final start = DateTime(
        ing.fechaInicio.year,
        ing.fechaInicio.month,
        ing.fechaInicio.day,
      );

      if (ing.frecuencia == FrecuenciaIngreso.unico) {
        return dateOnly == start;
      }

      Duration diff = dateOnly.difference(start);

      switch (ing.frecuencia) {
        case FrecuenciaIngreso.semanal:
          return diff.inDays % 7 == 0 && !diff.isNegative;
        case FrecuenciaIngreso.quincenal:
          return diff.inDays % 15 == 0 && !diff.isNegative;
        case FrecuenciaIngreso.mensual:
          return dateOnly.day == start.day &&
              dateOnly.isAfter(start.subtract(const Duration(days: 1)));
        default:
          return false;
      }
    }).toList();
  }
}
