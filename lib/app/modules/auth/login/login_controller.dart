import 'package:todo_list_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/exception/auth_exceptions.dart';
import 'package:todo_list_provider/app/services/user_service.dart';

class LoginController extends DefaultChangeNotifier {
  final UserService _userService;
  String? infoMessage;

  LoginController({required UserService userService})
    : _userService = userService;

  bool get hasInfo => infoMessage != null;

  Future<void> googleLogin() async {
    showLoadingAndResetState();
    infoMessage = null;
    notifyListeners();
    try {
      final user = await _userService.googleLogin();

      if (user != null) {
        success();
      } else {
        await _userService.logout();
        setError('Erro ao efetuar login');
      }
    } on AuthExceptions catch (e) {
      await _userService.logout();
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  void login(String email, String password) async {
    showLoadingAndResetState();
    infoMessage = null;
    notifyListeners();
    try {
      final user = await _userService.login(email, password);

      if (user != null) {
        success();
      } else {
        setError('Usuário ou senha inválidos');
      }
    } on AuthExceptions catch (e) {
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();

      await _userService.forgotPassword(email);
      infoMessage = 'Reset de senha enviado para seu e-mail';
    } on AuthExceptions catch (e) {
      setError(e.message);
    } catch (e) {
      setError('Erro ao resetar senha');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
