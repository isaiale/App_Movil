import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  // Información decodificada del usuario
  Map<String, dynamic>? _decodedToken;

  // Obtener información decodificada del usuario
  Map<String, dynamic>? get decodedToken => _decodedToken;

  // Guardar el token y decodificarlo
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);

    // Decodificar el token JWT y almacenar la información
    _decodedToken = JwtDecoder.decode(token);
  }

  // Cargar el token almacenado y decodificarlo
  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      _decodedToken = JwtDecoder.decode(token);
    }
  }

  // Eliminar el token (para cerrar sesión)
  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _decodedToken = null;
  }

  // Obtener el _id del usuario desde el token decodificado
  String? get userId {
    return _decodedToken?['_id']; // El token debe contener el campo _id del usuario
  }
}






// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

// class UserService {
//   static final UserService _instance = UserService._internal();

//   factory UserService() {
//     return _instance;
//   }

//   UserService._internal();

//   // Información decodificada del usuario
//   Map<String, dynamic>? _decodedToken;

//   // Obtener información decodificada del usuario
//   Map<String, dynamic>? get decodedToken => _decodedToken;

//   // Guardar el token y decodificarlo
//   Future<void> saveToken(String token) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('token', token);

//     // Decodificar el token JWT y almacenar la información
//     _decodedToken = JwtDecoder.decode(token);
//   }

//   // Cargar el token almacenado y decodificarlo
//   Future<void> loadToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     if (token != null) {
//       _decodedToken = JwtDecoder.decode(token);
//     }
//   }

//   // Eliminar el token (para cerrar sesión)
//   Future<void> clearToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     _decodedToken = null;
//   }
// }
