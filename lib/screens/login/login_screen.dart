import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcontur_zone/auth/models/empresas_response.dart';
import 'package:tcontur_zone/provider/provider_empresa.dart';
import 'package:tcontur_zone/provider/provider_user.dart';
import 'package:tcontur_zone/auth/service/auth_service.dart';
import 'package:tcontur_zone/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  List<EmpresaResponse> empresas = [];
  EmpresaResponse? empresaSelect;
  final AuthService authService = AuthService();
  bool isLoading = false;

  late UserProvider userProvider;
  late EmpresaProvider empresasProvider;
  void goToScreen(BuildContext context, Widget widget) {
    Navigator.of(context).pop();
  }

  @override
  initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    empresasProvider = Provider.of<EmpresaProvider>(context, listen: false);
    getEmpresas();
  }

  Future<void> login(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;
    // final empresaSelect = '1';

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });
    try {
      if (empresaSelect == null) {
        throw Exception('Debe seleccionar una empresa');
      } else if (username.isEmpty || password.isEmpty) {
        throw Exception('Debe ingresar usuario y contraseña');
      } else if (empresaSelect?.nombre == null) {
        throw Exception('Debe seleccionar una empresa');
      } else {
        String empresaLogin = empresaSelect?.nombre ?? '';
        await userProvider.login(username, password, empresaLogin);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } catch (error) {
      print('error 42 login' + error.toString());
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error de inicio de sesión'),
          content: Text(
            'Hubo un error al iniciar sesión. Por favor, inténtalo de nuevo. $error',
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getEmpresas() async {
    await empresasProvider.fetchEmpresas();
    setState(() {
      empresas = empresasProvider.empresas;
    });
    print('Empresas: ${empresas.map((e) => e.nombre)}');
  }

  Widget buildUsername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Usuario',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 50,
          child: TextFormField(
            controller: usernameController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.black87,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.person,
                color: Color(0x990066a9),
              ),
              hintText: 'Usuario',
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contraseña',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 50,
          child: TextFormField(
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            style: const TextStyle(
              color: Colors.black87,
            ),
            obscureText: true,
            obscuringCharacter: '*',
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0x990066a9),
              ),
              hintText: 'Contraseña',
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoginButton(BuildContext context, bool isEnabled) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading || !isEnabled ? null : () => login(context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.all(15),
          elevation: 5,
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEmpresaSelected = empresaSelect != null;

    return Scaffold(
      backgroundColor: const Color(0xff2d3e50),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff5f6d8e),
                      Color(0xff4b5a75),
                      Color(0xff374a66),
                      Color(0xff263449),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 120,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', width: 560),
                    // const SizedBox(height: 20),
                    EmpresaDropdown(
                      empresas: empresas,
                      selectedEmpresa: empresaSelect,
                      onChanged: (newValue) {
                        final empresaProvider = Provider.of<EmpresaProvider>(
                            context,
                            listen: false);
                        print(
                            'Empresa: ${empresaProvider.empresaSelect?.nombre}');
                        empresaProvider.setEmpresaSelect(newValue);
                        setState(() {
                          // Update the local variable to reflect the change
                          empresaSelect = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    buildUsername(),
                    const SizedBox(height: 20),
                    buildPassword(),
                    buildLoginButton(context, isEmpresaSelected ? true : false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmpresaDropdown extends StatelessWidget {
  final List<EmpresaResponse> empresas;
  final EmpresaResponse? selectedEmpresa;
  final Function(EmpresaResponse?) onChanged;

  const EmpresaDropdown({
    super.key,
    required this.empresas,
    required this.selectedEmpresa,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Empresa',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<EmpresaResponse>(
            dropdownColor: Colors.white,
            value: selectedEmpresa,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 20,
            elevation: 10,
            onChanged: onChanged,
            items: empresas.map<DropdownMenuItem<EmpresaResponse>>(
              (value) {
                return DropdownMenuItem<EmpresaResponse>(
                  value: value,
                  child: Text(
                    value.nombre,
                    style: TextStyle(color: Colors.black87),
                  ),
                );
              },
            ).toList(),
            decoration: InputDecoration(
              hintText: 'Empresa',
              hintStyle: TextStyle(color: Colors.black38),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.business,
                color: Color(0x990066a9),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
