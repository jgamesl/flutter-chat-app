import 'dart:io';

import 'package:chat/models/mensajes_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;
  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje );
    _cargarHistorial(chatService.usuarioPara.uuid);
  }

  _cargarHistorial(String usuarioId) async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    List<Mensaje> chat = await chatService.getChat(usuarioId);

    final history = chat.map((m) => ChatMessage(
      texto: m.mensaje,
      uuid: m.from,
      animationController: new AnimationController(vsync: this, duration: Duration( milliseconds: 0))..forward(),

    ));

    setState(() {
      _messages.insertAll(0, history);
    });

  }

  

  void _escucharMensaje( dynamic payload) {
    print('Tengo mensaje! $payload');
    ChatMessage message = ChatMessage(
      texto: payload['mensaje'], 
      uuid: payload['from'], 
      animationController: AnimationController( 
        vsync: this,
        duration: Duration(milliseconds: 300)
      ));

      setState(() {
        _messages.insert(0, message);
      });

      // notifyListeners();
      message.animationController.forward();
  }

  List<ChatMessage> _messages = [
    // ChatMessage(
    //   uuid: '123',
    //   texto: 'Hola Mundo',
    // ),
    // ChatMessage(
    //   uuid: '124',
    //   texto: 'Hola Noooo ksjdfkajskdj kasjdknanlñs ncpwjiepq slllamzpn',
    // ),
    // ChatMessage(
    //   uuid: '123',
    //   texto: 'Hola weon',
    // ),
    // ChatMessage(
    //   uuid: '123',
    //   texto: 'Hola Jeje',
    // )
  ];


  @override
  Widget build(BuildContext context) {


    // final chatService = Provider.of<ChatService>(context, listen: false);
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.blue[100],
              child: Text(
                usuarioPara.nombre.substring(0,2),
                style: TextStyle(
                  fontSize: 12,
                )
              ),
            ),
            SizedBox( height: 3),
            Text(usuarioPara.nombre,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12
              )
            )
          ]
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: _messages.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, i) => _messages[i],
                reverse: true
              )
            ),

            Divider( height: 1,),
            // todo caja de texto
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ]
        )
      ),
   );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric( horizontal: 8.0 ),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: ( String texto ) {
                  // cuando hay valor pa postear
                  setState(() {
                    if( texto.trim().length > 0) {
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode
              )
            ),

            // Boton enviar
            Container(
              margin: EdgeInsets.symmetric( horizontal: 4.0),
              child: !Platform.isIOS 
                ? CupertinoButton(
                  child: Text('Enviar'), 
                  onPressed: _estaEscribiendo 
                    ? () => _handleSubmit(_textController.text.trim())
                    : null
                )
                : Container(
                  margin: EdgeInsets.symmetric( horizontal: 4.0 ),
                  child: IconTheme(
                    data: IconThemeData( color: Colors.blue[400]),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon( Icons.send),
                      onPressed: _estaEscribiendo 
                        ? () => _handleSubmit(_textController.text.trim())
                        : null
                    ),
                  ),
                )
            )


          ],
        )
      )
    );
  }

  _handleSubmit(String texto) {
    if (texto.trim().length == 0) return;
    final newMessage = ChatMessage(
      uuid: authService.usuario.uuid, 
      texto: texto,
      animationController: AnimationController(
        vsync: this, 
        duration: Duration( milliseconds: 200)
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    print( texto );
    setState(() {
      _estaEscribiendo = false;
      _textController.clear();
      _focusNode.requestFocus();
    });
    socketService.emit('mensaje-personal', {
      'from': authService.usuario.uuid,
      'to': chatService.usuarioPara.uuid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    //Off del socket

    for( ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    socketService.socket.off('mensaje-personal');
    // TODO: implement dispose
    super.dispose();
  }
}