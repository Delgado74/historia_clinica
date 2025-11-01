class Paciente {
  final int? id;
  final String cdr;
  final String numCasa;
  final String nombre;
  final String sexo;
  final String colorPiel;
  final String dni;
  final int edad;
  final String app; // Antecedentes personales
  final String apf; // Antecedentes familiares
  final String alergias;
  final String operaciones;
  final String transfusiones;
  final String tratamiento; // Tratamiento médico actual

  Paciente({
    this.id,
    required this.cdr,
    required this.numCasa,
    required this.nombre,
    required this.sexo,
    required this.colorPiel,
    required this.dni,
    required this.edad,
    required this.app,
    required this.apf,
    required this.alergias,
    required this.operaciones,
    required this.transfusiones,
    required this.tratamiento,
  });

  // 🔹 Convertir un registro de SQLite en un objeto Paciente
  factory Paciente.fromMap(Map<String, dynamic> json) => Paciente(
    id: json['id'],
    cdr: json['cdr'] ?? '',
    numCasa: json['num_casa'] ?? '',
    nombre: json['nombre'] ?? '',
    sexo: json['sexo'] ?? '',
    colorPiel: json['color_piel'] ?? '',
    dni: json['dni'] ?? '',
    edad: json['edad'] ?? 0,
    app: json['app'] ?? '',
    apf: json['apf'] ?? '',
    alergias: json['alergias'] ?? '',
    operaciones: json['operaciones'] ?? '',
    transfusiones: json['transfusiones'] ?? '',
    tratamiento: json['tratamiento'] ?? '',
  );

  // 🔹 Convertir el objeto Paciente en un mapa para guardar en SQLite
  Map<String, dynamic> toMap() => {
    'id': id,
    'cdr': cdr,
    'num_casa': numCasa,
    'nombre': nombre,
    'sexo': sexo,
    'color_piel': colorPiel,
    'dni': dni,
    'edad': edad,
    'app': app,
    'apf': apf,
    'alergias': alergias,
    'operaciones': operaciones,
    'transfusiones': transfusiones,
    'tratamiento': tratamiento,
  };

  // 🔹 Método copyWith para editar sin perder id
  Paciente copyWith({
    int? id,
    String? cdr,
    String? numCasa,
    String? nombre,
    String? sexo,
    String? colorPiel,
    String? dni,
    int? edad,
    String? app,
    String? apf,
    String? alergias,
    String? operaciones,
    String? transfusiones,
    String? tratamiento,
  }) {
    return Paciente(
      id: id ?? this.id,
      cdr: cdr ?? this.cdr,
      numCasa: numCasa ?? this.numCasa,
      nombre: nombre ?? this.nombre,
      sexo: sexo ?? this.sexo,
      colorPiel: colorPiel ?? this.colorPiel,
      dni: dni ?? this.dni,
      edad: edad ?? this.edad,
      app: app ?? this.app,
      apf: apf ?? this.apf,
      alergias: alergias ?? this.alergias,
      operaciones: operaciones ?? this.operaciones,
      transfusiones: transfusiones ?? this.transfusiones,
      tratamiento: tratamiento ?? this.tratamiento,
    );
  }
}
