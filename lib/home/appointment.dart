import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Appointments(),
    );
  }
}

class Appointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppointmentsScreen()),
            );
          },
          child: Text('View Appointments'),
        ),
      ),
    );
  }
}

class AppointmentsScreen extends StatelessWidget {
  final List<String> appointments = [
    'Appointment 1',
    'Appointment 2',
    'Appointment 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(appointments[index]),
          );
        },
      ),
    );
  }
}