import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:misgastosapp/app/domain/entities/expense.dart';

class ExpenseModel extends Expense {
  ExpenseModel({
    super.id,
    required super.monto,
    required super.descripcion,
    required super.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'monto': monto,
      'descripcion': descripcion,
      'fecha': Timestamp.fromDate(fecha),
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map, String id) {
    return ExpenseModel(
      id: id,
      monto: map['monto'] is int
          ? (map['monto'] as int).toDouble()
          : map['monto'],
      descripcion: map['descripcion'],
      fecha: (map['fecha'] as Timestamp).toDate(),
    );
  }
}
