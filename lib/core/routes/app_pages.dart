import 'package:get/get.dart';
import 'package:misgastosapp/app/presentation/pages/check_session_page.dart';
import 'package:misgastosapp/app/presentation/pages/home_page.dart';
import 'package:misgastosapp/app/presentation/pages/login_page.dart';
import 'package:misgastosapp/app/presentation/pages/register_page.dart';
import 'package:misgastosapp/app/presentation/pages/welcome_page.dart';
import 'package:misgastosapp/core/bindings/initial_binding.dart';

import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.welcome;

  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(name: AppRoutes.welcome, page: () => const WelcomePage()),
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    GetPage(name: AppRoutes.check, page: () => const CheckSessionPage()),
  ];
}
