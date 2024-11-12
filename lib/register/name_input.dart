import 'package:flutter/material.dart';
import 'controllers.dart';

class NameInput extends StatelessWidget {
  const NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: usernameController,
      decoration: const InputDecoration(
        labelText: 'Name',
      ),
    );
  }
}