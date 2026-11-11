  class Frase {
  final int? id;
  final String frase;
  final String autor;

  const Frase({this.id, required this.frase, required this.autor});

  // Objeto -> Map para guardar en sqlite
  Map<String, Object?> toMap() {
    return {if (id != null) 'id': id, 'frase': frase, 'autor': autor};
  }

  // Map (una fila de SQLite) -> Objeto
  factory Frase.fromMap(Map<String, Object?> map) {
    return Frase(
      id: map['id'] as int?,
      frase: map['frase'] as String,
      autor: map['autor'] as String,
    );
  }
}