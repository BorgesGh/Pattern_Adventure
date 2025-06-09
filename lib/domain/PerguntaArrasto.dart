import 'package:flutter/cupertino.dart';

class PerguntaArrasto {
  final int? id; // Opcional (será gerado automaticamente pelo SQLite)
  final List<String> caminhosImagens; // Caminhos das imagens (assets ou rede)
  final List<int> ordemCorreta;
  final List<String> alternativas;

  PerguntaArrasto({
    this.id,
    required this.caminhosImagens,
    required this.ordemCorreta,
    required this.alternativas,
  });

  // Converte para Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caminhosImagens': caminhosImagens.join('|'), // Une com separador
      'ordemCorreta': ordemCorreta.join(','), // Ex: "1,0,2"
      'alternativas': alternativas.join('|'), // Une com separador
    };
  }

  // Cria a partir de Map (para ler do banco)
  factory PerguntaArrasto.fromMap(Map<String, dynamic> map) {
    return PerguntaArrasto(
      id: map['id'],
      caminhosImagens: (map['caminhosImagens'] as String).split('|'),
      ordemCorreta: (map['ordemCorreta'] as String)
          .split(',')
          .map((e) => int.parse(e))
          .toList(),
      alternativas: (map['alternativas'] as String).split('|'),
    );
  }
}