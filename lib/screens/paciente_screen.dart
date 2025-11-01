import 'package:flutter/material.dart';
import '../data/database/database_helper.dart';
import '../data/models/paciente_model.dart';

class PacienteScreen extends StatefulWidget {
  const PacienteScreen({super.key});

  @override
  State<PacienteScreen> createState() => _PacienteScreenState();
}

class _PacienteScreenState extends State<PacienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();

  Paciente? paciente; // paciente que llega desde arguments
  bool _controllersInitialized = false;

  // Controladores
  late final TextEditingController _cdrController;
  late final TextEditingController _numCasaController;
  late final TextEditingController _nombreController;
  late final TextEditingController _sexoController;
  late final TextEditingController _colorPielController;
  late final TextEditingController _dniController;
  late final TextEditingController _edadController;
  late final TextEditingController _appController;
  late final TextEditingController _apfController;
  late final TextEditingController _alergiasController;
  late final TextEditingController _operacionesController;
  late final TextEditingController _transfusionesController;
  late final TextEditingController _tratamientoController;

  // Opciones para listas desplegables
  final List<String> _sexos = ['Masculino', 'Femenino'];
  final List<String> _coloresPiel = ['Blanca', 'Negra', 'Mestiza'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_controllersInitialized) {
      // Recupera paciente desde arguments
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Paciente) {
        paciente = args;
      }

      // Inicializa controladores
      _cdrController = TextEditingController(text: paciente?.cdr ?? '');
      _numCasaController = TextEditingController(text: paciente?.numCasa ?? '');
      _nombreController = TextEditingController(text: paciente?.nombre ?? '');
      _sexoController = TextEditingController(text: paciente?.sexo ?? '');
      _colorPielController = TextEditingController(text: paciente?.colorPiel ?? '');
      _dniController = TextEditingController(text: paciente?.dni ?? '');
      _edadController = TextEditingController(text: paciente != null ? paciente!.edad.toString() : '');
      _appController = TextEditingController(text: paciente?.app ?? '');
      _apfController = TextEditingController(text: paciente?.apf ?? '');
      _alergiasController = TextEditingController(text: paciente?.alergias ?? '');
      _operacionesController = TextEditingController(text: paciente?.operaciones ?? '');
      _transfusionesController = TextEditingController(text: paciente?.transfusiones ?? '');
      _tratamientoController = TextEditingController(text: paciente?.tratamiento ?? '');

      _controllersInitialized = true;
    }
  }

  @override
  void dispose() {
    _cdrController.dispose();
    _numCasaController.dispose();
    _nombreController.dispose();
    _sexoController.dispose();
    _colorPielController.dispose();
    _dniController.dispose();
    _edadController.dispose();
    _appController.dispose();
    _apfController.dispose();
    _alergiasController.dispose();
    _operacionesController.dispose();
    _transfusionesController.dispose();
    _tratamientoController.dispose();
    super.dispose();
  }

  Future<void> _guardarPaciente() async {
    if (!_formKey.currentState!.validate()) return;

    final nuevoPaciente = Paciente(
      id: paciente?.id, // Mantener id si es edición
      cdr: _cdrController.text.trim(),
      numCasa: _numCasaController.text.trim(),
      nombre: _nombreController.text.trim(),
      sexo: _sexoController.text.trim(),
      colorPiel: _colorPielController.text.trim(),
      dni: _dniController.text.trim(),
      edad: int.tryParse(_edadController.text.trim()) ?? 0,
      app: _appController.text.trim(),
      apf: _apfController.text.trim(),
      alergias: _alergiasController.text.trim(),
      operaciones: _operacionesController.text.trim(),
      transfusiones: _transfusionesController.text.trim(),
      tratamiento: _tratamientoController.text.trim(),
    );

    try {
      if (paciente == null) {
        await _dbHelper.insertPaciente(nuevoPaciente);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Paciente guardado correctamente')),
        );
      } else {
        await _dbHelper.updatePaciente(nuevoPaciente);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos del paciente actualizados')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar paciente: $e')),
      );
      return;
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    bool requiredField = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        validator: requiredField
            ? (value) => (value == null || value.isEmpty) ? 'Campo requerido' : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // Dropdown adaptado al tema del sistema
  Widget _buildDropdownField({
    required String label,
    required TextEditingController controller,
    required List<String> opciones,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dropdownColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        initialValue: controller.text.isNotEmpty ? controller.text : null,
        dropdownColor: dropdownColor,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: textColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        iconEnabledColor: theme.colorScheme.primary,
        items: opciones
            .map((opcion) => DropdownMenuItem<String>(
          value: opcion,
          child: Text(opcion, style: TextStyle(color: textColor)),
        ))
            .toList(),
        onChanged: (value) => setState(() => controller.text = value ?? ''),
        validator: (value) =>
        (value == null || value.isEmpty) ? 'Campo requerido' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = paciente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Paciente' : 'Nuevo Paciente'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(label: 'CDR', controller: _cdrController),
              _buildTextField(label: 'Número de casa', controller: _numCasaController),
              _buildTextField(label: 'Nombre y Apellidos', controller: _nombreController),
              _buildDropdownField(label: 'Sexo', controller: _sexoController, opciones: _sexos),
              _buildDropdownField(label: 'Color de la piel', controller: _colorPielController, opciones: _coloresPiel),
              _buildTextField(label: 'DNI (11 dígitos)', controller: _dniController),
              _buildTextField(label: 'Edad', controller: _edadController, inputType: TextInputType.number),
              _buildTextField(label: 'Antecedentes Patológicos Personales (APP)', controller: _appController, maxLines: 2, requiredField: false),
              _buildTextField(label: 'Antecedentes Patológicos Familiares (APF)', controller: _apfController, maxLines: 2, requiredField: false),
              _buildTextField(label: 'Alergias', controller: _alergiasController, maxLines: 2, requiredField: false),
              _buildTextField(label: 'Operaciones', controller: _operacionesController, maxLines: 2, requiredField: false),
              _buildTextField(label: 'Transfusiones', controller: _transfusionesController, maxLines: 2, requiredField: false),
              _buildTextField(label: 'Tratamiento médico actual', controller: _tratamientoController, maxLines: 2, requiredField: false),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _guardarPaciente,
                  icon: const Icon(Icons.save),
                  label: Text(isEditing ? 'Actualizar' : 'Guardar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
