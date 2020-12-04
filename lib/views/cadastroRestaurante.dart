import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trabalho_final/Components/Imagem.dart';
import 'package:trabalho_final/Firestore/Firebase.dart';
import 'package:trabalho_final/Forms/RestauranteForm.dart';
import '../Components/Botoes.dart';
import '../Components/CaixaTexto.dart';

class CadastroRestaurante extends StatefulWidget {
  @override
  _CadastroRestauranteState createState() => _CadastroRestauranteState();
}

class _CadastroRestauranteState extends State<CadastroRestaurante> {
  Firebase firebase = Firebase();
  RestauranteForm restauranteForm = new RestauranteForm();
  Botoes botoes = new Botoes();
  CaixaTexto caixaTexto = new CaixaTexto();
  final formKey = new GlobalKey<FormState>();
  Imagem imagem = new Imagem();
  final imagePicker = new ImagePicker();
  File arquivoLogo;

  Future<void> pegarImagem() async {
    // Escolhendo Imagem da Galeria usando a biblioteca
    // File arquivo = await ImagePicker.pickImage(source: ImageSource.gallery);
    PickedFile arquivo =
        await imagePicker.getImage(source: ImageSource.gallery);

    // Transformando a imagem escolhida em um Tipo Arquivo reconhecido pelo Flutter
    setState(() {
      this.arquivoLogo = new File(arquivo.path);
    });
  }

  Future<void> fazerCadastro() async {
    // Pegar dados do form
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      // Salvar Imagem
      await firebase.enviarAqruivoBD(
          referencia: "restaurante/logo.png", arquivo: arquivoLogo);

      //

      // Pegando dados do Restaurante
      Map<String, dynamic> dadosRestaurante =
          restauranteForm.pegarRestauranteDados();
      dadosRestaurante["id_restaurante"] = await firebase.pegarMaioId('restaurante', 'id_restaurante')+1;
      // Adicionar Ref da Imagem aos dados
      dadosRestaurante["ref_logo"] = "restaurante/logo.png";

      // Salvando no Banco de Dados
      firebase.salvarDadosBD(colecao: "restaurante", dados: dadosRestaurante);

      // Navegar para tela de Cadastro do Cardápio
      Navigator.of(context).pushNamed('/cadastrocardapio');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar Restaurante"),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 40.0,
          height: MediaQuery.of(context).size.height - 160.0,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Logo
                imagem.pegarImagem(context, 15.0, 60.0, 140.0, 15.0,
                    "Imagem da Logo", pegarImagem,
                    arquivoImagem: arquivoLogo),
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
                                restauranteForm.adicionarNome(nome)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: caixaTexto.pegarCaixaTextoPadrao("Endereço",
                            validando: (String endereco) {
                              if (endereco.isEmpty) {
                                return "Endereço não pode ser vazio!";
                              } else {
                                // Validação
                              }
                              return null;
                            },
                            salvando: (String endereco) =>
                                restauranteForm.adicionarEndereco(endereco)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: caixaTexto.pegarCaixaTextoPadrao("Nº de Mesas",
                            validando: (String mesas) {
                              if (mesas.isEmpty) {
                                return "Capacidade não pode ser vazio!";
                              } else {
                                // Validação
                              }
                              return null;
                            },
                            salvando: (String mesas) =>
                                restauranteForm.adicionarMesas(mesas)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: caixaTexto.pegarCaixaTextoPadrao("Abre",
                            validando: (String horaAbre) {
                              if (horaAbre.isEmpty) {
                                return "Abre não pode ser vazio!";
                              } else {
                                // Validação
                              }
                              return null;
                            },
                            salvando: (String horaAbre) =>
                                restauranteForm.adicionarHoraAbre(horaAbre)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: caixaTexto.pegarCaixaTextoPadrao("Fecha",
                            validando: (String horaFecha) {
                              if (horaFecha.isEmpty) {
                                return "Fecha não pode ser vazio!";
                              } else {
                                // Validação
                              }
                              return null;
                            },
                            salvando: (String horaFecha) =>
                                restauranteForm.adicionarHoraFecha(horaFecha)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: caixaTexto.pegarCaixaTextoPadrao("Proprietário",
                            validando: (String proprietario) {
                              if (proprietario.isEmpty) {
                                return "Nome do proprietário não pode ser vazio!";
                              } else {
                                // Validação
                              }
                              return null;
                            },
                            salvando: (String proprietario) => restauranteForm
                                .adicionarProprietario(proprietario)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: botoes.pegarBotaoFormulario(
                            context, "Cadastrar", fazerCadastro),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
