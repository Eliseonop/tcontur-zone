class EmpresaResponse {
  int id;
  String codigo;
  String nombre;

  EmpresaResponse({
    required this.id,
    required this.codigo,
    required this.nombre,
  });

  factory EmpresaResponse.fromJson(Map<String, dynamic> json) {
    return EmpresaResponse(
      id: json['id'],
      codigo: json['codigo'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'nombre': nombre,
    };
  }

  String getNameNotSpace() {
    // Remover espacios al inicio y al final del nombre
    String nombreSinEspacios = nombre.trim();

    // Remover espacios en el medio del nombre
    nombreSinEspacios = nombreSinEspacios.replaceAll(' ', '');

    return nombreSinEspacios;
  }
}
