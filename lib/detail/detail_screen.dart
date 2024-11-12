import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Importar intl para formatar a data
import './../home/home.dart'; // Importar o home.dart corretamente
import './../models/especialista.dart'; // Importar o modelo Especialista
import './../models/agendamento.dart'; // Importar o modelo Agendamento

class DetailScreen extends StatefulWidget {
  final Agendamento agendamento;

  DetailScreen({Key? key, required this.agendamento}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late TextEditingController _dataAgendamentoController;
  late TextEditingController _horaAgendamentoController;
  late TextEditingController _especialistaNomeController;
  List<Especialista> _especialistas = [];
  Especialista? _selectedEspecialista;

  @override
  void initState() {
    super.initState();
    try {
      _dataAgendamentoController = TextEditingController(
        
        text: DateFormat('yyyy-MM-dd').format(DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(widget.agendamento.dataAgendamento)),
      );
    } catch (e) {
      _dataAgendamentoController = TextEditingController(text: widget.agendamento.dataAgendamento);
    }
    _horaAgendamentoController = TextEditingController(text: widget.agendamento.horaAgendamento.toString());
    _especialistaNomeController = TextEditingController(text: widget.agendamento.especialistaNome);
    _fetchEspecialistas();
  }

  Future<void> _fetchEspecialistas() async {

    final response = await http.get(Uri.parse('http://localhost:5000/specialists'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        _especialistas = jsonResponse.map((data) => Especialista.fromJson(data)).toList();
        if (_especialistas.isNotEmpty) {
          _selectedEspecialista = _especialistas.firstWhere(
            (especialista) => especialista.id == widget.agendamento.especialistaId,
            orElse: () => _especialistas.first,
          );
          _especialistaNomeController.text = _selectedEspecialista?.nome ?? '';
        }
      });
    } else {
      throw Exception('Failed to load specialists');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(widget.agendamento.dataAgendamento),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        DateTime parsedDate = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(picked.toString());
        String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
        _dataAgendamentoController.text = formattedDate;
      });
    }
  }

  Future<void> _deleteAgendamento() async {
    final response = await http.delete(
      Uri.parse('http://localhost:5000/appointments/${widget.agendamento.id}'),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true); // Retornar true se a exclusão for bem-sucedida
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao excluir o agendamento')),
      );
    }
  }

  Future<void> _saveChanges() async {
    final response = await http.put(
      Uri.parse('http://localhost:5000/appointments/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'data_agendamento': _dataAgendamentoController.text,
        'hora_agendamento': int.parse(_horaAgendamentoController.text),
        'especialista_id': _selectedEspecialista?.id,
        'especialista_nome': _especialistaNomeController.text,
        'user_id': widget.agendamento.userId,
        'id': widget.agendamento.id,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true); // Retornar true se a atualização for bem-sucedida
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao salvar as alterações')),
      );
    }
  }

  @override
  void dispose() {
    _dataAgendamentoController.dispose();
    _horaAgendamentoController.dispose();
    _especialistaNomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Agendamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dataAgendamentoController,
              decoration: InputDecoration(
                labelText: 'Data do Agendamento',
              ),
            ),
            TextField(
              controller: _horaAgendamentoController,
              decoration: InputDecoration(
                labelText: 'Hora do Agendamento',
              ),
            ),
            TextField(
              controller: _especialistaNomeController,
              decoration: InputDecoration(
                labelText: 'Nome do Especialista',
              ),
              readOnly: true,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text('Salvar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: _deleteAgendamento,
                  child: Text('Excluir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Cor do botão de exclusão
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}