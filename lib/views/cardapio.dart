import 'package:flutter/material.dart';
import 'package:trabalho_final/Components/Carrossel.dart';
import 'package:trabalho_final/Firestore/Firebase.dart';
import 'package:trabalho_final/Forms/EntrarForm.dart';
import 'package:trabalho_final/model/ItemConta.dart';
import '../Components/Botoes.dart';
import '../Components/CaixaTexto.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Cardapio extends StatefulWidget {
  @override
  final String idRest;
  Cardapio({Key key, @required this.idRest}) : super(key : key);
  _CardapioState createState() => _CardapioState();
}

class _CardapioState extends State<Cardapio> {
  Firebase firebase = Firebase();
  EntrarForm entrarForm = new EntrarForm();
  Botoes botoes = new Botoes();
  CaixaTexto caixaTexto = new CaixaTexto();
  final formKey = new GlobalKey<FormState>();
  Carrossel carrossel = new Carrossel();
  List<String> _urlImagemRecuperada =[''] ;

  void fazerPedido() {
    // Reune os produtos do pedido

    // Testes:
    Map<String, dynamic> map = {
      "emAberto": true,
      "id_cardapio": 4,
      "id_usuario": firebase.pegarUserId()
    };
  //====== Informação precisa ser recuperada de acordo com a imagem que o usuario escolher.

    firebase.salvarDadosBD(colecao: "conta", dados: map) ;
    Navigator.of(context).pushNamed('/conta');
  }

  void pagarConta(){
    String userid = firebase.pegarUserId();
    print("userId: "+ userid);
    firebase.pagarConta();
  }

  Future<void> downloadURLExample(int i) async {
    Reference ref;
    // Within your widgets:
    ref = FirebaseStorage.instance.ref().child('restaurante/itens/nome_prato_'+i.toString()+'.png');
    _urlImagemRecuperada.add( await ref.getDownloadURL());
    print("urlLen: "+_urlImagemRecuperada.length.toString());
  }

  @override
  void initState() {
    super.initState();
    for (var i = 1; i < 3; i++) {
      downloadURLExample(i);
    }
    print("Text: "+widget.idRest);
    firebase.pegarMaioId('cardapio', 'id').then((value) => print("Assyncronous boladaosons MaiorID: "+value.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cardápio"),
      ),
      body: Center(
        child: Container(
            width: MediaQuery.of(context).size.width - 40.0,
            height: MediaQuery.of(context).size.height - 160.0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Carrossel
                  carrossel.carrossel(),
                  // Lista de produtos

                  // Formulário
                  /*Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.all(10.0),
                              child: botoes.pegarBotaoFormulario(
                                context,
                                "Fazer Pedido",
                                fazerPedido,
                              )),
                        ],
                      )
                  ),*/
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.all(10.0),
                              child: botoes.pegarBotaoFormulario(
                                context,
                                "Fechar conta",
                                fazerPedido,
                              )),
                        ],
                      )
                  ),
                  CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                      _urlImagemRecuperada.length > 1
                          ? NetworkImage(_urlImagemRecuperada[1])
                          : null
                  ),
                  CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                      _urlImagemRecuperada.length > 2
                          ? NetworkImage(_urlImagemRecuperada[2])
                          : null


                  ),
                ],
              ),
            )),
      ),
    );
  }
}
