

import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  const BotonAzul({
    Key? key, 
    required this.onPressed, 
    required this.buttonText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        primary: Colors.blue,
        shape: const StadiumBorder(),
      ),
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}