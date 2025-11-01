import 'package:flutter/material.dart';
import '../data/database/database_helper.dart';
import '../data/models/consulta_model.dart';
import '../data/models/paciente_model.dart';
import 'nueva_consulta_screen.dart';

class ConsultaScreen extends StatefulWidget {
  final Paciente paciente;

  const ConsultaScreen({super.key, required this.paciente});

  @override
  State<ConsultaScreen> createState() => _ConsultaScreenState();
}

class _ConsultaScreenState extends State<ConsultaScreen> {
  final dbHelper = DatabaseHelper();
  List<Consulta> _consultas = [];

  @override
  void initState() {
    super.initState();
    _loadConsultas();
  }

  Future<void> _loadConsultas() async {
    final data = await dbHelper.getConsultasByPaciente(widget.paciente.id!);
    setState(() {
      _consultas = data;
    });
  }

  void _verConsulta(Consulta consulta) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalles de la Consulta'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🗓 Fecha: ${consulta.fecha}'),
              const SizedBox(height: 6),
              Text('📋 Motivo: ${consulta.motivo}'),
              const SizedBox(height: 6),
              Text('🧠 Historia de enfermedad actual (HEA):\n${consulta.hea}'),
              const SizedBox(height: 6),
              Text('🤒 Síntomas:\n${consulta.sintomas}'),
              Text('🩺 Examen físico:\n${consulta.examenFisico}'),
              const SizedBox(height: 6),
              Text('🔬 Estudios indicados:\n${consulta.estudiosIndicados}'),
              const SizedBox(height: 6),
              Text('📑 Estudios recibidos:\n${consulta.estudiosRecibidos}'),
              const SizedBox(height: 6),
              Text('🧾 Conducta a seguir (CAS):\n${consulta.conducta}'),
              const SizedBox(height: 6),
              Text('📆 Próxima consulta: ${consulta.proximaConsulta}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _nuevaConsulta() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NuevaConsultaScreen(paciente: widget.paciente),
      ),
    );

    if (result == true) {
      _loadConsultas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultas de ${widget.paciente.nombre}'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _consultas.isEmpty
          ? const Center(child: Text('No hay consultas registradas.'))
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _consultas.length,
        itemBuilder: (context, index) {
          final c = _consultas[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(
                'Consulta del ${c.fecha}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(c.motivo),
              onTap: () => _verConsulta(c),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _nuevaConsulta,
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Consulta'),
      ),
    );
  }
}
