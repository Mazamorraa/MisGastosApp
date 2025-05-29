import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final String buttonText;
  final String switchText;
  final VoidCallback onSwitch;

  const AuthForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.buttonText,
    required this.switchText,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Correo'),
              validator: (value) => value!.isEmpty ? 'Correo requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
              validator: (value) =>
                  value!.length < 6 ? 'Mínimo 6 caracteres' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onSubmit, child: Text(buttonText)),
            const SizedBox(height: 16),
            TextButton(onPressed: onSwitch, child: Text(switchText)),
          ],
        ),
      ),
    );
  }
}
