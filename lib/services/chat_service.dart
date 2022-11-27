

import 'package:chat/global/environment.dart';
import 'package:chat/models/mensajes_response.dart';
import 'package:http/http.dart' as http;
import 'package:chat/services/auth_service.dart';
import 'package:chat/models/usuario.dart';
import 'package:flutter/material.dart';

class ChatService with ChangeNotifier {

  late Usuario usuarioPara;

  Future getChat( String usuarioID) async {

    try {
      
      final resp = await http.get(Uri.parse('${Environment.apiUrl}/mensajes/$usuarioID'),
        headers: {
          'Content-type': 'application/json',
          'x-token': await AuthService.getToken(),
        }
       );
      
      final mensajesResponse = mensajesResponseFromJson( resp.body );
      return mensajesResponse.mensajes;

    } catch ( error ) {
      return [];
    }
  }

}

