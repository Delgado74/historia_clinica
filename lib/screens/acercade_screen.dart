import 'package:flutter/material.dart';
import '../core/app_constants.dart';

class AcercaDeScreen extends StatelessWidget {
  const AcercaDeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 🔹 Ícono principal
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal,
                  ),
                  child: const Icon(
                    Icons.medical_services,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
                const SizedBox(height: 30),

                // 🔹 Nombre de la aplicación
                const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // 🔹 Versión
                const Text(
                  'Versión ${AppConstants.appVersion}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 25),

                // 🔹 Descripción
                const Text(
                  'Esta aplicación permite a los profesionales de la salud '
                      'gestionar la información clínica de sus pacientes de forma segura, '
                      'local y sin necesidad de conexión a internet.\n\n'
                      'Diseñada para consultorios de médicos de familia, '
                      'facilita el registro de datos generales, consultas y tratamientos.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // 🔹 Datos del desarrollador
                const Divider(thickness: 1, height: 20),
                const Text(
                  'Desarrollado por ${AppConstants.developer}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Contacto: ${AppConstants.contactEmail}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  'Todos los derechos reservados © 2025',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
