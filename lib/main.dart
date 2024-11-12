import 'package:flutter/material.dart';
import 'package:health_project/login/login.dart';
import 'package:health_project/register/register.dart';


void main() => runApp(const MyApp());
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

 @override
 Widget build(BuildContext context) {
   return MaterialApp(
    initialRoute: '/',
     routes: {
      '/': (context) => const LoginScreen(),
      '/register': (context) => RegisterScreen()
     }
   );
 }
}
