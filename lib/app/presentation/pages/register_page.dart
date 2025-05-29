import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:misgastosapp/app/presentation/controllers/auth_controller.dart';
import 'package:misgastosapp/app/presentation/widgets/auth_form.dart';

class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

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
                      Image.asset(
                        'assets/img/logo_misgastos.png',
                        width: 220,
                        height: 220,
                      ),
                      const SizedBox(height: 20),
                      AuthForm(
                        formKey: _formKey,
                        emailController: emailCtrl,
                        passwordController: passCtrl,
                        onSubmit: () {
                          if (_formKey.currentState!.validate()) {
                            controller.register(emailCtrl.text, passCtrl.text);
                          }
                        },
                        buttonText: 'Registrarse',
                        switchText: '¿Ya tienes cuenta? Inicia sesión',
                        onSwitch: () => Get.toNamed('/login'),
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
