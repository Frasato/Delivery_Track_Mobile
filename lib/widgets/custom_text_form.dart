import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget{
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final IconData icon;

  const CustomTextForm({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.validator,
    required this.icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        prefixIconColor: Colors.lightBlue[600],
        hintText: labelText,
        hintStyle: TextStyle(fontWeight: FontWeight.bold),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent)
        ),
        errorStyle: TextStyle(
          color: Colors.amber,
          fontSize: 17
        )
      ),
      validator: validator,
    );
  }
}