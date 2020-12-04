import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trabalho_final/Components/Imagem.dart';
import 'package:trabalho_final/Forms/CadastrarForm.dart';
import '../Components/Botoes.dart';
import '../Components/CaixaTexto.dart';
import 'package:trabalho_final/model/Item.dart';
import 'package:trabalho_final/Firestore/Firebase.dart';

class CadastroCardapio extends StatefulWidget {
  @override
  _CadastroCardapioState createState() => _CadastroCardapioState();
}

class _CadastroCardapioState extends State<CadastroCardapio> {
  Firebase firebase = Firebase();
  CadastrarForm cadastrarForm = new CadastrarForm();
  Botoes botoes = new Botoes();
  CaixaTexto caixaTexto = new CaixaTexto();
  final formKey = new GlobalKey<FormState>();
  Imagem imagem = new Imagem();
  final imagePicker = new ImagePicker();
  Item item = new Item();
  File arquivoProduto;

  int maxid;

  String url;

  Future<void> pegarImagem() async {
    // Escolhendo Imagem da Galeria usando a biblioteca
    PickedFile arquivo =
        await imagePicker.getImage(source: ImageSource.gallery);

    // Transformando a imagem escolhida em um Tipo Arquivo reconhecido pelo Flutter
    setState(() {
      this.arquivoProduto = new File(arquivo.path);
    });
  }

  Future<void> uploadFile() async {
    url = 'restaurante/itens/nome_prato_'+(maxid+1).toString()+'.png';
    firebase.enviarAqruivoBD(
        referencia: url,
        arquivo: arquivoProduto
    );
  }
  Future<void> fazerCadastro() async {
    final form = formKey.currentState;
    url = 'restaurante/itens/nome_prato_'+(maxid+1).toString()+'.png';
    if (form.validate()) {
      form.save();
      // Mandar pro Firebase
      Future<int> maxid = firebase.pegarMaioId('cardapio', 'id');
      Future<String> idRest = firebase.pegarIdRestaurante();

      await idRest.then((id) => item.adicionarIdRestaurante(id));

      await maxid.then((value) {
        item.adicionarId((value + 1).toString());
        item.adicionarUrl(url);
        firebase.salvarDadosBD(
          colecao: "cardapio", dados: item.pegarItensDados());
          uploadFile();
      });

      firebase.salvarDadosBD(colecao: "cardapio", dados: item.pegarItensDados());
      uploadFile();

      Navigator.of(context).pushNamed('/r');
    }
  }
  void fazerNovoCadastro() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      // Mandar pro Firebase

      firebase.salvarDadosBD(colecao: "cardapio", dados: item.pegarItensDados());
      uploadFile();

      Navigator.of(context).pushNamed('/cadastrocardapio');
    }
  }
  void adicionarItem() {
    // Adicionar mais um campo para cadastrar produtos
  }

  @override
  void initState() {
    super.initState();
    firebase.pegarMaioId('cardapio', 'id').then((value) => maxid = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar Cardápio"),
        actions: [
          botoes.pegarBotaoAppBar(Icons.add, adicionarItem),
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 40.0,
          height: MediaQuery.of(context).size.height - 160.0,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Nome do restaurante
                Text("Nome do restaurante",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
                // Formulário
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text("Produto 1",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          )),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: caixaTexto.pegarCaixaTextoPadrao("nome",
                            validando: (String nome) {
                              if (nome.isEmpty) {
                                return "Nome não pode ser vazio!";
                              } else {
                                // Validação
                              }
                              return null;
                            },
                            salvando: (String nome) =>
                                item.adicionarNome(nome)
                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: caixaTexto.pegarCaixaTextoPadrao("Preço",
                            validando: (String preco) {
                              if (preco.isEmpty) {
                                return "Preço não pode ser vazio!";
                              } else {
                                // Validação
                              }
                              return null;
                            },
                            salvando: (String preco) =>
                                item.adicionarPreco(preco)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: caixaTexto.pegarCaixaTextoPadrao("Descrição",
                            validando: (String descr) {
                              if (descr.isEmpty) {
                                return "Descrição não pode ser vazio!";
                              } else {
                                // Validação
                              }
                              return null;
                            },
                            salvando: (String descr) =>
                                item.adicionarDescr(descr)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: imagem.pegarImagem(context, 10.0, 40.0, 40.0,
                            10.0, "Imagem do Produto", pegarImagem,
                            arquivoImagem: arquivoProduto),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: botoes.pegarBotaoFormulario(
                            context, "Finalizar", fazerCadastro),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: botoes.pegarBotaoFormulario(
                            context, "Cadastrar Novo", fazerNovoCadastro),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
