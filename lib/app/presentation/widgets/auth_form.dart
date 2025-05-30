import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? nombreController;
  final TextEditingController? edadController;
  final TextEditingController? paisController;

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
    this.nombreController,
    this.edadController,
    this.paisController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          if (nombreController != null) ...[
            TextFormField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre completo'),
              validator: (value) => value!.isEmpty ? 'Ingrese su nombre' : null,
            ),
            const SizedBox(height: 10),
          ],
          if (edadController != null) ...[
            TextFormField(
              controller: edadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Edad'),
              validator: (value) => value!.isEmpty ? 'Ingrese su edad' : null,
            ),
            const SizedBox(height: 10),
          ],
          if (paisController != null) ...[
            TextFormField(
              controller: paisController,
              decoration: const InputDecoration(labelText: 'País'),
              validator: (value) => value!.isEmpty ? 'Ingrese su país' : null,
            ),
            const SizedBox(height: 10),
          ],
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Correo electrónico'),
            validator: (value) => value!.isEmpty ? 'Ingrese su correo' : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Contraseña'),
            validator: (value) =>
                value!.length < 6 ? 'Mínimo 6 caracteres' : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: onSubmit, child: Text(buttonText)),
          TextButton(onPressed: onSwitch, child: Text(switchText)),
        ],
      ),
    );
  }
}
