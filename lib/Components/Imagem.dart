import 'dart:io';
import 'package:flutter/material.dart';

class Imagem {
  Widget pegarImagem(BuildContext context, double margin, double width,
      double heigh, double radius, String texto, Function pegarImagem,
      {Key key, File arquivoImagem}) {
    return GestureDetector(
      key: key,
      onTap: pegarImagem,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: margin),
        width: MediaQuery.of(context).size.width - width,
        height: heigh,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          border: Border.all(
              color: Colors.blue,
              width: 3.0,
              style:
                  arquivoImagem == null ? BorderStyle.solid : BorderStyle.none),
        ),
        child: arquivoImagem == null
            ? Center(
                child: Text(
                  "$texto",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold),
                ),
              )
            : Image.file(arquivoImagem),
      ),
    );
  }
}