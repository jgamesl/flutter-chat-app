


// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    Usuario({
        required this.email,
        required this.nombre,
        required this.online,
        required this.uuid,
    });

    String email;
    String nombre;
    bool online;
    String uuid;

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        email: json["email"],
        nombre: json["nombre"],
        online: json["online"],
        uuid: json["uuid"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "nombre": nombre,
        "online": online,
        "uuid": uuid,
    };
}
