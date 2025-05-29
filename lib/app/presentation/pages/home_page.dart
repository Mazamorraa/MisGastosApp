import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:misgastosapp/app/data/repositories/expense_repository_impl.dart';
import 'package:misgastosapp/app/presentation/controllers/expense_controller.dart';
import 'package:misgastosapp/app/presentation/pages/add_expense_page.dart';
import 'package:misgastosapp/app/presentation/pages/calendar_page.dart';
import 'package:misgastosapp/app/presentation/pages/expense_history_page.dart';
import 'package:misgastosapp/app/presentation/controllers/theme_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late final PageController _pageController;

  final List<Widget> _pages = [
    const Center(child: Text('Bienvenido a Gastos App')),
    AddExpensePage(),
    ExpenseHistoryPage(),
    const CalendarPage(),
  ];

  final List<String> _titles = [
    'Inicio',
    'Agregar Gasto',
    'Historial',
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
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendario',
          ),
        ],
      ),
    );
  }
}
