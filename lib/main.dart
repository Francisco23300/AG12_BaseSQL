import 'package:flutter/material.dart';
import 'paginas/insertar.dart';
import 'paginas/actualizar.dart';
import 'paginas/eliminar.dart';
import 'paginas/seleccinar.dart';
import 'modelos/alumno.dart';
import 'base_datos/gestor_base_datos.dart';

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

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  List<Alumno> alumnos = [];

  @override
  void initState() {
    super.initState();
    cargarAlumnos();
  }

  // Carga alumnos desde la BD
  Future<void> cargarAlumnos() async {
    alumnos = await GestorBaseDatos.instancia.listarAlumnos();
    setState(() {});
  }

 
  Future<void> irA(Widget pagina) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => pagina),
    );

    
    cargarAlumnos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alumnos")),

      // MenU lateral
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text("Menú de opciones"),
            ),
            ListTile(
              title: const Text("Insertar"),
              onTap: () => irA(const PaginaInsertar()),
            ),
            ListTile(
              title: const Text("Actualizar"),
              onTap: () => irA(const PaginaActualizar()),
            ),
            ListTile(
              title: const Text("Eliminar"),
              onTap: () => irA(const PaginaEliminar()),
            ),
            ListTile(
              title: const Text("Seleccionar / Buscar"),
              onTap: () => irA(const PaginaSeleccionar()),
            ),
          ],
        ),
      ),

      
      body: alumnos.isEmpty
          ? const Center(child: Text("Sin alumnos registrados"))
          : ListView.builder(
              itemCount: alumnos.length,
              itemBuilder: (_, i) {
                final a = alumnos[i];
                return Card(
                  child: ListTile(
                    title: Text("${a.nombre} ${a.apellidoPaterno}"),
                    subtitle: Text("Control: ${a.numeroControl}"),
                  ),
                );
              },
            ),
    );
  }
}