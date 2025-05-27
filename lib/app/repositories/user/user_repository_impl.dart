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
    return null;
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
    print('[UserRepositoryImpl] Iniciando googleLogin...');
    try {
      print('[UserRepositoryImpl] Chamando googleSignIn.signIn()...');
      final googleUser = await googleSignIn.signIn();
      print('[UserRepositoryImpl] googleUser: $googleUser');

      if (googleUser != null) {
        print(
          '[UserRepositoryImpl] googleUser não é nulo. Obtendo autenticação...',
        );
        final googleAuth = await googleUser.authentication;
        print(
          '[UserRepositoryImpl] googleAuth (accessToken: ${googleAuth.accessToken != null}, idToken: ${googleAuth.idToken != null})',
        );

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        print('[UserRepositoryImpl] Credencial do Google Provider criada.');

        print(
          '[UserRepositoryImpl] Chamando _firebaseAuth.signInWithCredential...',
        );
        final userCredential = await _firebaseAuth.signInWithCredential(
          credential,
        );
        print(
          '[UserRepositoryImpl] signInWithCredential bem-sucedido. User: ${userCredential.user}',
        );
        return userCredential.user;
      }
      print(
        '[UserRepositoryImpl] googleUser é nulo. Usuário pode ter cancelado o login.',
      );
      return null;
    } on FirebaseAuthException catch (e, s) {
      print(
        '[UserRepositoryImpl] FirebaseAuthException: ${e.code} - ${e.message}',
      );
      print(s);
      if (e.code == 'account-exists-with-different-credential') {
        throw AuthExceptions(
          message:
              'Este e-mail já está associado a outro método de login. Por favor, tente o login padrão ou o método associado.',
        );
      } else {
        throw AuthExceptions(
          message:
              'Erro do Firebase Auth durante o login com Google: ${e.message} (Código: ${e.code})',
        );
      }
    } on PlatformException catch (e, s) {
      print('[UserRepositoryImpl] PlatformException: ${e.code} - ${e.message}');
      print(s);
      throw AuthExceptions(
        message:
            'Erro de plataforma durante o login com Google: ${e.message ?? "Erro desconhecido da plataforma."}',
      );
    } catch (e, s) {
      print('[UserRepositoryImpl] Erro genérico em googleLogin: $e');
      print(s);
      throw AuthExceptions(
        message: 'Ocorreu um erro inesperado durante o login com Google.',
      );
    }
  }

  @override
  Future<void> updateDisplayName(String name) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      user.reload();
    }
  }
}
