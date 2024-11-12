import 'package:flutter/material.dart';
import 'controllers.dart';

class LoginInput extends StatelessWidget {
  const LoginInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: usernameController,
      decoration: const InputDecoration(
        labelText: 'Login',
      ),
    );
  }
}