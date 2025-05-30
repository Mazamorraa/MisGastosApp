import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:misgastosapp/app/domain/entities/income.dart';

class IncomeModel extends Income {
  IncomeModel({
    String? id,
    required double monto,
    required String descripcion,
    required DateTime fechaInicio,
    required FrecuenciaIngreso frecuencia,
  }) : super(
         id: id,
         monto: monto,
         descripcion: descripcion,
         fechaInicio: fechaInicio,
         frecuencia: frecuencia,
       );

  Map<String, dynamic> toMap() {
    return {
      'monto': monto,
      'descripcion': descripcion,
      'fechaInicio': Timestamp.fromDate(fechaInicio),
      'frecuencia': frecuencia.name,
    };
  }

  factory IncomeModel.fromMap(Map<String, dynamic> map, String id) {
    return IncomeModel(
      id: id,
      monto: (map['monto'] as num).toDouble(),
      descripcion: map['descripcion'],
      fechaInicio: (map['fechaInicio'] as Timestamp).toDate(),
      frecuencia: FrecuenciaIngreso.values.firstWhere(
        (e) => e.name == map['frecuencia'],
      ),
    );
  }
}
