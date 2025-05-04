import 'package:delivery_track_app/services/api_service.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) => value == null || value.isEmpty ? 'Informe seu email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) => value == null || value.isEmpty ? 'Informe sua senha' : null,
              ),
              const SizedBox(height: 38),
              _isLoading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _login, child: Text('Entrar')),
              SizedBox(height: 16),
              TextButton(
                onPressed: _toRegister,
                child: const Text('Não tem conta? Click aqui.'),
              ),
            ],
          )
        ),
      ),
    );
   }
}