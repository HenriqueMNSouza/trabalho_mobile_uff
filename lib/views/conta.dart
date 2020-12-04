import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:trabalho_final/Firestore/Firebase.dart';
import 'package:trabalho_final/views/visualizarConta.dart';

class Conta extends StatefulWidget {
  @override
  _ContaState createState() => _ContaState();
}

class _ContaState extends State<Conta> {
  // Instância do Firebase
  
  // Variável para iniciar o carregamento visual
  bool carregarCriarPdf = false;
  Firebase firebase = new Firebase();


  Future<void> criarPdf(context, dados) async {
    // Criando nova Instância da Biblioteca para criar um PDF
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);

    // Adicionando os dados à página do pdf
    pdf.addPage(pdfLib.MultiPage(
        build: (context) => [pdfLib.Table.fromTextArray(data: dados)]));

    // Salvando o pdf na memória do telefone
    String diretorio = (await getApplicationDocumentsDirectory()).path;
    String caminho = '$diretorio/contaRestaurante.pdf';
    File file = File(caminho);
    file.writeAsBytesSync(pdf.save());

    // Salvar conta no Firebase
    

    // Navegando para a Tela de Visualizar a Conta
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => VisualizarConta(caminho: caminho)));
  }

  Future<void> _inicializarPdf(var conta) async {
    // Começar o Carregamento da Tela
    setState(() {
      this.carregarCriarPdf = true;
    });
    print("INICIALIZAR PDF: "+conta.toString());
    // Pegar Dados do Firebase

    // Criar o Pdf
    await this.criarPdf(context, conta);
  }
  Future<void> pegaLista() async{
    var listaConta = await firebase.pegarContaLista();
    await _inicializarPdf(listaConta);
  }
  @override
  void initState() {
    super.initState();
    // Inicializar a criação do Pdf ao Iniciar assim que a tela estiver renderizada
    pegaLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: this.carregarCriarPdf ? CircularProgressIndicator() : Text(""),
      ),
    );
  }
}
