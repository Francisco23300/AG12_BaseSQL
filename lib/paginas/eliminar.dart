import 'package:flutter/material.dart';
import '../base_datos/gestor_base_datos.dart';
import '../modelos/alumno.dart';

class PaginaEliminar extends StatefulWidget {
  const PaginaEliminar({super.key});

  @override
  State<PaginaEliminar> createState() => _PaginaEliminarState();
}

class _PaginaEliminarState extends State<PaginaEliminar> {
  List<Alumno> alumnos = [];

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    alumnos = await GestorBaseDatos.instancia.listarAlumnos();
    setState(() {});
  }

  Future<void> eliminar(int id) async {
    await GestorBaseDatos.instancia.eliminarAlumno(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Alumno eliminado")),
    );
    cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Eliminar Alumno")),
      body: ListView.builder(
        itemCount: alumnos.length,
        itemBuilder: (_, i) {
          final a = alumnos[i];
          return Card(
            child: ListTile(
              title: Text("${a.nombre} ${a.apellidoPaterno}"),
              subtitle: Text("Control: ${a.numeroControl}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => eliminar(a.id!),
              ),
            ),
          );
        },
      ),
    );
  }
}