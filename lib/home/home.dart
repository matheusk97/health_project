import 'package:flutter/material.dart';
import 'package:health_project/add_appointment_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import './../detail/detail_screen.dart'; // Importar a tela de detalhes corretamente
import './../models/agendamento.dart'; // Importar a classe Agendamento

class HomeScreen extends StatefulWidget {
  final String username;
  final int user_id;

  HomeScreen({Key? key, required this.username, required this.user_id})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Agendamento>> _futureAgendamentos;

  @override
  void initState() {
    super.initState();
    _futureAgendamentos = fetchAgendamentos();
  }

  Future<List<Agendamento>> fetchAgendamentos() async {
    final response = await http
        .get(Uri.parse('http://localhost:5000/appointments/${widget.user_id}'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Agendamento.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load agendamentos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Bem-vindo ao Health Project: ${widget.username}",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Agendamento>>(
              future: _futureAgendamentos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Agendamento> agendamentos = snapshot.data!;
                  return ListView.builder(
                    itemCount: agendamentos.length,
                    itemBuilder: (context, index) {
                      Agendamento agendamento = agendamentos[index];
                      return ListTile(
                        title: Text(agendamento.especialistaNome),
                        subtitle: Text(
                          '${DateFormat('dd-MM-yyyy').format(DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(agendamento.dataAgendamento))} - ${agendamento.horaAgendamento} horas',
                        ),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(agendamento: agendamento),
                            ),
                          );
                          if (result == true) {
                            // Atualizar a tela se o resultado for true
                            setState(() {
                              _futureAgendamentos = fetchAgendamentos();
                            });
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load agendamentos'));
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddAppointmentScreen(user_id: widget.user_id),
                  ),
                );
                if (result == true) {
                  // Atualizar a tela se o resultado for true
                  setState(() {
                    _futureAgendamentos = fetchAgendamentos();
                  });
                }
              },
              child: Text('Adicionar Nova Consulta'),
            ),
          ),
        ],
      ),
    );
  }
}
