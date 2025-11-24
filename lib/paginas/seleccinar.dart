import 'package:flutter/material.dart';
import '../base_datos/gestor_base_datos.dart';
import '../modelos/alumno.dart';
import 'actualizar.dart';

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

  // Carga todos los alumnos
  Future<void> cargar() async {
    todos = await GestorBaseDatos.instancia.listarAlumnos();
    filtrados = todos;
    setState(() {});
  }

  // Filtrar alumnos según el texto ingresado
  void filtrar(String txt) {
    txt = txt.toLowerCase();
    setState(() {
      filtrados = todos.where((a) {
        return a.nombre.toLowerCase().contains(txt) ||
            a.apellidoPaterno.toLowerCase().contains(txt) ||
            a.apellidoMaterno.toLowerCase().contains(txt) ||
            a.correo.toLowerCase().contains(txt) ||
            a.telefono.contains(txt) ||
            a.numeroControl.contains(txt);
      }).toList();
    });
  }

  // Mostrar opciones al seleccionar un alumno
  void mostrarOpciones(Alumno a) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text("Editar"),
              onTap: () {
                Navigator.pop(context); // Cierra el modal
                irAActualizar(a);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Eliminar"),
              onTap: () {
                Navigator.pop(context); 
              },
            ),
          ],
        );
      },
    );
  }

  void irAActualizar(Alumno a) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PaginaActualizar(alumno: a)),
    );
    cargar(); 
  }

 
  void irAEliminar(Alumno a) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar"),
        content: Text("¿Eliminar a ${a.nombre} ${a.apellidoPaterno}?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Eliminar")),
        ],
      ),
    );

    if (confirmado == true) {
      await GestorBaseDatos.instancia.eliminarAlumno(a.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alumno eliminado")),
      );
      cargar();
    }
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
            child: filtrados.isEmpty
                ? const Center(child: Text("No se encontraron alumnos"))
                : ListView.builder(
                    itemCount: filtrados.length,
                    itemBuilder: (_, i) {
                      final a = filtrados[i];
                      return Card(
                        child: ListTile(
                          title: Text("${a.nombre} ${a.apellidoPaterno}"),
                          subtitle: Text("Control: ${a.numeroControl}"),
                          onTap: () => mostrarOpciones(a),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}