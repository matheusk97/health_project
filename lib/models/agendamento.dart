class Agendamento {
  final String dataAgendamento;
  final int horaAgendamento;
  final int especialistaId;
  final String especialistaNome;

  final int id;
  final int userId;

  Agendamento({
    required this.dataAgendamento,
    required this.horaAgendamento,
    required this.especialistaId,
    required this.especialistaNome,

    required this.id,
    required this.userId,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      dataAgendamento: json['data_agendamento'],
      horaAgendamento: json['hora_agendamento'],
      especialistaId: json['especialista_id'],
      especialistaNome: json['especialista_nome'],
      id: json['id'],
      userId: json['user_id'],
    );
  }
}