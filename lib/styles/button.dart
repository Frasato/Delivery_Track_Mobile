import 'package:flutter/material.dart';

final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color(0xffffffff),
  elevation: 0,
  minimumSize: Size(177, 50),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10))
  ),
  textStyle: TextStyle(
    fontWeight: FontWeight.bold
  ),
  foregroundColor: Colors.lightBlue.shade700
);