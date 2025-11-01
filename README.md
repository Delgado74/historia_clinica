# 🩺 Historia Clínica Digital

Aplicación desarrollada en **Flutter + SQLite** para gestionar de forma local y sin conexión la información médica de los pacientes en un consultorio, policlínico o área de salud.

Permite registrar datos generales del paciente, antecedentes, alergias, tratamientos y consultas médicas, con posibilidad de respaldo e importación de la base de datos.

---

## 📱 Características principales

- ✅ Registro y edición de pacientes.
- ✅ Registro de consultas con fecha, motivo, exámenes, estudios y tratamiento.
- ✅ Acceso rápido al historial clínico de cada paciente.
- ✅ Base de datos local SQLite (funciona sin Internet).
- ✅ Exportación e importación de base de datos para compartir entre médicos.
- ✅ Interfaz amigable y adaptable (Android, Windows, Linux).
- ✅ Opción “Acerca de” con datos del desarrollador y contacto.

---

## 🧱 Estructura del proyecto

lib/
┣ core/
┃ ┣ app_constants.dart # Constantes globales (nombre app, BD, versión, contacto)
┃ ┗ app_routes.dart # Rutas principales del proyecto
┣ data/
┃ ┣ database/
┃ ┃ ┗ database_helper.dart # Conexión y manejo de la base de datos SQLite
┃ ┗ models/
┃ ┣ paciente_model.dart # Modelo de datos del paciente
┃ ┗ consulta_model.dart # Modelo de datos de las consultas médicas
┣ screens/
┃ ┣ bienvenida_screen.dart # Pantalla de bienvenida con botón "Iniciar"
┃ ┣ home_screen.dart # Lista de pacientes + menú lateral
┃ ┣ paciente_screen.dart # Datos generales del paciente
┃ ┣ consulta_screen.dart # Consultas previas y botón "Nueva consulta"
┃ ┣ nueva_consulta_screen.dart# Formulario de nueva consulta
┃ ┗ acercade_screen.dart # Información del desarrollador y versión
┗ main.dart # Punto de entrada principal de la aplicación


---

## ⚙️ Instalación y configuración

### 🔹 1. Requisitos previos
- Flutter SDK (versión 3.3 o superior)
- Android Studio o VS Code
- Emulador o dispositivo físico Android / PC con Linux o Windows

---

### 🔹 2. Clonar o copiar el proyecto

```bash
git clone https://github.com/tuusuario/historia_clinica_digital.git
cd historia_clinica_digital
```

🔹 3. Instalar dependencias

``` bash
flutter pub get
```

🔹 4. Ejecutar en modo desarrollo

```bash
flutter run
```
Puedes usar ```flutter run -d windows``` o ```flutter run -d linux``` según tu plataforma.

---

💾 Exportar e importar base de datos

La base de datos local `(historia_clinica.db)` se almacena automáticamente en el directorio de la aplicación.

🔹 Exportar base de datos

Desde el menú lateral:

📤 “Exportar base de datos”
Esto generará un archivo .db que puedes compartir con otro médico mediante Bluetooth, correo o cualquier app.

🔹 Importar base de datos

Desde el menú lateral:

📥 “Importar base de datos”
Selecciona el archivo .db recibido para cargar los datos en tu aplicación.

---

🧩 Compilación para distribución
🔹 Android (APK)
```bash
flutter build apk --release
```
El archivo APK se generará en:
```swift
build/app/outputs/flutter-apk/app-release.apk
```

--

🔹 Windows
```bash
flutter build windows
```
El ejecutable estará en:
```swift
build/windows/runner/Release/
```

--

🧑‍💻 Desarrollado por

Yuri Delgado
📧 yuridelgadoamaran@gmail.com

Versión: 1.0.0
© 2025 Todos los derechos reservados.

--

❤️ Agradecimientos

A todos los médicos, enfermeras y personal de salud que, con esfuerzo y dedicación, garantizan el bienestar de sus comunidades.
Esta aplicación fue creada para facilitar su trabajo, sin depender de conexión a internet.