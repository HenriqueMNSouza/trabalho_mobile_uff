import 'package:flutter/material.dart';
import 'package:trabalho_final/Components/Botoes.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:trabalho_final/views/GridView.dart';
import 'package:trabalho_final/views/cardapio.dart';

class QrCode extends StatefulWidget {
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  // Variável que armazena o valor do QrCode ao lê-lo
  String _leitor;
  // Variáveis que armazenam os Id's do Restaurante e da Mesa
  int idResturante, idMesa;

  // Instância dos Botões padrões do sistema
  Botoes botoes = new Botoes();

  /// Lendo os dados do QrCode [*Assíncrona*]
  Future<void> lerQrCode() async {
    // Recebe os dados do QrCode
    this._leitor = await FlutterBarcodeScanner.scanBarcode(
        "#000000", "Cancel", true, ScanMode.QR);
    print("QR lido: "+this._leitor);
    // Pegando id do Restaurante
    this.idResturante = this.trataDadosQrCode(this._leitor, "R");
    // Pegando id da Mesa
    this.idMesa = this.trataDadosQrCode(this._leitor, "M");

    // Abrindo nova mesa no restaurante
    print("Restaurante: $idResturante || Mesa: $idMesa");

    if(idResturante != null && idMesa != null ) Navigator.of(context).push(MaterialPageRoute(builder: (context) => GridViewPage(idRest:idResturante.toString())));
  //  if(idResturante != null && idMesa != null ) Navigator.of(context).pushNamed('/cardapio', arguments: idResturante );
  }

  /// Tratando os dados do QrCode, para pegar o Id do Restaurante o [tipo] deve ser *"R"*, para o Id da Mesa o [tipo] deve ser *"M"*
  int trataDadosQrCode(String dados, String tipo) {
    // Pegando Id
    print("Tratando dados QRCode");
    String idAux = dados.split("-")[tipo == "R"? 1 : 0];
    print("idAux: "+idAux);
    // Transformando em inteiro
    int id = int.parse(idAux);
    // Retornando Id
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 35.0),
        child: botoes.pegarBotaoFormulario(context, "Ler Qr Code", lerQrCode),
      ),
    );
  }
}
