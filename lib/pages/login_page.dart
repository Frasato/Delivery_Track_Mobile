import 'package:delivery_track_app/services/api_service.dart';
import 'package:delivery_track_app/styles/button.dart';
import 'package:delivery_track_app/styles/text_button_style.dart';
import 'package:delivery_track_app/widgets/custom_text_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  void _login() async{
    if(!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

      String? success = await ApiService.login(
      _emailController.text,
      _passwordController.text
    );

    setState(() {
      _isLoading = false;
    });

    if(success != null){
      Navigator.pushReplacementNamed(context, '/home');
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao fazer login, tente novamente!")),
      );
    }
  }

  void _toRegister(){
    Navigator.pushReplacementNamed(context, '/register');
  }

   @override
   Widget build(BuildContext context){
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.fromARGB(100, 7, 93, 232), Color.fromARGB(100, 40, 161, 209)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextForm(
                    controller: _emailController,
                    labelText: 'E-mail', 
                    validator: (value) => value == null || value.isEmpty ? 'Informe seu email' : null,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  CustomTextForm(
                    controller: _passwordController,
                    labelText: 'Senha',
                    validator: (value) => value == null || value.isEmpty ? 'Informe a senha' : null,
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 38),
                  _isLoading ? const CircularProgressIndicator() 
                    : 
                    ElevatedButton(
                      onPressed: _login,
                      style: buttonStyle,
                      child: Text('Entrar')
                    ),
                  SizedBox(height: 25),
                  TextButton(
                    onPressed: _toRegister,
                    style: textButtonStyle,
                    child: const Text('Não tem conta? Click aqui.'),
                  ),
                ],
              )
            ),
          ),
        ),
      ),
    );
   }
}