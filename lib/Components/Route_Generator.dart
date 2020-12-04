import 'package:flutter/material.dart';
import 'package:trabalho_final/views/GridView.dart';
import 'package:trabalho_final/views/GridViewRestaurante.dart';
import 'package:trabalho_final/views/cadastro.dart';
import 'package:trabalho_final/views/cadastroCardapio.dart';
import 'package:trabalho_final/views/cadastroRestaurante.dart';
import 'package:trabalho_final/views/cardapio.dart';
import 'package:trabalho_final/views/conta.dart';
import 'package:trabalho_final/views/entrar.dart';
import 'package:trabalho_final/views/homeCliente.dart';
import 'package:trabalho_final/views/homeRestaurante.dart';

/// Classe que contém as rotas de navegação do Sistema
class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final dados = settings.arguments;

    //if(dados) print("Dados: "+dados);
    switch (settings.name) {
      case '/c':
        return MaterialPageRoute(builder: (_) => HomeCliente());
      case '/r':
        return MaterialPageRoute(builder: (_) => HomeRestaurante());
      case '/entrar':
        return MaterialPageRoute(builder: (_) => Entrar());
      case '/cadastrar':
        return MaterialPageRoute(builder: (_) => Cadastro());
      case '/cadastrorestaurante':
        return MaterialPageRoute(builder: (_) => CadastroRestaurante());
      case '/cadastrocardapio':
        return MaterialPageRoute(builder: (_) => CadastroCardapio());
      case '/cardapio':
        return MaterialPageRoute(builder: (_) => Cardapio());
      case '/conta':
        return MaterialPageRoute(builder: (_) => Conta());
      case '/conta':
        return MaterialPageRoute(builder: (_) => Conta());
      case '/gridview':
        return MaterialPageRoute(builder: (_) => GridView());
      case '/gridviewrestaurante':
        return MaterialPageRoute(builder: (_) => GridViewRestaurante());
      default:
        return erroNaRota(dados);
    }
  }

  /// Página de [Erro de Rota]
  static Route<dynamic> erroNaRota(dynamic dados) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Erro de Rota'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text(
                "Tire um print da sua tela e mande para o nosso suporte!",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 100.0)),
              Text(dados.toString()),
            ],
          )
        ),
      );
    });
  }
}