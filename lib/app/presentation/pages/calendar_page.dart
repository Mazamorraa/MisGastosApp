import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:misgastosapp/app/data/models/expense_model.dart';
import 'package:misgastosapp/app/data/models/income_model.dart';
import 'package:misgastosapp/app/presentation/controllers/expense_controller.dart';
import 'package:misgastosapp/app/presentation/controllers/income_controller.dart';
import 'package:misgastosapp/app/presentation/widgets/expense_tile.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<ExpenseModel>> _gastos = {};
  Map<DateTime, List<IncomeModel>> _ingresos = {};

  @override
  void initState() {
    super.initState();
    final expenseCtrl = Get.find<ExpenseController>();
    final incomeCtrl = Get.find<IncomeController>();

    _selectedDay = DateTime.now();

    ever<List<ExpenseModel>>(expenseCtrl.expenses, (_) {
      setState(() {
        _gastos = _groupExpensesByDate(expenseCtrl.expenses);
      });
    });

    ever<List<IncomeModel>>(incomeCtrl.incomes, (_) {
      setState(() {
        _ingresos = _groupIncomesByDate(incomeCtrl.incomes);
      });
    });

    _gastos = _groupExpensesByDate(expenseCtrl.expenses);
    _ingresos = _groupIncomesByDate(incomeCtrl.incomes);
  }

  DateTime onlyDate(DateTime date) => DateTime(date.year, date.month, date.day);

  Map<DateTime, List<ExpenseModel>> _groupExpensesByDate(
    List<ExpenseModel> allExpenses,
  ) {
    final Map<DateTime, List<ExpenseModel>> data = {};
    for (var e in allExpenses) {
      final date = onlyDate(e.fecha);
      data.putIfAbsent(date, () => []).add(e);
    }
    return data;
  }

  Map<DateTime, List<IncomeModel>> _groupIncomesByDate(
    List<IncomeModel> allIncomes,
  ) {
    final Map<DateTime, List<IncomeModel>> data = {};
    for (var e in allIncomes) {
      final date = onlyDate(e.fechaInicio!);
      data.putIfAbsent(date, () => []).add(e);
    }
    return data;
  }

  List<ExpenseModel> _getGastosForDay(DateTime day) =>
      _gastos[onlyDate(day)] ?? [];
  List<IncomeModel> _getIngresosForDay(DateTime day) =>
      _ingresos[onlyDate(day)] ?? [];

  @override
  Widget build(BuildContext context) {
    final selectedDay = _selectedDay ?? DateTime.now();
    final gastosDelDia = _getGastosForDay(selectedDay);
    final ingresosDelDia = _getIngresosForDay(selectedDay);

    final totalGastos = gastosDelDia.fold(0.0, (sum, e) => sum + e.monto);
    final totalIngresos = ingresosDelDia.fold(0.0, (sum, e) => sum + e.monto);
    final balance = totalIngresos - totalGastos;

    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) => [
              ..._getGastosForDay(day),
              ..._getIngresosForDay(day),
            ],
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.indigo,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: gastosDelDia.isEmpty
                ? const Center(child: Text('Sin gastos en este día'))
                : ListView.builder(
                    itemCount: gastosDelDia.length,
                    itemBuilder: (_, index) {
                      final exp = gastosDelDia[index];
                      return Dismissible(
                        key: Key(exp.id ?? UniqueKey().toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          final controller = Get.find<ExpenseController>();
                          controller.deleteExpense(
                            exp.id ?? UniqueKey().toString(),
                          );
                          Get.snackbar('Gasto eliminado', exp.descripcion);
                        },
                        child: ExpenseTile(expense: exp),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
