import 'package:flutter/material.dart';
import 'paginas/insertar.dart';
import 'paginas/actualizar.dart';
import 'paginas/eliminar.dart';
import 'paginas/seleccinar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MenuPrincipal(),
    );
  }
}

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alumnos")),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text("Menú de opciones"),
            ),
            ListTile(
              title: const Text("Insertar"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaginaInsertar()),
              ),
            ),
            ListTile(
              title: const Text("Actualizar"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaginaActualizar()),
              ),
            ),
            ListTile(
              title: const Text("Eliminar"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaginaEliminar()),
              ),
            ),
            ListTile(
              title: const Text("Seleccionar / Buscar"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaginaSeleccionar()),
              ),
            ),
          ],
        ),
      ),

      body: const Center(
        child: Text("Bienvenido"),
      ),
    );
  }
}