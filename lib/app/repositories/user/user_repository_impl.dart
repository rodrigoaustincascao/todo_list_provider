import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list_provider/app/exception/auth_exceptions.dart';
import 'package:todo_list_provider/app/repositories/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw AuthExceptions(
          message:
              "Este e-mail já está cadastrado. Por favor, tente fazer login ou utilize um e-mail diferente.",
        );
      } else {
        throw AuthExceptions(
          message: e.message ?? "Erro ao registrar usuário. Código: ${e.code}",
        );
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on PlatformException catch (e) {
      throw AuthExceptions(message: e.message ?? "Erro ao fazer login.");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw AuthExceptions(message: e.message ?? "Erro ao fazer login.");
      }
    }
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Esta mensagem cobre tanto e-mails não registrados quanto e-mails
        // registrados apenas com provedores OAuth (como Google), pois
        // sendPasswordResetEmail não se aplica a eles.
        throw AuthExceptions(
          message:
              "E-mail não cadastrado ou não associado a um login por senha.",
        );
      } else if (e.code == 'invalid-email') {
        throw AuthExceptions(message: "Formato de e-mail inválido.");
      } else if (e.code == 'missing-email') {
        throw AuthExceptions(message: "O campo e-mail é obrigatório.");
      } else {
        throw AuthExceptions(
          message: e.message ?? 'Erro ao resetar a senha. Código: ${e.code}',
        );
      }
    } on PlatformException catch (e) {
      throw AuthExceptions(
        message: e.message ?? 'Erro de comunicação ao tentar resetar a senha.',
      );
    } catch (e) {
      throw AuthExceptions(
        message: 'Ocorreu um erro inesperado ao tentar resetar a senha.',
      );
    }
  }

  @override
  Future<User?> googleLogin() async {
    final googleSignIn = GoogleSignIn();
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCredential = await _firebaseAuth.signInWithCredential(
          credential,
        );
        return userCredential.user;
      }
      return null; // Usuário cancelou o login do Google
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw AuthExceptions(
          message:
              'Este e-mail já está associado a outro método de login. Por favor, tente o login padrão ou o método associado.',
        );
      } else {
        rethrow; // Lança outras exceções para serem tratadas em níveis superiores.
      }
    }
  }
}
