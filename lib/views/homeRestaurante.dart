import 'package:flutter/material.dart';
import 'package:trabalho_final/Firestore/Firebase.dart';
import 'package:trabalho_final/Forms/CadastrarForm.dart';
import '../Components/Botoes.dart';
import '../Components/CaixaTexto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeRestaurante extends StatefulWidget {
  @override
  _HomeRestaurante createState() => _HomeRestaurante();
}

class _HomeRestaurante extends State<HomeRestaurante> {
  // Instância do Firebase
  Firebase firebase = Firebase();

  // Instância dos Botões padrões do sistema
  Botoes botoes = new Botoes();
  String _urlImagemRecuperada;


  void adicionarProduto() {
    Navigator.of(context).pushNamed('/cadastrocardapio');
    print("Não será implementado");
  }

  void visualizarProdutos() {
    Navigator.of(context).pushNamed('/gridviewrestaurante');
  }

  void editarProduto() {
    print("Não será implementado");
  }

  void fazerLogout() {
    // Se deslogar
    firebase.fazerLogout();
    Navigator.of(context).pushNamed('/entrar');
  }
  Future<void> downloadURLExample() async {
    _urlImagemRecuperada = await firebase.pegaImagem('restaurante/logo.png');
    }

  @override
  void initState() {
    super.initState();
    downloadURLExample();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logo App"),
        actions: [
          botoes.pegarBotaoAppBar(Icons.logout, fazerLogout),
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
                /*Container(
                  width: MediaQuery.of(context).size.width - 160.0,
                  height: 160.0,
                  margin: EdgeInsets.symmetric(vertical: 35.0),
                  decoration: BoxDecoration(color: Colors.blue),
                  // Pegar do Banco de Dados
                ),*/
                CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                    _urlImagemRecuperada != null
                        ? NetworkImage(_urlImagemRecuperada)
                        : null
                ),
                // Restaurante
                Container(
                    margin: EdgeInsets.only(bottom: 35.0),
                    child: Text(
                      "Nome do Restaurante",
                      style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                // Ações
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
                  child: botoes.pegarBotaoFormulario(
                      context, "Adicionar Produto", adicionarProduto),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
                  child: botoes.pegarBotaoFormulario(
                      context, "Visualizar Produtos", visualizarProdutos),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
                  child: botoes.pegarBotaoFormulario(
                      context, "Editar Produto", editarProduto),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
