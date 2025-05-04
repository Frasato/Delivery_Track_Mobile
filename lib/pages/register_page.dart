import 'package:delivery_track_app/services/api_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  void _register() async {
    if(!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    bool success = await ApiService.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if(success){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cadastro realizado com sucesso!"))
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao cadastrar, tente novamente!"))
      );
    }
  
  }

  void _sendToLogin(){
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Informe seu nome' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                validator: (value) => value == null || value.isEmpty ? 'Informe seu e-mail' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) => value == null || value.isEmpty ? 'Informe a sua senha' : null,
              ),
              SizedBox(height: 32),
              _isLoading ? CircularProgressIndicator() : ElevatedButton(onPressed: _register, child: Text('Cadastrar')),
              SizedBox(height: 16),
              TextButton(
                onPressed: _sendToLogin,
                child: const Text('Já tem uma conta? Click aqui.'),
              ),
            ],
          )
        ),
      ),
    );
  }

}