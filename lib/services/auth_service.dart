import 'dart:convert';
import 'package:chat/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';

class AuthService with ChangeNotifier {

  late Usuario usuario;
  bool _autenticando = false;
// Create storage
final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando( bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token.toString();
  }  
  
  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }


  // final usuario;
  Future<bool> login( String email, String password ) async {

    autenticando = true;

    final data = {
      'email': email,
      'password': password
    };



    final resp = await http.post(Uri.parse('${Environment.apiUrl}/login'), 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    autenticando = false;
    if ( resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
      //TODO: GUARDAR TOKEN EN LUGAR SEGURO
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }


  Future<bool> register( String nombre, String email, String password ) async {
   autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };
    final resp = await http.post(Uri.parse('${Environment.apiUrl}/login/new'), 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );    
    autenticando = false;
    if ( resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
      //TODO: GUARDAR TOKEN EN LUGAR SEGURO
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      return false;
    }

  }

  Future<bool> isLoggedIn() async {

    final token = await _storage.read(key: 'token');

   final resp = await http.get(Uri.parse('${Environment.apiUrl}/login/renew'), 
      // body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token.toString(),
      }
    );

    if ( resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
      //TODO: GUARDAR TOKEN EN LUGAR SEGURO
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }

  }

  Future _guardarToken (String token) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    // Delete all
    await _storage.delete(key: 'token');
  }
}