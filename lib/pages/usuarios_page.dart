import 'package:chat/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget {

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(
      online: true, 
      email: 'test@test.com', 
      nombre: 'María', 
      uuid: '1'
    ),
    Usuario(
      online: true, 
      email: 'test2@test.com', 
      nombre: 'Melissa', 
      uuid: '2'
    ),
    Usuario(
      online: false, 
      email: 'test3@test.com', 
      nombre: 'Fernando', 
      uuid: '3'
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Nombre',
          style: TextStyle(
            color: Colors.black87
          )
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon( Icons.exit_to_app, color: Colors.black87), 
          onPressed: () {  },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only( right: 10 ),
            child: Icon( Icons.check_circle, color: Colors.blue[400])
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
    await Future.delayed(Duration(milliseconds: 1000));
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
        child: Text(usuario.nombre.substring(0,2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        )
      )
    );
  }

}