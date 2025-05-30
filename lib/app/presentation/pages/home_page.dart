import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:misgastosapp/app/data/repositories/expense_repository_impl.dart';
import 'package:misgastosapp/app/data/repositories/income_repository_impl.dart';
import 'package:misgastosapp/app/domain/entities/income.dart';
import 'package:misgastosapp/app/presentation/controllers/expense_controller.dart';
import 'package:misgastosapp/app/presentation/controllers/income_controller.dart';
import 'package:misgastosapp/app/presentation/controllers/theme_controller.dart';
import 'package:misgastosapp/app/presentation/pages/add_expense_page.dart';
import 'package:misgastosapp/app/presentation/pages/calendar_page.dart';
import 'package:misgastosapp/app/presentation/pages/expense_history_page.dart';
import 'package:misgastosapp/app/presentation/pages/income_list_page.dart';
import 'package:misgastosapp/app/presentation/widgets/chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late final PageController _pageController;

  final List<Widget> _pages = [
    _HomeContent(),
    AddExpensePage(),
    //ExpenseHistoryPage(),
    const CalendarPage(),
  ];

  final List<String> _titles = [
    'Inicio',
    'Agregar Gasto',
    //'Historial',
    'Calendario',
  ];

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<ExpenseController>()) {
      final firestore = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;
      final repo = ExpenseRepositoryImpl(firestore: firestore, auth: auth);
      Get.put(ExpenseController(repository: repo));
    }

    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    if (index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Container(
                alignment: Alignment.center,
                constraints: const BoxConstraints.expand(height: 160),
                child: Builder(
                  builder: (context) {
                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    final logoPath = isDark
                        ? 'assets/img/logo_misgastos_dark.png'
                        : 'assets/img/logo_misgastos.png';

                    return Image.asset(
                      logoPath,
                      width: 540,
                      height: 540,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () => _onItemTapped(0),
            ),
            const Divider(),
            Obx(() {
              final themeCtrl = Get.find<ThemeController>();
              return SwitchListTile(
                title: const Text('Modo oscuro'),
                value: themeCtrl.isDark,
                onChanged: (_) => themeCtrl.toggleTheme(),
                secondary: const Icon(Icons.brightness_6),
              );
            }),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Agregar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendario',
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseCtrl = Get.isRegistered<ExpenseController>()
        ? Get.find<ExpenseController>()
        : Get.put(
            ExpenseController(
              repository: ExpenseRepositoryImpl(
                firestore: FirebaseFirestore.instance,
                auth: FirebaseAuth.instance,
              ),
            ),
          );

    final incomeCtrl = Get.isRegistered<IncomeController>()
        ? Get.find<IncomeController>()
        : Get.put(
            IncomeController(
              repository: IncomeRepositoryImpl(
                firestore: FirebaseFirestore.instance,
                auth: FirebaseAuth.instance,
              ),
            ),
          );

    return Obx(() {
      final totalIngresos = incomeCtrl.total;
      final totalGastos = expenseCtrl.total;
      final balance = totalIngresos - totalGastos;

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // Puedes cambiar el color aquí después
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingresos',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat', // Cambia aquí la fuente
                        letterSpacing: 1.2,
                        fontSize: 20,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(1, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${totalIngresos.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat', // Cambia aquí la fuente
                            fontSize: 32,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(2, 3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total con balance',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat', // Cambia aquí la fuente
                        letterSpacing: 1.2,
                        fontSize: 20,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(1, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${balance.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat', // Cambia aquí la fuente
                            fontSize: 32,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(2, 3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  // Quitamos el borde exterior
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_card),
                          onPressed: () => _mostrarDialogoIngreso(context),
                        ),
                        const Text('Añadir', textAlign: TextAlign.center),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.wallet),
                          onPressed: () => Get.to(() => IncomeListPage()),
                        ),
                        const Text('Gestionar', textAlign: TextAlign.center),
                      ],
                    ),

                    SizedBox(width: 10),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.history),
                          onPressed: () {
                            if (!Get.isRegistered<ExpenseController>()) {
                              final firestore = FirebaseFirestore.instance;
                              final auth = FirebaseAuth.instance;
                              final repo = ExpenseRepositoryImpl(
                                firestore: firestore,
                                auth: auth,
                              );
                              Get.put(ExpenseController(repository: repo));
                            }

                            Get.to(
                              () => ExpenseHistoryPage(modoSoloLectura: false),
                            );
                          },
                        ),
                        const Text('Historial', textAlign: TextAlign.center),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
              Text(
                'Grafica de balance:',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat', // Cambia aquí la fuente
                  letterSpacing: 1.2,
                  fontSize: 20,

                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(1, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              BalanceChart(ingresos: totalIngresos, gastos: totalGastos),
            ],
          ),
        ),
      );
    });
  }

  void _mostrarDialogoIngreso(BuildContext context) {
    final descCtrl = TextEditingController();
    final montoCtrl = TextEditingController();
    final incomeCtrl = Get.find<IncomeController>();
    FrecuenciaIngreso frecuenciaSeleccionada = FrecuenciaIngreso.unico;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo ingreso'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: montoCtrl,
              decoration: const InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<FrecuenciaIngreso>(
              value: frecuenciaSeleccionada,
              items: FrecuenciaIngreso.values
                  .map(
                    (f) => DropdownMenuItem(
                      value: f,
                      child: Text(f.name.capitalizeFirst!),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                frecuenciaSeleccionada = value!;
              },
              decoration: const InputDecoration(labelText: 'Frecuencia'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (descCtrl.text.isNotEmpty && montoCtrl.text.isNotEmpty) {
                incomeCtrl.agregarIngreso(
                  Income(
                    descripcion: descCtrl.text,
                    monto: double.parse(montoCtrl.text),
                    fechaInicio: DateTime.now(),
                    frecuencia: frecuenciaSeleccionada,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
