import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:misgastosapp/app/domain/usecases/login_usecase.dart';
import 'package:misgastosapp/app/domain/usecases/register_usecase.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  var isLoading = false.obs;
  var user = Rxn<User>();

  AuthController({required this.loginUseCase, required this.registerUseCase});

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      user.value = await loginUseCase(email, password);
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String email,
    String password,
    String nombre,
    int edad,
    String pais,
  ) async {
    try {
      isLoading.value = true;
      user.value = await registerUseCase(email, password, nombre, edad, pais);
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
