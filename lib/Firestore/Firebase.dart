// import 'dart:io';
// import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trabalho_final/Forms/EntrarForm.dart';
import 'package:trabalho_final/model/Usuario.dart';
import '../Components/Notificacao.dart';
import 'package:firebase_database/firebase_database.dart';

class Firebase {
  // ===================================================    FIRESTORE    =====================================================

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fire = FirebaseFirestore.instance;
  FirebaseDatabase bd = FirebaseDatabase.instance;

  String pegarUserId() {
    return auth.currentUser.uid;
    //return "ALHrQDtNnTYTj1exOQ3ACNdtohA2";
  }
  // Adicionar novo Usuário na Autenticação
  void criarUsuario(Usuario usuario) {
    print("Tentando criar usuario...");
    auth
        .createUserWithEmailAndPassword(
            email: usuario.pegarEmail(), password: usuario.pegarSenha())
        .then((firebaseUser) {
      this.salvarDadosBD(
          colecao: "usuarios",
          documento: firebaseUser.user.uid,
          dados: usuario.pegarUsuarioDados());
    }).catchError((error) {
      print("Algo de errado não esta certo na criação de usuario");
    });

  }

  Future<String> fazerLogin({EntrarForm formulario}) async {
    Usuario u;
    String  uid;
    await auth
        .signInWithEmailAndPassword(
            email: formulario.pegarEmail(), password: formulario.pegarSenha())
        .then((firebaseUser) {
          this.pegarUsuarios(id: firebaseUser.user.uid);
          uid = firebaseUser.user.uid;
    }).catchError((error) {});

    print("Fazer login uid: "+ uid);
    //return uid;
  }

  void fazerLogout() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  // Salvar dados no Banco de Dados
  void salvarDadosBD({String colecao, String documento, dynamic dados}) {
    fire.collection(colecao).doc(documento).set(dados);
  }


  // Pegando Dados do Banco
  Future<Usuario> pegarUsuarios({String id}) async {
    print("Pegar usuarios\n");
    print("user_Id: "+id);
    DocumentSnapshot dados = await fire.collection("usuarios").doc(id).get();
    var dadosUsuario = dados.data();
    //print(dadosUsuario);
    Usuario u = new Usuario();
    //print(dadosUsuario['id']);
    u.adicionarId(dadosUsuario['id']);
    u.adicionarNome(dadosUsuario['nome']);
    u.adicionarEmail(dadosUsuario['email']);
    u.adicionarTipo(int.parse(dadosUsuario['tipo']));

    return await u;
  }

  //Pega maior valor de Id. Intuito de ser usado na adição de novos itens.
  Future<int> pegarMaioId(String colecao, String campo_id) async{
    var item;
    int maiorId = 0;
    var dadosItens = await fire.collection(colecao).get();
    for(int i = 0; i < dadosItens.size; i++) {
      item = dadosItens.docs[i].data();
      if(item[campo_id] != null && maiorId < int.parse(item[campo_id])) {
        maiorId = int.parse(item[campo_id]);
      }
    }
    return maiorId;
  }

  Future<String> pegarIdRestaurante() async{
    DocumentSnapshot dados = await fire.collection("usuarios").doc(this.pegarUserId()).get();
    return dados.data()['id_restaurante'];
  }

  Future<List<String>> pegaListaImagensCardapio() async{
      List<String> lista = [""];
      List<String> l = [""];
      var dadosRestaurante = await fire.collection("restaurante").get();

      var dadosCardapio = await fire.collection("cardapio").get();
      var dadosUsuario = await fire.collection("usuarios").doc(this.pegarUserId()).get();

      var itemRestaurante;
      var itemCardapio;

      for(int i =0; i < dadosRestaurante.size; i++){
        itemRestaurante = dadosRestaurante.docs[i].data();
        for(int j = 0; j < dadosCardapio.size; j++) {
          itemCardapio = dadosCardapio.docs[j].data();
          if (itemCardapio['id_restaurante'] != null
              && itemRestaurante['id_restaurante'] != null
              && dadosUsuario['id_restaurante'] != null
              && dadosUsuario['id_restaurante'] == itemCardapio['id_restaurante']
              && dadosUsuario['id_restaurante'] == itemRestaurante['id_restaurante']
              ) {
            lista.add(itemCardapio['url']);

          }
        }
      }

      for(int i=1; i<lista.length;i++) {
        await this.pegaImagem(lista[i]).then((url) {
          l.add(url);
        });
      }
      return await Future.value(l);
  }

  Future<List<String>> pegaListaImagensCardapioCliente(String idRest) async{
    List<String> lista = [""];
    List<String> l = [""];

    var dadosCardapio = await fire.collection("cardapio").get();

    var itemRestaurante;
    var itemCardapio;


      for(int j = 0; j < dadosCardapio.size; j++) {
        itemCardapio = dadosCardapio.docs[j].data();
        if (itemCardapio['id_restaurante'] != null
            && itemCardapio['id_restaurante'] == idRest ) {
          lista.add(itemCardapio['url']);
        }
      }
    for(int i=1; i<lista.length;i++) {
      await this.pegaImagem(lista[i]).then((url) {
        l.add(url);
      });
    }
    return await Future.value(l);
  }
  Future<String> pegaImagem(String url) async{
   // print("# pegaImagem #");
    return await FirebaseStorage.instance.ref().child(url).getDownloadURL();
  }


  Future<List<List<String>>> pegarContaLista() async {
    List<List<String>> lista = [["Produto", "Valor"]];
    var dadosConta = await fire.collection("conta").get();
    var dadosItens = await fire.collection("cardapio").get();
    var itemConta;
    var itemCardapio;
    double totalConta = 0;
    print("pegarContaLista() :====================");
    for(int i =0; i < dadosConta.size; i++){
      itemConta = dadosConta.docs[i].data();
      for(int j = 0; j < dadosItens.size; j++) {
        itemCardapio = dadosItens.docs[j].data();
        if (itemCardapio['id'] != null
            && itemConta['id_cardapio'] != null
            && itemConta['id_cardapio'].toString() == itemCardapio['id']
            && itemConta['emAberto']
            && itemConta['id_usuario'] == this.pegarUserId()) {
          lista.add([itemCardapio['nome'],"RS: "+itemCardapio['preco']]);
          totalConta += int.parse(itemCardapio['preco']);
        }
      }
    }

    lista.add(["Total:","RS:"+totalConta.toString()]);
    return lista;
    // print("Total da conta: "+ totalConta.toString());
  }
  void pagarConta() async {
    String id_usuario = this.pegarUserId();
    print("\nAntes da query louca\n - id_usuario: "+id_usuario);
        var snapshot = await fire.collection('conta')
            .where('emAberto', isEqualTo: true)
            .where('id_usuario',isEqualTo: id_usuario)
            .get()
            .then((querySnapshot ) => {
          querySnapshot.docs.forEach((element) {
            fire.collection('conta').doc(element.id).update({"emAberto":false});
            print("element.id: "+element.id);
            })});
  }


  // ===================================================     STORAGE     =====================================================

  // Upload de arquivos para o Banco de Dados
  Future<void> enviarAqruivoBD({String referencia, File arquivo}) async {
    try {
      await FirebaseStorage.instance.ref(referencia).putFile(arquivo);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  // ===================================================    MESSENGER    =====================================================

  // Instância do Firebase Messaging
  final FirebaseMessaging _firebase = FirebaseMessaging();

  /// Inicializa o Firebase para controle do clique do usuário nas notificações
  Future<void> inicializar() async {
    this
        ._firebase
        .getToken()
        .then((dispositivoToken) => print(dispositivoToken));

    // Se houvesse necessidade de implantação para IOS
    // if ( Platform.isAndroid ) {
    //   this._firebase.requestNotificationPermissions(IosNotificationSettings());
    // }

    // Configuração do que fazer quando essas Funções de Callback forem executadas! (usuário clicar na notificação)
    this._firebase.configure(
        // Quando o app está aberto em 1º plano e o usuário clica na notificação
        onMessage: (Map<String, dynamic> message) async {
      tratarDados(message);
    },
        // Quando o app está fechado e o usuário clica na notificação
        onLaunch: (Map<String, dynamic> message) async {
      tratarDados(message);
    },
        // Quando o app está aberto em 2º plano e o usuário clica na notificação
        onResume: (Map<String, dynamic> message) async {
      tratarDados(message);
    });
  }

  void tratarDados(Map<String, dynamic> message) {
    var notificacao = message['notification'];
    var dados = message['data'];

    var titulo = notificacao['title'];
    var descricao = notificacao['body'];
    var navegacao = dados['nav'];
    var outrosDados = dados['extraData'];

    Notificacao novaNotificacao = new Notificacao(
        titulo: titulo,
        descricao: descricao,
        navegacao: navegacao,
        outrosDados: outrosDados);

    if (navegacao != null) {
      tratarNavegacao(navegacao, novaNotificacao);
    }
  }

  void tratarNavegacao(String tela, Notificacao notificacao) {
    // Navegação
    if (tela != null) {
      // Navegar para a tela especificada passando os dados
    }
  }

  // Replace with server token from firebase console settings.
  final String serverToken =
      'AAAAbfrltqI:APA91bH7hVXIOLX-hznbcNu8Zd5bT_kii6QIi7GlrX3v0AxeXi_6K0eXY0-1GmQ0TG6dAGSGElLlxOlJgvarqyB-CRO15fFvaq-lwBD8DelzroaZgjaF6btoJZkRHftfYvqw9FsQh1Wd';

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    // await _firebase.requestNotificationPermissions(
    //   const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    // );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title'
          },
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'nav': '/teste',
            'status': 'done'
          },
          'to':
              'dLBTW_BuTZqu49J-zivypU:APA91bG6TYTdzXC0tjQL3_2bdh-ddLQGEQ6T-8ezmjXd0LaRWabg2WAAaobOx9dX-9VuvEdHq4k5QnUM_G8ImhvYJEk9QbusA5p-CMaj7oHv5Tygjq3mGzrwfsGbJd_KqaJTGguxv2oe',
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    _firebase.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }
}
