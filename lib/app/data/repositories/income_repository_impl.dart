import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:misgastosapp/app/domain/repositories/income_repository.dart';
import '../../domain/entities/income.dart';
import '../models/income_model.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  IncomeRepositoryImpl({required this.firestore, required this.auth});

  @override
  Future<void> addIncome(Income income) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuario no autenticado');

    final model = IncomeModel(
      monto: income.monto,
      descripcion: income.descripcion,
      fechaInicio: income.fechaInicio,
      frecuencia: income.frecuencia,
    );

    await firestore
        .collection('usuarios')
        .doc(uid)
        .collection('ingresos')
        .add(model.toMap());
  }

  @override
  Future<void> deleteIncome(String id) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuario no autenticado');

    await firestore
        .collection('usuarios')
        .doc(uid)
        .collection('ingresos')
        .doc(id)
        .delete();
  }

  @override
  Stream<List<IncomeModel>> getIncomes() {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuario no autenticado');

    return firestore
        .collection('usuarios')
        .doc(uid)
        .collection('ingresos')
        .orderBy('fechaInicio', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => IncomeModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
