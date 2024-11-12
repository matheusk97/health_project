import 'package:flutter/material.dart';
import 'controllers.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
    );
  }
}