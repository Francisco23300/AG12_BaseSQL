import 'package:flutter/material.dart';
import '../base_datos/gestor_base_datos.dart';
import '../modelos/alumno.dart';
import '../utilidades/validadores.dart';

class PaginaInsertar extends StatefulWidget {
  const PaginaInsertar({super.key});

  @override
  State<PaginaInsertar> createState() => _PaginaInsertarState();
}

class _PaginaInsertarState extends State<PaginaInsertar> {
  final formKey = GlobalKey<FormState>();

  final nombre = TextEditingController();
  final apellidoPaterno = TextEditingController();
  final apellidoMaterno = TextEditingController();
  final telefono = TextEditingController();
  final correo = TextEditingController();
  final numeroControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Insertar alumno")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              campo(nombre, "Nombre", Validadores.textoVacio),
              campo(apellidoPaterno, "Apellido paterno", Validadores.textoVacio),
              campo(apellidoMaterno, "Apellido materno", Validadores.textoVacio),
              campo(telefono, "Teléfono", Validadores.soloNumeros),
              campo(correo, "Correo", Validadores.correo),
              campo(numeroControl, "Número de control", Validadores.soloNumeros),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: insertar,
                child: const Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget campo(TextEditingController c, String texto, Function validador) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        validator: (v) => validador(v),
        decoration: InputDecoration(
          labelText: texto,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

 Future<void> insertar() async {
  if (!formKey.currentState!.validate()) return;

  // Validar número de control
  final existe = await GestorBaseDatos.instancia.existeNumeroControl(numeroControl.text);

  if (existe) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(" El número de control ya existe")),
    );
    return;
  }

  final nuevo = Alumno(
    nombre: nombre.text.toUpperCase(),
    apellidoPaterno: apellidoPaterno.text.toUpperCase(),
    apellidoMaterno: apellidoMaterno.text.toUpperCase(),
    telefono: telefono.text,
    correo: correo.text.toLowerCase(),
    numeroControl: numeroControl.text,
  );

  await GestorBaseDatos.instancia.insertarAlumno(nuevo);

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Alumno insertado correctamente ✔")),
  );

  await Future.delayed(const Duration(milliseconds: 500));
 if (!mounted) return;
  Navigator.pop(context);
}
}