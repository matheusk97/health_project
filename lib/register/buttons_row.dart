import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'controllers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ButtonsRow extends StatelessWidget {
  final bool Function() isButtonEnabled;

  const ButtonsRow({super.key, required this.isButtonEnabled});

  void registerUser(BuildContext context) async {
                      print('Register User API Call - Started');
                      final url = Uri.parse('http://localhost:5000/register');
                      final headers = {'Content-Type': 'application/json'};
                      final body = jsonEncode({
                        'username': usernameController.text,
                        'password': passwordController.text,
                        'email': emailController.text,
                        'date_of_birth': birthdayController.text,
                      });

                      try {
                        final response = await http.post(url, headers: headers, body: body);

                        if (response.statusCode == 200 || response.statusCode == 201) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Success'),
                                content: const Text('Registration successful!'),
                                actions: [
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
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: Text('Registration failed: ${response.body}'),
                                actions: [
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
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: Text('An error occurred: $e'),
                              actions: [
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: isButtonEnabled()
                ? () {
                    print('Register button pressed');
                    print('Name: ${usernameController.text}');
                    print('Password: ${passwordController.text}');
                    print('Email: ${emailController.text}');
                    print('Birthday: ${birthdayController.text}');

                    if (!isOver18(birthdayController.text)) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('You must be over 18 to register.'),
                            actions: [
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
                      return;
                    }

                    else if (passwordController.text.length < 8) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'Password must have at least 8 characters.'),
                            actions: [
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

                    else if (!emailController.text.contains('@')) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Invalid email.'),
                            actions: [
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

                    else if (usernameController.text.length < 4) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Login must have at least 4 characters.'),
                            actions: [
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

                    else {
                        registerUser(context);  
                        Navigator.of(context).pop();
                    }

                  }
                : null,
            child: const Text('Register'),
          ),
        ),
      ],
    );
  }

  bool isOver18(String text) {
    try {
      final dateFormat = DateFormat('dd/MM/yyyy');
      final birthday = dateFormat.parseStrict(text).toLocal();
      final now = DateTime.now();
      final difference = now.difference(birthday);
      final days = difference.inDays;
      final years = days ~/ 365;

      return years >= 18;
    } catch (e) {
      return false;
    }
  }
}
