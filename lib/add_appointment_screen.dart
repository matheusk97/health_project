import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Importar intl para formatar a data

class AddAppointmentScreen extends StatefulWidget {
  final int user_id;

  AddAppointmentScreen({Key? key, required this.user_id}) : super(key: key);

  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dataAgendamentoController;
  List<Especialidade> _especialidades = [];
  List<Especialista> _especialistas = [];
  Especialidade? _selectedEspecialidade;
  Especialista? _selectedEspecialista;
  int? _selectedHora;

  @override
  void initState() {
    super.initState();
    _dataAgendamentoController = TextEditingController();
    _fetchEspecialidades();
  }

  Future<void> _fetchEspecialidades() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/specialties'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        _especialidades =
            jsonResponse.map((data) => Especialidade.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load specialties');
    }
  }

  Future<void> _fetchEspecialistas(int especialidadeId) async {
    final response = await http
        .get(Uri.parse('http://localhost:5000/specialists/$especialidadeId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        _especialistas =
            jsonResponse.map((data) => Especialista.fromJson(data)).toList();
        _selectedEspecialista = null; // Resetar o especialista selecionado
      });
    } else {
      throw Exception('Failed to load specialists');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dataAgendamentoController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Enviar dados para o servidor
      final response = await http.post(
        Uri.parse('http://localhost:5000/appointments'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': widget.user_id.toString(),
          'data_agendamento': _dataAgendamentoController.text,
          'hora_agendamento': _selectedHora.toString(),
          'especialista_id': _selectedEspecialista?.id.toString(),
          // Adicione outros dados do formulário aqui
        }),
      );

      if (response.statusCode == 201) {
        Navigator.pop(
            context, true); // Retornar true se a criação for bem-sucedida
      } else {
        // Tratar outros códigos de resposta
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao criar o agendamento')),
        );
      }
    }
  }

  @override
  void dispose() {
    _dataAgendamentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Nova Consulta'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<Especialidade>(
                value: _selectedEspecialidade,
                decoration: InputDecoration(labelText: 'Especialidade'),
                items: _especialidades.map((Especialidade especialidade) {
                  return DropdownMenuItem<Especialidade>(
                    value: especialidade,
                    child: Text(especialidade.nome),
                  );
                }).toList(),
                onChanged: (Especialidade? newValue) {
                  setState(() {
                    _selectedEspecialidade = newValue;
                    if (newValue != null) {
                      _fetchEspecialistas(newValue.id);
                    }
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma especialidade';
                  }
                  return null;
                },
              ),
               DropdownButtonFormField<Especialista>(
                value: _selectedEspecialista,
                decoration: InputDecoration(labelText: 'Nome do Especialista'),
                items: _especialistas.map((Especialista especialista) {
                  return DropdownMenuItem<Especialista>(
                    value: especialista,
                    child: Text(especialista.nome),
                  );
                }).toList(),
                onChanged: (Especialista? newValue) {
                  setState(() {
                    _selectedEspecialista = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione um especialista';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dataAgendamentoController,
                decoration: InputDecoration(
                  labelText: 'Data do Agendamento',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma data';
                  }
                  return null;
                },
              ),
             
              DropdownButtonFormField<int>(
                value: _selectedHora,
                decoration: InputDecoration(labelText: 'Hora do Agendamento'),
                items: List.generate(10, (index) => index + 8).map((int hora) {
                  return DropdownMenuItem<int>(
                    value: hora,
                    child: Text(hora.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedHora = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma hora';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Especialidade {
  final int id;
  final String nome;

  Especialidade({
    required this.id,
    required this.nome,
  });

  factory Especialidade.fromJson(Map<String, dynamic> json) {
    return Especialidade(
      id: json['id'],
      nome: json['nome'],
    );
  }
}

class Especialista {
  final int id;
  final String nome;

  Especialista({
    required this.id,
    required this.nome,
  });

  factory Especialista.fromJson(Map<String, dynamic> json) {
    return Especialista(
      id: json['id'],
      nome: json['nome'],
    );
  }
}
