import 'package:delivery_track_app/services/api_service.dart';
import 'package:delivery_track_app/styles/button.dart';
import 'package:delivery_track_app/styles/text_button_style.dart';
import 'package:delivery_track_app/widgets/custom_text_form.dart';
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.fromARGB(100, 7, 93, 232), Color.fromARGB(100, 40, 161, 209)],
        )
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
                    controller: _nameController,
                    labelText: 'Digite seu nome completo',
                    validator: (value) => value == null || value.isEmpty ? 'Informe seu nome' : null,
                    icon: Icons.person
                  ),
                  SizedBox(height: 16),
                  CustomTextForm(
                    controller: _emailController,
                    labelText: 'Digite seu melhor email',
                    validator: (value) => value == null || value.isEmpty ? 'Informe seu email' : null,
                    icon: Icons.email
                  ),
                  SizedBox(height: 16),
                  CustomTextForm(
                    controller: _passwordController,
                    labelText: 'Digite uma senha segura',
                    validator: (value) => value == null || value.isEmpty ? 'Informe sua senha' : null,
                    icon: Icons.lock
                  ),
                  SizedBox(height: 32),
                  _isLoading ? CircularProgressIndicator() : ElevatedButton(onPressed: _register, style: buttonStyle, child: Text('Cadastrar')),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: _sendToLogin,
                    style: textButtonStyle,
                    child: const Text('Já tem uma conta? Click aqui.'),
                  ),
                ],
              )
            ),
          ),
        )
      ),
    );
  }

}