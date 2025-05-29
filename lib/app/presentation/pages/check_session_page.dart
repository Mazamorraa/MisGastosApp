import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckSessionPage extends StatelessWidget {
  const CheckSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Esperando a que Firebase determine el estado de sesión
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          Future.microtask(() => Get.offAllNamed('/home'));
        } else {
          Future.microtask(() => Get.offAllNamed('/login'));
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
