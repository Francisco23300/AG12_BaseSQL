class Validadores {
  static String? textoVacio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return "Campo obligatorio";
    }
    return null;
  }

  static String? soloNumeros(String? valor) {
    if (valor == null || valor.isEmpty) return "Campo obligatorio";
    if (!RegExp(r'^[0-9]+$').hasMatch(valor)) {
      return "Solo números";
    }
    return null;
  }

  static String? correo(String? valor) {
    if (valor == null || valor.isEmpty) return "Campo obligatorio";
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(valor)) {
      return "Correo inválido";
    }
    return null;
  }
}