import 'package:chat/models/usuario.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../services/auth_service.dart';


class UsuariosPage extends StatefulWidget {

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuariosService = UsuariosService();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  @override
  void initState() {
    // TODO: implement initState
    _cargarUsuarios();
    super.initState();
  }

  // final usuarios = [
  //   Usuario(
  //     online: true, 
  //     nombre: 'Joel',
  //     email: 'test@test.com', 
  //     uuid: '1'
  //   ),
  //   Usuario(
  //     online: true, 
  //     nombre: 'Maria',
  //     email: 'test2@test.com', 
  //     uuid: '2'
  //   ),
  //   Usuario(
  //     online: false, 
  //     nombre: 'Luis',
  //     email: 'test3@test.com',
  //     uuid: '3'
  //   )
  // ];


  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final usuario = authService.usuario;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          usuario.nombre,
          style: TextStyle(
            color: Colors.black87
          )
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon( Icons.exit_to_app, color: Colors.black87), 
          onPressed: () {
            //TODO: desconectarnos del socket server
            // authService.logout();
            socketService.disconnect();
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only( right: 10 ),
            child: ( socketService.serverStatus == ServerStatus.Online )
              ? Icon( Icons.check_circle, color: Colors.blue[400])
              : Icon( Icons.offline_bolt, color: Colors.red)
            // child: Icon( Icons.check_circle, color: Colors.red)
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon( Icons.check, color: Colors.blue[400] ),
          waterDropColor: Colors.blue,
        ),
        child: _listViewUsuarios(usuarios: usuarios)
      )
   );
  }


  _cargarUsuarios() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    usuarios = await usuariosService.getUsuarios();
    setState(() {
      
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();

  }
}

class _listViewUsuarios extends StatelessWidget {
  const _listViewUsuarios({
    Key? key,
    required this.usuarios,
  }) : super(key: key);

  final List<Usuario> usuarios;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTile(usuario: usuarios[i]), 
      separatorBuilder: (_, i) => Divider(), 
      itemCount: usuarios.length
    );
  }
}

class _usuarioListTile extends StatelessWidget {



  const _usuarioListTile({
    Key? key,
    required this.usuario,
  }) : super(key: key);

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(usuario.email.substring(0,2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        )
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
        // print(usuario.nombre);
      },
    );
  }

}