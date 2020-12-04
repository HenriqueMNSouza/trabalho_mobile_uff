import 'package:flutter/material.dart';
import 'package:trabalho_final/Components/Botoes.dart';
import 'package:trabalho_final/Components/QrCode.dart';
import 'package:trabalho_final/Firestore/Firebase.dart';

class HomeCliente extends StatefulWidget {
  @override
  _HomeClienteState createState() => _HomeClienteState();
}

class _HomeClienteState extends State<HomeCliente> {
  // Instância dos Botões padrões do sistema
  Botoes botoes = new Botoes();
  Firebase firebase = new Firebase();

  void fazerLogout() {
    // Logout
    firebase.fazerLogout();
    Navigator.of(context).pushNamed('/entrar');
  }

  void verConta() {
    Navigator.of(context).pushNamed('/conta');
  }

  void pagarConta() {
    firebase.pagarConta();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scannear QrCode"),
        actions: [
          botoes.pegarBotaoAppBar(Icons.logout, fazerLogout),
        ],
      ),
      body: Center(
        child:
         SingleChildScrollView(
           child: Column(
             children: [

             QrCode(),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
                child: botoes.pegarBotaoFormulario(
                    context, "Ver conta", verConta),
              ),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
                child: botoes.pegarBotaoFormulario(
                    context, "Pagar conta", pagarConta),
              ),


        ] )
      )
      ),
    );
  }
}
