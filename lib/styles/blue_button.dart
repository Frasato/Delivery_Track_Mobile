import 'package:flutter/material.dart';

final ButtonStyle blueButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color.fromARGB(255, 40, 144, 255),
  elevation: 0,
  minimumSize: Size(177, 50),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10))
  ),
  textStyle: TextStyle(
    fontWeight: FontWeight.bold
  ),
  foregroundColor: Colors.white
);