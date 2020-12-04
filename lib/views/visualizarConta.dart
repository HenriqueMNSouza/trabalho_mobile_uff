import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:share_extend/share_extend.dart';
import 'package:trabalho_final/Components/Botoes.dart';
import 'package:trabalho_final/Firestore/Firebase.dart';

class VisualizarConta extends StatefulWidget {
  // Caminho do Arquivo Pdf criado
  final String caminho;
  VisualizarConta({Key key, this.caminho}) : super(key: key);

  @override
  _VisualizarContaState createState() => _VisualizarContaState();
}

class _VisualizarContaState extends State<VisualizarConta> {
  // Instância dos Botões padrões do sistema
  Botoes botoes = new Botoes();
  Firebase firebase = new Firebase();

  // Variável que armazena o arquivo Pdf
  PDFDocument _contaPdf;

  // Variável para iniciar o carregamento visual
  bool carregarVisualizarPdf;

  @override
  void initState() {
    super.initState();
    // Inicializar a visualização do Pdf ao Iniciar assim que a tela estiver renderizada
    _inicializarPdf();
  }

  Future<void> _inicializarPdf() async {
    // Começar o carregamento da tela
    setState(() {
      this.carregarVisualizarPdf = true;
    });

    // Carregando o arquivo Pdf na Variável
    final contaPdf = await PDFDocument.fromAsset(widget.caminho);

    // Parar o carregamento da tela e Mostar o Arquivo Pdf na tela
    setState(() {
      this._contaPdf = contaPdf;
      this.carregarVisualizarPdf = false;
    });
  }

  void compartilharConta() {
    ShareExtend.share(widget.caminho, "file",
        sharePanelTitle: "Compartilhar Conta", subject: "conta-pdf");
  }

  void fazerLogout() {
    // Logout
    firebase.fazerLogout();
    Navigator.of(context).pushNamed('/entrar');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Conta'),
          actions: <Widget>[
            botoes.pegarBotaoAppBar(Icons.share, compartilharConta),
            botoes.pegarBotaoAppBar(Icons.logout, fazerLogout),
          ],
        ),
        body: Center(
          child: this.carregarVisualizarPdf
              ? CircularProgressIndicator()
              : PDFViewer(document: this._contaPdf),
        ));
  }
}
