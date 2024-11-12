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