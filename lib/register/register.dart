import 'package:flutter/material.dart';
import 'controllers.dart';
import 'name_input.dart';

import 'password_input.dart';
import 'email_input.dart';
import 'birthday_input.dart';
import 'buttons_row.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
    usernameController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);
    birthdayController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    birthdayController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {});
  }

  bool _isButtonEnabled() {
    return usernameController.text.isNotEmpty &&

           passwordController.text.isNotEmpty &&
           emailController.text.isNotEmpty &&
           birthdayController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            NameInput(),
            PasswordInput(),
            EmailInput(),
            BirthdayInput(),
            ButtonsRow(isButtonEnabled: _isButtonEnabled),
          ],
        ),
      ),
    );
  }
}