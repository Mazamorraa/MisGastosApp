import 'package:get/get.dart';
import 'package:misgastosapp/app/data/models/expense_model.dart';
import 'package:misgastosapp/app/data/repositories/expense_repository_impl.dart';

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

  Future<void> addExpense(String description, double amount) async {
    final expense = ExpenseModel(
      id: '', // Firestore lo asigna
      description: description,
      amount: amount,
      date: DateTime.now(),
    );

    await repository.addExpense(expense);
  }

  Future<void> deleteExpense(String id) async {
    final uid = repository.auth.currentUser?.uid;
    if (uid == null) return;

    await repository.firestore
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .doc(id)
        .delete();
  }
}
