import 'package:flutter/material.dart';
import '../base_datos/gestor_base_datos.dart';
import '../modelos/alumno.dart';

class PaginaSeleccionar extends StatefulWidget {
  const PaginaSeleccionar({super.key});

  @override
  State<PaginaSeleccionar> createState() => _PaginaSeleccionarState();
}

class _PaginaSeleccionarState extends State<PaginaSeleccionar> {
  List<Alumno> todos = [];
  List<Alumno> filtrados = [];

  final busqueda = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    todos = await GestorBaseDatos.instancia.listarAlumnos();
    filtrados = todos;
    setState(() {});
  }

  void filtrar(String txt) {
    txt = txt.toLowerCase();

    setState(() {
      filtrados = todos.where((a) {
        return a.nombre.toLowerCase().contains(txt) ||
            a.apellidoPaterno.toLowerCase().contains(txt) ||
            a.apellidoMaterno.toLowerCase().contains(txt) ||
            a.numeroControl.contains(txt);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscar Alumno")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: busqueda,
              onChanged: filtrar,
              decoration: const InputDecoration(
                labelText: "Buscar...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtrados.length,
              itemBuilder: (_, i) {
                final a = filtrados[i];
                return Card(
                  child: ListTile(
                    title: Text("${a.nombre} ${a.apellidoPaterno}"),
                    subtitle: Text("Control: ${a.numeroControl}"),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}