enum FrecuenciaIngreso { unico, semanal, quincenal, mensual }

class Income {
  final String? id;
  final double monto;
  final String descripcion;
  final DateTime fechaInicio;
  final FrecuenciaIngreso frecuencia;

  Income({
    this.id,
    required this.monto,
    required this.descripcion,
    required this.fechaInicio,
    required this.frecuencia,
  });
}
