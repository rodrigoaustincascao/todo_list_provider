import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get primaryColorLight => Theme.of(this).primaryColorLight;

  // Cor de botões (substituta de buttonColor, que foi removida)
  Color get buttonColor => Theme.of(this).colorScheme.primary;

  // Tema de texto
  TextTheme get textTheme => Theme.of(this).textTheme;

  TextStyle get titleStyle =>
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey);
}
