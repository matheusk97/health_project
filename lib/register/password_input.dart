import 'package:flutter/material.dart';
import 'controllers.dart';
import 'package:fancy_password_field/fancy_password_field.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    return FancyPasswordField(
      controller: passwordController,
      decoration: const InputDecoration(
        labelText: 'Password',
      ),
    );
  }
}