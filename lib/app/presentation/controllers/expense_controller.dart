import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:misgastosapp/app/data/models/expense_model.dart';
import 'package:misgastosapp/app/data/repositories/expense_repository_impl.dart';
import 'package:misgastosapp/app/domain/entities/expense.dart';

class ExpenseController extends GetxController {
  final ExpenseRepositoryImpl repository;

  ExpenseController({required this.repository});

  var expenses = <ExpenseModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadExpenses();
  }

  void _loadExpenses() {
    isLoading.value = true;
    repository.getExpenses().listen((data) {
      expenses.value = data;
      isLoading.value = false;
    });
  }

  Future<void> agregarGasto(Expense gasto) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await repository.addExpense(uid, gasto);
    }
  }

  Future<void> deleteExpense(String id) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await repository.firestore
          .collection('usuarios')
          .doc(uid)
          .collection('gastos')
          .doc(id)
          .delete();
    }
  }

  double get total => expenses.fold(0.0, (sum, e) => sum + e.monto);
}
