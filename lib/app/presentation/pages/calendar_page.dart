import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:misgastosapp/app/data/models/expense_model.dart';
import 'package:misgastosapp/app/presentation/controllers/expense_controller.dart';
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
  Map<DateTime, List<ExpenseModel>> _events = {};

  @override
  void initState() {
    super.initState();

    final controller = Get.find<ExpenseController>();
    _selectedDay = DateTime.now();

    ever<List<ExpenseModel>>(controller.expenses, (_) {
      setState(() {
        _events = _groupExpensesByDate(controller.expenses);
      });
    });

    _events = _groupExpensesByDate(controller.expenses);
  }

  DateTime onlyDate(DateTime date) => DateTime(date.year, date.month, date.day);

  Map<DateTime, List<ExpenseModel>> _groupExpensesByDate(
    List<ExpenseModel> allExpenses,
  ) {
    final Map<DateTime, List<ExpenseModel>> data = {};
    for (var exp in allExpenses) {
      final date = onlyDate(exp.date);
      data.putIfAbsent(date, () => []).add(exp);
    }
    return data;
  }

  List<ExpenseModel> _getEventsForDay(DateTime day) {
    return _events[onlyDate(day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final expensesToday = _getEventsForDay(_selectedDay ?? DateTime.now());
    final total = expensesToday.fold<double>(
      0.0,
      (sum, item) => sum + item.amount,
    );

    return Scaffold(
      body: Column(
        children: [
          TableCalendar<ExpenseModel>(
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Total del día: \$${total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: expensesToday.isEmpty
                ? const Center(child: Text('Sin gastos en este día'))
                : ListView.builder(
                    itemCount: expensesToday.length,
                    itemBuilder: (_, index) {
                      final exp = expensesToday[index];
                      return Dismissible(
                        key: Key(exp.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          final controller = Get.find<ExpenseController>();
                          controller.deleteExpense(exp.id);
                          Get.snackbar('Gasto eliminado', exp.description);
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
