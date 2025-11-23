class Alumno {
  int? id;
  String numeroControl;
  String apellidoPaterno;
  String apellidoMaterno;
  String telefono;
  String correo;

  String nombre;

  Alumno({
    this.id,
    required this.numeroControl,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.telefono,
    required this.correo,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "numeroControl": numeroControl,
      "nombre": nombre,
      "apellidoPaterno": apellidoPaterno,
      "apellidoMaterno": apellidoMaterno,
      "telefono": telefono,
      "correo": correo,
    };
  }

  static Alumno fromMap(Map<String, dynamic> map) {
    return Alumno(
      id: map["id"],
      numeroControl: map["numeroControl"],
      nombre: map["nombre"],
      apellidoPaterno: map["apellidoPaterno"],
      apellidoMaterno: map["apellidoMaterno"],
      telefono: map["telefono"],
      correo: map["correo"],
    );
  }
}