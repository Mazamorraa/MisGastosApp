import 'package:firebase_auth/firebase_auth.dart';
import 'package:misgastosapp/app/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User?> call(String email, String password) {
    return repository.registerWithEmail(email, password);
  }
}
