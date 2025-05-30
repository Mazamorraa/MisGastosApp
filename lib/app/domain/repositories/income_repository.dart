import 'package:misgastosapp/app/data/models/income_model.dart';
import 'package:misgastosapp/app/domain/entities/income.dart';

abstract class IncomeRepository {
  Future<void> addIncome(Income income);
  Stream<List<IncomeModel>> getIncomes();
  Future<void> deleteIncome(String id);
}
