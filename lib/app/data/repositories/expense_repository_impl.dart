import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:misgastosapp/app/data/models/expense_model.dart';

class ExpenseRepositoryImpl {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ExpenseRepositoryImpl({required this.firestore, required this.auth});

  Future<void> addExpense(ExpenseModel expense) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuario no autenticado');

    await firestore
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .add(expense.toMap());
  }

  Stream<List<ExpenseModel>> getExpenses() {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuario no autenticado');

    return firestore
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ExpenseModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }
}
