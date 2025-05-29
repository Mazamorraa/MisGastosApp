import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:misgastosapp/app/presentation/controllers/auth_controller.dart';
import 'package:misgastosapp/app/presentation/widgets/auth_form.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoPath = isDark
        ? 'assets/img/logo_misgastos_dark.png'
        : 'assets/img/logo_misgastos.png';

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      Image.asset(logoPath, height: 400),
                      const SizedBox(height: 20),
                      AuthForm(
                        formKey: _formKey,
                        emailController: emailCtrl,
                        passwordController: passCtrl,
                        onSubmit: () {
                          if (_formKey.currentState!.validate()) {
                            controller.login(emailCtrl.text, passCtrl.text);
                          }
                        },
                        buttonText: 'Ingresar',
                        switchText: '¿No tienes cuenta? Regístrate',
                        onSwitch: () => Get.toNamed('/register'),
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
