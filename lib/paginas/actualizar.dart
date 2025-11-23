import 'package:flutter/material.dart';
import '../base_datos/gestor_base_datos.dart';
import '../modelos/alumno.dart';
import '../utilidades/validadores.dart';

class PaginaActualizar extends StatefulWidget {
  const PaginaActualizar({super.key});

  @override
  State<PaginaActualizar> createState() => _PaginaActualizarState();
}

class _PaginaActualizarState extends State<PaginaActualizar> {
  List<Alumno> alumnos = [];
  Alumno? seleccionado;

  final formKey = GlobalKey<FormState>();

  final nombre = TextEditingController();
  final apellidoPaterno = TextEditingController();
  final apellidoMaterno = TextEditingController();
  final telefono = TextEditingController();
  final correo = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    alumnos = await GestorBaseDatos.instancia.listarAlumnos();
    setState(() {});
  }

  void cargarDatos(Alumno a) {
    seleccionado = a;
    nombre.text = a.nombre;
    apellidoPaterno.text = a.apellidoPaterno;
    apellidoMaterno.text = a.apellidoMaterno;
    telefono.text = a.telefono;
    correo.text = a.correo;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Actualizar Alumno")),
      body: Row(
        children: [
          // LISTA
          Expanded(
            flex: 1,
            child: ListView(
              children: alumnos.map((a) {
                return ListTile(
                  title: Text("${a.nombre} (${a.numeroControl})"),
                  onTap: () => cargarDatos(a),
                );
              }).toList(),
            ),
          ),

          // FORMULARIO
          Expanded(
            flex: 2,
            child: seleccionado == null
                ? const Center(child: Text("Selecciona un alumno"))
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: ListView(
                        children: [
                          campo(nombre, "Nombre", Validadores.textoVacio),
                          campo(apellidoPaterno, "Apellido paterno",
                              Validadores.textoVacio),
                          campo(apellidoMaterno, "Apellido materno",
                              Validadores.textoVacio),
                          campo(telefono, "Teléfono", Validadores.soloNumeros),
                          campo(correo, "Correo", Validadores.correo),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: actualizar,
                            child: const Text("Actualizar"),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget campo(TextEditingController c, String texto, Function validador) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: c,
        validator: (v) => validador(v),
        decoration:
            InputDecoration(labelText: texto, border: OutlineInputBorder()),
      ),
    );
  }

  Future<void> actualizar() async {
    if (!formKey.currentState!.validate()) return;

    final nuevo = Alumno(
      id: seleccionado!.id,
      nombre: nombre.text.toUpperCase(),
      apellidoPaterno: apellidoPaterno.text.toUpperCase(),
      apellidoMaterno: apellidoMaterno.text.toUpperCase(),
      telefono: telefono.text,
      correo: correo.text,
      numeroControl: seleccionado!.numeroControl,
    );

    await GestorBaseDatos.instancia.actualizarAlumno(nuevo);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Alumno actualizado")),
    );

    await cargar();
  }
}