import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../home/home.dart';
import 'controllers.dart';

class ButtonsRow extends StatelessWidget {
  final BuildContext context;

  const ButtonsRow(this.context);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
             
              Future<void> _login() async {
                final response = await http.post(
                  Uri.parse('http://localhost:5000/login'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String>{
                    'login': usernameController.text,
                    'senha': passwordController.text,
                  }),
                );

                if (response.statusCode == 200) {
                 var id = jsonDecode(response.body)['id'];
                
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(username: usernameController.text, user_id: id)));
                  
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Login failed. Please try again.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              }

              await _login();
            },
            child: const Text('Entrar'),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: const Text('Registrar'),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/forgotpassword');
            },
            child: const Text('Esqueci a senha'),
          ),
        ),
      ],
    );
  }
}