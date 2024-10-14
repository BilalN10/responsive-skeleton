import 'package:flutter/material.dart';

/// Theme of the [ProfilButton] Widget.
///
/// {@category Theme}
class ProfilButtonThemeData {
  /// TextStyle du nom / prénom de l'utilisateur
  /// @Default: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)
  final TextStyle nameStyle;

  /// TextStyle du mail de l'utilisateur
  /// @Default: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF808080))
  final TextStyle emailStyle;

  /// Size de l'image de profil.
  /// @Default: `50`
  final double imageSize;

  const ProfilButtonThemeData({
    this.nameStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
    this.emailStyle = const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF808080)),
    this.imageSize = 50,
  });
}
