import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:misgastosapp/app/data/models/expense_model.dart';
import 'package:misgastosapp/app/domain/entities/expense.dart';

class ExpenseRepositoryImpl {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ExpenseRepositoryImpl({required this.firestore, required this.auth});

  Future<void> addExpense(String uid, Expense expense) async {
    final model = ExpenseModel(
      monto: expense.monto,
      descripcion: expense.descripcion,
      fecha: expense.fecha,
    );

    await firestore
        .collection('usuarios')
        .doc(uid)
        .collection('gastos')
        .add(model.toMap());
  }

  Future<void> deleteExpense(String id) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuario no autenticado');

    await firestore
        .collection('usuarios')
        .doc(uid)
        .collection('gastos')
        .doc(id)
        .delete();
  }

  Stream<List<ExpenseModel>> getExpenses() {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuario no autenticado');

    return firestore
        .collection('usuarios') // 🔁 corregido
        .doc(uid)
        .collection('gastos') // 🔁 corregido
        .orderBy('fecha', descending: true) // 🔁 campo correcto
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ExpenseModel.fromMap(doc.data(), doc.id),
              ) // ✅ orden corregido
              .toList(),
        );
  }
}
