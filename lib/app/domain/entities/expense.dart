class Expense {
  final String? id;
  final double monto;
  final String descripcion;
  final DateTime fecha;

  Expense({
    this.id,
    required this.monto,
    required this.descripcion,
    required this.fecha,
  });
}
