// lib/main.dart
import 'package:flutter/material.dart';

import 'ejercicio1.dart';
import 'ejercicio2.dart';
import 'ejercicio3.dart';

// Punto de entrada: ejecuta la aplicación
void main() {
  runApp(const MiApp());
}

// Widget raíz — configura MaterialApp (tema, rutas, título)
class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Primera App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Menu(),
    );
  }
}

// Menú para abrir cada ejercicio de la práctica
class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final ejercicios = <(String, String, IconData, Widget)>[
      ('Ejercicio 1', 'Primer proyecto: ¡Hola, Flutter!', Icons.waving_hand,
          const Ejercicio1()),
      ('Ejercicio 2', 'Tarjeta de perfil con layout widgets', Icons.badge,
          const Ejercicio2()),
      ('Ejercicio 3', 'Contador interactivo con StatefulWidget', Icons.exposure,
          const Ejercicio3()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Práctica Nº 1 — Flutter'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final (titulo, subtitulo, icono, pantalla) in ejercicios)
            Card(
              child: ListTile(
                leading: Icon(icono, color: Colors.blue.shade700),
                title: Text(titulo),
                subtitle: Text(subtitulo),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => pantalla),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
