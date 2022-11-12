import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _estaEscribiendo = false;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.blue[100],
              child: Text(
                'Te',
                style: TextStyle(
                  fontSize: 12,
                )
              ),
            ),
            SizedBox( height: 3),
            Text('Melissa Flores',
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
      uuid: '123', 
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
  }

  @override
  void dispose() {
    //Off del socket

    for( ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    // TODO: implement dispose
    super.dispose();
  }
}