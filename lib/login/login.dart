import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:health_project/forgotpassword.dart';
import 'package:health_project/home/home.dart';
import 'package:health_project/login/controllers.dart';
import 'package:health_project/register/register.dart';
import 'login_input.dart';
import 'password_input.dart';
import 'buttons_row.dart';  

void main() {
  runApp(
    const MaterialApp(
      title: "Login Screen",
      home: LoginScreen(),
    ),
  );
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Final Login',
      initialRoute: '/',
      routes: {'/register': (context) => RegisterScreen(),
               '/forgotpassword': (context) => const ForgotPasswordPage(),
               '/home': (context) => HomeScreen(username: '', user_id: 0)
               },
      home: Scaffold(
        appBar: AppBar(
            title: const Center(
          child: Text("Entre com sua conta"),
        )),
        body: ListView(
          children: <Widget>[
            LoginInput(),
            PasswordInput(),
            ButtonsRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginInput() {
    return const Row(
      children: [
        // Text(
        //   'Label:',
        //   style: TextStyle(fontSize: 18),
        // ),
        SizedBox(width: 0), // Espaço entre o texto e o TextField
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Login',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordInput() {
    return const Row(
      children: [
        // Text(
        //   'Label:',
        //   style: TextStyle(fontSize: 18),
        // ),
        SizedBox(width: 0), // Espaço entre o texto e o TextField
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Senha',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              sendLoginRequest(context);
              print('Login button pressed');
            },
            child: const Text('Login'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
            child: const Text('Register'),
          ),
        ),
      ],
    );
  }
  
  void sendLoginRequest(context) async {
              final login = usernameController.text;
              final senha = passwordController.text;

              final response = await http.post(
                Uri.parse('http://localhost:5000/login'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, String>{
                  'login': login,
                  'senha': senha,
                }),
              );

              if (response.statusCode == 200) {
                // If the server returns a 200 OK response, parse the JSON.
                // final data = jsonDecode(response.body);
                Navigator.pushNamed(context, '/register');
                // Handle successful login
              } else {
                // If the server did not return a 200 OK response, throw an exception.
                throw Exception('Failed to login');
              }
  }

}

Widget _buildForgotPasswordRow(BuildContext context) {
  return TextButton(
    onPressed: () {
      print('Forgot password button pressed');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
      );
    },
    child: const Text('Esqueci minha senha'),
  );
}
