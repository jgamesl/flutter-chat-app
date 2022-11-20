import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/boton_azul.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo( titulo: 'Messenger',),
                _Form(),
                const Labels(texto1:'No tienes cuenta?', texto2: 'Crea una ahora', ruta: 'register'),
        
                const Text(
                  'Términos o condiciones de uso',
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                  )  
                )
              ],
            ),
          ),
        ),
      )
   );
  }
}


class _Form extends StatefulWidget {

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return Container(
      
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric( horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),
          // CustomInput(),
          // CustomInput(),
          // TextField(),
          
          // TODO: crear boton
          BotonAzul(onPressed:  authService.autenticando ? null : () async {

                FocusScope.of(context).unfocus();
                final loginOk = await authService.login(emailCtrl.text.trim() , passCtrl.text.trim());
                
                if (loginOk) {
                  //TODO:  Navegar otra pantalla conectar a socket server
                  Navigator.pushReplacementNamed(context, 'usuarios');
                } else {
                  // Mostrar alerta
                  mostrarAlerta(
                    context, 
                    'Login incorrecto', 
                    'Revise sus credenciales nuevamente'
                  );
                }
            }, buttonText: 'Ingresar'
          )
        ],
      ),
    );
  }
}
