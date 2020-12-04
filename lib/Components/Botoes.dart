import 'package:flutter/material.dart';

class Botoes {
  Widget pegarBotaoAppBar(IconData icone, Function pressionar) {
    return IconButton(
      icon: Icon(icone),
      onPressed: pressionar,
    );
  }
  
  Widget pegarBotaoFormulario(BuildContext context, String texto, Function pressionar, { Color corBotao = Colors.blue, Color corTexto = Colors.white }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        color: corBotao,
        child: Text(
          texto,
          style: TextStyle(
              color: corTexto, fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        onPressed: pressionar,
      ),
    );
  }
}
