import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:misgastosapp/app/data/repositories/auth_repository_impl.dart';
import 'package:misgastosapp/app/data/repositories/expense_repository_impl.dart';
import 'package:misgastosapp/app/domain/usecases/login_usecase.dart';
import 'package:misgastosapp/app/domain/usecases/register_usecase.dart';
import 'package:misgastosapp/app/presentation/controllers/auth_controller.dart';
import 'package:misgastosapp/app/presentation/controllers/expense_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Firebase
    final firebaseAuth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    // Auth
    final authRepo = AuthRepositoryImpl(firebaseAuth);
    Get.lazyPut(() => LoginUseCase(authRepo));
    Get.lazyPut(() => RegisterUseCase(authRepo));
    Get.lazyPut(
      () =>
          AuthController(loginUseCase: Get.find(), registerUseCase: Get.find()),
    );

    // Expense
    final expenseRepo = ExpenseRepositoryImpl(
      firestore: firestore,
      auth: firebaseAuth,
    );
    Get.lazyPut(() => ExpenseController(repository: expenseRepo));
  }
}
