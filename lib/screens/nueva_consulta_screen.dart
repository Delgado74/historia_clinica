import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/database/database_helper.dart';
import '../data/models/consulta_model.dart';
import '../data/models/paciente_model.dart';

class NuevaConsultaScreen extends StatefulWidget {
  final Paciente paciente;

  const NuevaConsultaScreen({super.key, required this.paciente});

  @override
  State<NuevaConsultaScreen> createState() => _NuevaConsultaScreenState();
}

class _NuevaConsultaScreenState extends State<NuevaConsultaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();

  late TextEditingController _fechaController;
  final _motivoController = TextEditingController();
  final _heaController = TextEditingController();
  final _sintomasController = TextEditingController();
  final _examenController = TextEditingController();
  final _diagnosticoController = TextEditingController();
  final _estudiosIndicadosController = TextEditingController();
  final _estudiosRecibidosController = TextEditingController();
  final _conductaController = TextEditingController();
  final _proximaConsultaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fechaController = TextEditingController(
      text: DateTime.now().toIso8601String().split('T').first,
    );
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _motivoController.dispose();
    _heaController.dispose();
    _sintomasController.dispose();
    _examenController.dispose();
    _diagnosticoController.dispose();
    _estudiosIndicadosController.dispose();
    _estudiosRecibidosController.dispose();
    _conductaController.dispose();
    _proximaConsultaController.dispose();
    super.dispose();
  }

  Future<void> _guardarConsulta() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (widget.paciente.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Error: paciente sin ID válido')),
        );
        return;
      }

      // Convertir fecha próxima consulta a formato estándar yyyy-MM-dd
      String? fechaProxima;
      if (_proximaConsultaController.text.trim().isNotEmpty) {
        try {
          final input = DateFormat('dd/MM/yy').parseStrict(_proximaConsultaController.text.trim());
          fechaProxima = DateFormat('yyyy-MM-dd').format(input);
        } catch (_) {
          fechaProxima = _proximaConsultaController.text.trim(); // fallback
        }
      }

      final consulta = Consulta(
        pacienteId: widget.paciente.id!,
        fecha: _fechaController.text.trim(),
        motivo: _motivoController.text.trim(),
        hea: _heaController.text.trim(),
        sintomas: _sintomasController.text.trim(),
        examenFisico: _examenController.text.trim(),
        diagnostico: _diagnosticoController.text.trim(),
        estudiosIndicados: _estudiosIndicadosController.text.trim(),
        estudiosRecibidos: _estudiosRecibidosController.text.trim(),
        conducta: _conductaController.text.trim(),
        proximaConsulta: fechaProxima ?? '',
      );

      final id = await _dbHelper.insertConsulta(consulta);

      if (!mounted) return;

      if (id > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Consulta registrada correctamente')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Error al guardar la consulta')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    bool requiredField = true,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: inputType,
        maxLines: maxLines,
        validator: requiredField
            ? (value) =>
        (value == null || value.isEmpty) ? 'Campo requerido' : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Consulta'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                  label: 'Fecha', controller: _fechaController, readOnly: true),
              _buildTextField(
                  label: 'Motivo de la consulta', controller: _motivoController),
              _buildTextField(
                  label: 'Historia de Enfermedad Actual (HEA)',
                  controller: _heaController,
                  maxLines: 5),
              _buildTextField(
                  label: 'Síntomas',
                  controller: _sintomasController,
                  maxLines: 3),
              _buildTextField(
                  label: 'Examen Físico',
                  controller: _examenController,
                  maxLines: 6),
              _buildTextField(
                  label: 'Diagnóstico',
                  controller: _diagnosticoController,
                  maxLines: 5),
              _buildTextField(
                  label: 'Estudios indicados',
                  controller: _estudiosIndicadosController,
                  maxLines: 4,
                  requiredField: false),
              _buildTextField(
                  label: 'Estudios recibidos',
                  controller: _estudiosRecibidosController,
                  maxLines: 4,
                  requiredField: false),
              _buildTextField(
                  label: 'Conducta a seguir (CAS)',
                  controller: _conductaController,
                  maxLines: 6),

              // 🔽 CAMPO MODIFICADO 🔽
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: TextFormField(
                  controller: _proximaConsultaController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'Fecha de próxima consulta (dd/MM/yy)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    try {
                      DateFormat('dd/MM/yy').parseStrict(value);
                      return null;
                    } catch (_) {
                      return 'Formato inválido (use dd/MM/yy)';
                    }
                  },
                ),
              ),
              // 🔼 FIN CAMPO MODIFICADO 🔼

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _guardarConsulta,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar Consulta'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
