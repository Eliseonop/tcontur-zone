import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // 1. Importa el paquete shared_preferences.
import 'package:tcontur_zone/auth/models/empresas_response.dart';



class EmpresaProvider extends ChangeNotifier {
  String apiUrl = dotenv.get('API_URL_URBANITO',fallback: "");

  List<EmpresaResponse> _empresas = [];
  EmpresaResponse? _empresaSelect;

  List<EmpresaResponse> get empresas => _empresas;
  Future<EmpresaResponse?> getSelectedEmpresa() async {
    // Verifica si hay una empresa seleccionada guardada en las preferencias compartidas.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? empresaJson = prefs.getString(_selectedEmpresaKey);

    if (empresaJson != null) {
      Map<String, dynamic> empresaData = jsonDecode(empresaJson);
      _empresaSelect = EmpresaResponse.fromJson(empresaData);
      notifyListeners();
      return _empresaSelect;
    } else {
      return null;
    }
  }

  // 2. Define la clave única para identificar la empresa seleccionada en las preferencias compartidas.
  static const String _selectedEmpresaKey = 'selectedEmpresa';

  // Método para guardar la empresa seleccionada en las preferencias compartidas.
  Future<void> saveSelectedEmpresa(EmpresaResponse empresa) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_selectedEmpresaKey, jsonEncode(empresa.toJson()));
  }

  // Método para verificar y asignar la empresa seleccionada si está presente en las preferencias compartidas.
  Future<void> checkSelectedEmpresa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? empresaJson = prefs.getString(_selectedEmpresaKey);

    if (empresaJson != null) {
      Map<String, dynamic> empresaData = jsonDecode(empresaJson);
      _empresaSelect = EmpresaResponse.fromJson(empresaData);
      notifyListeners();
    }
  }

  void setEmpresaSelect(EmpresaResponse? empresa) {
    _empresaSelect = empresa;
    // 3. Guarda la empresa seleccionada en las preferencias compartidas cada vez que se establece.
    if (empresa != null) {
      saveSelectedEmpresa(empresa);
    }
    notifyListeners();
  }

  Future<void> fetchEmpresas() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/tracker/empresas'));

      if (response.statusCode == 200) {
        final List<dynamic> empresasData = jsonDecode(response.body);
        _empresas =
            empresasData.map((data) => EmpresaResponse.fromJson(data)).toList();
      } else {
        // Manejo de errores, lanzar una excepción, etc.
        throw Exception('Error al obtener la lista de empresas');
      }
    } catch (e) {
      // Manejo de errores, lanzar una excepción, etc.
      throw Exception('Error al obtener la lista de empresas: $e');
    }

    // Al final de la carga de empresas, verifica si hay una empresa seleccionada guardada.
    await checkSelectedEmpresa();

    notifyListeners();
  }

  // Constructor para llamar al método fetchEmpresas al instanciar el provider.
  EmpresaProvider() {
    fetchEmpresas();
  }
}
