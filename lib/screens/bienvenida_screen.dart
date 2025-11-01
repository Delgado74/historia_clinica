import 'package:flutter/material.dart';
import '../core/app_routes.dart';
import '../core/app_constants.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 LOGO
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

              // 🔹 TÍTULO
              const Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),

              // 🔹 DESCRIPCIÓN
              const Text(
                'Gestione de forma sencilla la información médica de sus pacientes.\n'
                    'Registre datos personales, consultas y tratamientos.\n'
                    'Disponible sin conexión a internet.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // 🔹 BOTÓN INICIAR
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow, size: 24),
                  label: const Text(
                    'INICIAR',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                ),
              ),
              const SizedBox(height: 60),

              // 🔹 INFORMACIÓN DE CRÉDITO / PIE
              const Text(
                'Versión 1.0.0\nDesarrollado por Yuri Delgado',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
