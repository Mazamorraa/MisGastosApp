import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:misgastosapp/app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._auth, this._firestore);

  @override
  Future<User> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user!;
  }

  @override
  Future<User> register(
    String email,
    String password,
    String nombre,
    int edad,
    String pais,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;

    await _firestore.collection('usuarios').doc(uid).set({
      'nombre': nombre,
      'correo': email,
      'edad': edad,
      'pais': pais,
      'creado': FieldValue.serverTimestamp(),
    });
    print('Usuario guardado en Firestore');

    return cred.user!;
  }
}
