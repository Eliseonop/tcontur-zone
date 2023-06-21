class User {
  final String username;
  final String firstName;
  final int id;
  final String email;
  final bool isStaff;
  final Empresa? empresa;

  User({
    required this.username,
    required this.firstName,
    required this.id,
    required this.email,
    required this.isStaff,
    required this.empresa,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'first_name': firstName,
      'id': id,
      'email': email,
      'is_staff': isStaff,
      'empresa': empresa?.toJson(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      firstName: json['first_name'],
      id: json['id'],
      email: json['email'],
      isStaff: json['is_staff'],
      empresa: Empresa.fromJson(json['empresa']),
    );
  }
}

class Empresa {
  final int id;
  final String name;
  final String razon;

  Empresa({
    required this.id,
    required this.name,
    required this.razon,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'razon': razon,
    };
  }

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      id: json['id'],
      name: json['name'],
      razon: json['razon'],
    );
  }
}
