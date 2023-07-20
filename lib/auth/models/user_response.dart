class UserRes {
  int id;
  String cargo;
  String email;
  String empresa;
  bool genero;
  String nombre;
  String token;
  String username;

  UserRes({
    required this.id,
    required this.cargo,
    required this.email,
    required this.empresa,
    required this.genero,
    required this.nombre,
    required this.token,
    required this.username,
  });

  UserRes.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        cargo = json['cargo'],
        email = json['email'],
        empresa = json['empresa'],
        genero = json['genero'],
        nombre = json['nombre'],
        token = json['token'],
        username = json['username'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cargo'] = cargo;
    data['email'] = email;
    data['empresa'] = empresa;
    data['genero'] = genero;
    data['nombre'] = nombre;
    data['token'] = token;
    data['username'] = username;
    return data;
  }
}
