import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:trabalho_final/Firestore/Firebase.dart';
import 'package:trabalho_final/Forms/EntrarForm.dart';
import 'package:trabalho_final/model/Usuario.dart';
import '../Components/Botoes.dart';
import '../Components/CaixaTexto.dart';

class Entrar extends StatefulWidget {
  @override
  _EntrarState createState() => _EntrarState();
}

class _EntrarState extends State<Entrar> {
  Firebase firebase = Firebase();
  EntrarForm entrarForm = new EntrarForm();
  Botoes botoes = new Botoes();
  CaixaTexto caixaTexto = new CaixaTexto();
  final formKey = new GlobalKey<FormState>();

  Future<void> fazerLogin() async{

    // Pegar dados do form
    FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();

      // Fazer Login no Firebase
      await firebase.fazerLogin(formulario: entrarForm);
      //sleep(const Duration(seconds:15));
      String userid = firebase.pegarUserId();
      print("userId: "+ userid);

      Future<Usuario> u =  firebase.pegarUsuarios(id: userid);
      u.then((value)  async{
        print("Tipo de usuario: "+ value.pegarTipo().toString());
        value.pegarTipo() == 0
            ? Navigator.of(context).pushNamed('/r')
            : Navigator.of(context).pushNamed('/c');});
    }
  }

  void fazerCadastro() {
    // Navegar para a tela de Cadastro
    Navigator.of(context).pushNamed('/cadastrar');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrar"),
        actions: [
          botoes.pegarBotaoAppBar(Icons.add, fazerCadastro),
        ],
      ),
      body: Center(
        child: Container(
            width: MediaQuery.of(context).size.width - 40.0,
            height: MediaQuery.of(context).size.height - 160.0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo
                  Container(
                    width: MediaQuery.of(context).size.width - 160.0,
                    height: 150.0,
                    margin: EdgeInsets.symmetric(vertical: 50.0),
                    decoration: BoxDecoration(color: Colors.blue),
                    // Pegar do Banco de Dados
                  ),
                  // Formulário
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: caixaTexto.pegarCaixaTextoPadrao("Email",
                                validando: (String email) {
                                  if (email.isEmpty) {
                                    return "Email não pode ser vazio!";
                                  } else {
                                    // Validação
                                  }
                                  return null;
                                },
                                salvando: (String email) =>
                                    entrarForm.adicionarEmail(email)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: caixaTexto.pegarCaixaTextoPadrao("Senha",
                                validando: (String password) {
                                  if (password.isEmpty) {
                                    return "Senha não pode ser vazio!";
                                  } else {
                                    // Validação
                                  }
                                  return null;
                                },
                                salvando: (String password) =>
                                    entrarForm.adicionarSenha(password),
                                ehSenha: true),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: botoes.pegarBotaoFormulario(
                                context, "Entrar", fazerLogin),
                          ),
                        ],
                      ))
                ],
              ),
            )),
      ),
    );
  }
}
