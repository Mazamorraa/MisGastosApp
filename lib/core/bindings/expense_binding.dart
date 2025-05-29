import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:misgastosapp/app/data/repositories/expense_repository_impl.dart';
import 'package:misgastosapp/app/presentation/controllers/expense_controller.dart';

class ExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ExpenseRepositoryImpl(
        firestore: FirebaseFirestore.instance,
        auth: FirebaseAuth.instance,
      ),
    );
    Get.lazyPut(() => ExpenseController(repository: Get.find()));
  }
}
