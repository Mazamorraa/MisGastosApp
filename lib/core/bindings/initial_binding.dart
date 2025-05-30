import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:misgastosapp/app/data/repositories/auth_repository_impl.dart';
import 'package:misgastosapp/app/data/repositories/expense_repository_impl.dart';
import 'package:misgastosapp/app/data/repositories/income_repository_impl.dart';
import 'package:misgastosapp/app/domain/repositories/auth_repository.dart';
import 'package:misgastosapp/app/domain/repositories/income_repository.dart';
import 'package:misgastosapp/app/domain/usecases/login_usecase.dart';
import 'package:misgastosapp/app/domain/usecases/register_usecase.dart';
import 'package:misgastosapp/app/presentation/controllers/auth_controller.dart';
import 'package:misgastosapp/app/presentation/controllers/expense_controller.dart';
import 'package:misgastosapp/app/presentation/controllers/income_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    final authRepo = AuthRepositoryImpl(auth, firestore);
    Get.lazyPut<AuthRepository>(() => authRepo);
    Get.lazyPut(() => LoginUseCase(authRepo));
    Get.lazyPut(() => RegisterUseCase(authRepo));
    Get.lazyPut(
      () =>
          AuthController(loginUseCase: Get.find(), registerUseCase: Get.find()),
    );

    final incomeRepo = IncomeRepositoryImpl(firestore: firestore, auth: auth);
    Get.lazyPut<IncomeRepository>(() => incomeRepo);
    Get.lazyPut(() => IncomeController(repository: incomeRepo));

    final expenseRepo = ExpenseRepositoryImpl(firestore: firestore, auth: auth);
    Get.lazyPut(() => ExpenseController(repository: expenseRepo));
  }
}
