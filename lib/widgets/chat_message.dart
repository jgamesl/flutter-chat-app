

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class ChatMessage extends StatelessWidget {

  final String texto;
  final String uuid;
  final AnimationController animationController;

  const ChatMessage({
    Key? key, 
    required this.texto, 
    required this.uuid,
    required this.animationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: uuid == authService.usuario.uuid
            ? _myMessage()
            : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only( bottom: 5, left: 50, right: 5),
        padding: EdgeInsets.all(8.0),
        child: Text( this.texto,
          style: TextStyle(
            color: Colors.white
          ), 
        ),
        decoration: BoxDecoration(
          color: Color(0xff4D9ef6),
          borderRadius: BorderRadius.circular(20)
        )
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only( bottom: 5, right: 50, left: 5),
        padding: EdgeInsets.all(8.0),
        child: Text( this.texto,
          style: TextStyle(
            color: Colors.black87
          ), 
        ),
        decoration: BoxDecoration(
          color: Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20)
        )
      ),
    );
  }
}