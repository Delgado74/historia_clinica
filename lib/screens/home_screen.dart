import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../data/database/database_helper.dart';
import '../data/models/paciente_model.dart';
import '../screens/paciente_screen.dart';
import '../core/app_routes.dart';
import '../core/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();
  List<Paciente> _pacientes = [];
  List<Paciente> _filteredPacientes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPacientes();
    _searchController.addListener(_filterPacientes);
  }

  Future<void> _loadPacientes() async {
    final data = await dbHelper.getPacientes();
    setState(() {
      _pacientes = data;
      _filteredPacientes = data;
    });
  }

  void _filterPacientes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPacientes = _pacientes
          .where((p) => p.nombre.toLowerCase().contains(query))
          .toList();
    });
  }

  // ============================================================
  // 📥 IMPORTAR Y 💾 EXPORTAR BASE DE DATOS
  // ============================================================
  Future<void> _exportDatabase() async {
    try {
      final file = await dbHelper.exportDatabase();
      if (!mounted || file == null || file.path.isEmpty) return;

      String exportPath = file.path;

      if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
        Directory? downloadsDir;

        try {
          downloadsDir = await getDownloadsDirectory();
        } catch (_) {
          downloadsDir = null;
        }

        downloadsDir ??= Directory(path.join(Platform.environment['HOME'] ?? '.', 'Downloads'));

        if (!await downloadsDir.exists()) await downloadsDir.create(recursive: true);

        final newFile = await file.copy(path.join(downloadsDir.path, path.basename(file.path)));
        exportPath = newFile.path;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Base de datos exportada a: $exportPath')),
        );
      } else {
        await Share.shareXFiles([XFile(exportPath)],
            text: 'Base de datos de ${AppConstants.appName}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al exportar base de datos: $e')),
      );
    }
  }

  Future<void> _importDatabase() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result == null || result.files.single.path == null) return;

      final selectedFile = File(result.files.single.path!);

      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Confirmar importación'),
          content: const Text('Esto reemplazará la base de datos actual. ¿Desea continuar?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Importar'),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      await dbHelper.importDatabase(selectedFile);
      await _loadPacientes();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Base de datos importada correctamente')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al importar base de datos: $e')),
      );
    }
  }

  // ============================================================
  // 🗑 ELIMINAR PACIENTE
  // ============================================================
  void _deletePaciente(Paciente paciente) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Desea eliminar a ${paciente.nombre}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await dbHelper.deletePaciente(paciente.id!);
      await _loadPacientes();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paciente ${paciente.nombre} eliminado')),
      );
    }
  }

  // ============================================================
  // ABRIR PANTALLA DE PACIENTE
  // ============================================================
  Future<void> _abrirPacienteScreen({Paciente? paciente}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PacienteScreen(),
        settings: RouteSettings(arguments: paciente),
      ),
    );

    if (result == true) {
      await _loadPacientes(); // recarga lista al guardar/editar
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historia Clínica'),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.medical_services, color: Colors.white, size: 40),
                  SizedBox(height: 10),
                  Text('Menú Principal', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Importar base de datos'),
              onTap: () {
                Navigator.pop(context);
                _importDatabase();
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Exportar base de datos'),
              onTap: () {
                Navigator.pop(context);
                _exportDatabase();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Acerca de'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.acercade);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar paciente...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: _filteredPacientes.isEmpty
                ? const Center(child: Text('No hay pacientes registrados.'))
                : ListView.builder(
              itemCount: _filteredPacientes.length,
              itemBuilder: (context, index) {
                final paciente = _filteredPacientes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    title: Text(paciente.nombre,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          tooltip: 'Editar',
                          onPressed: () => _abrirPacienteScreen(paciente: paciente),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Eliminar',
                          onPressed: () => _deletePaciente(paciente),
                        ),
                        IconButton(
                          icon: const Icon(Icons.description, color: Colors.teal),
                          tooltip: 'Consultas',
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.consulta,
                                arguments: paciente);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => _abrirPacienteScreen(),
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
