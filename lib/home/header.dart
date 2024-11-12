
import 'package:flutter/material.dart';


class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Text(
          'Seja bem vindo ao Health Project, aqui você pode acompanhar sua saúde e bem estar.',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(width: 0), // Espaço entre o texto e o TextField
      ],
    );
  }
}