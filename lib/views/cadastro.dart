import 'package:flutter/material.dart';
import 'package:trabalho_final/Firestore/Firebase.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../Components/Botoes.dart';
import '../Components/CaixaTexto.dart';
import '../model/Usuario.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  Firebase firebase = new Firebase();
  Usuario usuario = new Usuario();
  Botoes botoes = new Botoes();
  CaixaTexto caixaTexto = new CaixaTexto();
  final formKey = new GlobalKey<FormState>();


  Future<void> fazerCadastro() async{
    // Pegar dados do form
    final form = formKey.currentState;
      if (form.validate()) {
        form.save();

        int maxid = 0;
        await firebase.pegarMaioId("usuarios", "id").then((value) {
          maxid = value+1;
          usuario.adicionarId(maxid.toString());
        });

        if (usuario.pegarTipo() == null) {
          usuario.adicionarTipo(1);
        }else{
          int maxidrest = 0;
          await firebase.pegarMaioId("usuarios", "id_restaurante").then((value) {
            maxidrest = value+1;
            usuario.adicionarIdRestaurante(maxidrest.toString());
          });

        }

      // Autenticar Usuário
      firebase.criarUsuario(usuario);

      // Navegar para tela de Home (Cliente/Restaurante)
      usuario.pegarTipo() == 0
          ? Navigator.of(context).pushNamed('/r')
          : Navigator.of(context).pushNamed('/c');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar"),
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
                            child: caixaTexto.pegarCaixaTextoPadrao("Nome",
                                validando: (String nome) {
                                  if (nome.isEmpty) {
                                    return "Nome não pode ser vazio!";
                                  } else {
                                    // Validação
                                  }
                                  return null;
                                },
                                salvando: (String nome) =>
                                    usuario.adicionarNome(nome)),
                          ),
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
                                    usuario.adicionarEmail(email)),
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
                                    usuario.adicionarSenha(password),
                                ehSenha: true),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: ToggleSwitch(
                              minWidth: 150.0,
                              initialLabelIndex: 1,
                              cornerRadius: 20.0,
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey,
                              inactiveFgColor: Colors.white,
                              labels: ['Restaurante', 'Cliente'],
                              icons: [Icons.restaurant, Icons.person],
                              activeBgColors: [Colors.red, Colors.blue],
                              onToggle: (tipo) {
                                usuario.adicionarTipo(tipo);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: botoes.pegarBotaoFormulario(
                                context, "Cadastrar", fazerCadastro),
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
