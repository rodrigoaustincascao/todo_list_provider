import 'package:flutter/material.dart';

class DefaultChangeNotifier extends ChangeNotifier {
  bool _loading = false;
  String? _error;
  bool _success = false;

  void success() => _success = true;
  void clearSuccess() => _success = false;

  bool get loading => _loading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get isSuccess => _success;

  void showLoading() => _loading = true;
  void hideLoading() => _loading = false;

  void setError(String? error) => _error = error;
  void clearError() => _error = null;

  void showLoadingAndResetState() {
    showLoading();
    resetState();
  }

  void resetState() {
    setError(null);
    _success = false;
  }
}
