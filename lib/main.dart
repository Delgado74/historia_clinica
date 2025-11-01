import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'core/app_constants.dart';
import 'core/app_routes.dart';

// Pantallas principales
import 'screens/bienvenida_screen.dart';
import 'screens/home_screen.dart';
import 'screens/paciente_screen.dart';
import 'screens/consulta_screen.dart';
import 'screens/nueva_consulta_screen.dart';
import 'screens/acercade_screen.dart';

// Modelo
import 'data/models/paciente_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Inicialización multiplataforma
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Inicializa sqflite para escritorio
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const HistoriaClinicaApp());
}

class HistoriaClinicaApp extends StatelessWidget {
  const HistoriaClinicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // 🔹 Pantalla inicial
      initialRoute: AppRoutes.bienvenida,

      // 🔹 Rutas del proyecto
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.bienvenida:
            return MaterialPageRoute(builder: (_) => const BienvenidaScreen());
          case AppRoutes.home:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case AppRoutes.paciente:
            return MaterialPageRoute(builder: (_) => const PacienteScreen());
          case AppRoutes.consulta:
            final paciente = settings.arguments;
            if (paciente == null || paciente is! Paciente) {
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(
                    child: Text('⚠️ Error: paciente no especificado'),
                  ),
                ),
              );
            }
            return MaterialPageRoute(
              builder: (_) => ConsultaScreen(paciente: paciente),
            );
          case AppRoutes.nuevaConsulta:
            final paciente = settings.arguments;
            if (paciente == null || paciente is! Paciente) {
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(
                    child: Text('⚠️ Error: paciente no especificado'),
                  ),
                ),
              );
            }
            return MaterialPageRoute(
              builder: (_) => NuevaConsultaScreen(paciente: paciente),
            );
          case AppRoutes.acercade:
            return MaterialPageRoute(builder: (_) => const AcercaDeScreen());
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('404 - Pantalla no encontrada')),
              ),
            );
        }
      },
    );
  }
}
