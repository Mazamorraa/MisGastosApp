import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:misgastosapp/app/presentation/controllers/income_controller.dart';
import 'package:misgastosapp/app/presentation/controllers/theme_controller.dart';
import 'package:misgastosapp/core/bindings/initial_binding.dart';
import 'package:misgastosapp/core/routes/app_pages.dart';
import 'package:misgastosapp/core/routes/app_routes.dart';
import 'package:misgastosapp/core/themes/app_theme.dart';
import 'firebase_options.dart'; // generado por flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(ThemeController());
  runApp(const MyApp());
  print('IncomeController registrado: ${Get.isRegistered<IncomeController>()}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AuthBinding(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      getPages: AppPages.routes,
      initialRoute: AppRoutes.check,
    );
  }
}
