class Consulta {
  final int? id;
  final int pacienteId;        // Relación con el paciente
  final String fecha;          // Fecha de la consulta
  final String motivo;
  final String hea;            // Historia de enfermedad actual
  final String sintomas;       // Síntomas reportados
  final String examenFisico;
  final String diagnostico;    // Diagnóstico médico
  final String estudiosIndicados;
  final String estudiosRecibidos;
  final String conducta;       // Conducta a seguir (CAS)
  final String proximaConsulta; // Fecha de próxima consulta

  Consulta({
    this.id,
    required this.pacienteId,
    required this.fecha,
    required this.motivo,
    required this.hea,
    required this.sintomas,
    required this.examenFisico,
    required this.diagnostico,
    required this.estudiosIndicados,
    required this.estudiosRecibidos,
    required this.conducta,
    required this.proximaConsulta,
  });

  // 🔹 Convertir un registro de SQLite en un objeto Consulta
  factory Consulta.fromMap(Map<String, dynamic> json) => Consulta(
    id: json['id'],
    pacienteId: json['pacienteId'],
    fecha: json['fecha'] ?? '',
    motivo: json['motivo'] ?? '',
    hea: json['hea'] ?? '',
    sintomas: json['sintomas'] ?? '',
    examenFisico: json['examen_fisico'] ?? '',
    diagnostico: json['diagnostico'] ?? '',
    estudiosIndicados: json['estudios_indicados'] ?? '',
    estudiosRecibidos: json['estudios_recibidos'] ?? '',
    conducta: json['conducta'] ?? '',
    proximaConsulta: json['proxima_consulta'] ?? '',
  );

  // 🔹 Convertir el objeto Consulta en un mapa para SQLite
  Map<String, dynamic> toMap() => {
    'id': id,
    'pacienteId': pacienteId,
    'fecha': fecha,
    'motivo': motivo,
    'hea': hea,
    'sintomas': sintomas,
    'examen_fisico': examenFisico,
    'diagnostico': diagnostico,
    'estudios_indicados': estudiosIndicados,
    'estudios_recibidos': estudiosRecibidos,
    'conducta': conducta,
    'proxima_consulta': proximaConsulta,
  };

  // 🔹 Método útil para actualizar sin perder id
  Consulta copyWith({
    int? id,
    int? pacienteId,
    String? fecha,
    String? motivo,
    String? hea,
    String? sintomas,
    String? examenFisico,
    String? diagnostico,
    String? estudiosIndicados,
    String? estudiosRecibidos,
    String? conducta,
    String? proximaConsulta,
  }) {
    return Consulta(
      id: id ?? this.id,
      pacienteId: pacienteId ?? this.pacienteId,
      fecha: fecha ?? this.fecha,
      motivo: motivo ?? this.motivo,
      hea: hea ?? this.hea,
      sintomas: sintomas ?? this.sintomas,
      examenFisico: examenFisico ?? this.examenFisico,
      diagnostico: diagnostico ?? this.diagnostico,
      estudiosIndicados: estudiosIndicados ?? this.estudiosIndicados,
      estudiosRecibidos: estudiosRecibidos ?? this.estudiosRecibidos,
      conducta: conducta ?? this.conducta,
      proximaConsulta: proximaConsulta ?? this.proximaConsulta,
    );
  }
}
