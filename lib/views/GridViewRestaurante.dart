import 'package:flutter/material.dart';
import 'package:trabalho_final/Firestore/Firebase.dart';
import 'dart:io';

class GridViewRestaurante extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return _GridViewRestaurante();
  }
}
class _GridViewRestaurante extends State<GridViewRestaurante>{
  Firebase firebase = new Firebase();
  int itemCount=0;


  Widget build(BuildContext context){
    return Scaffold(appBar:
      AppBar(
        title: Text("GridView"),
      ),
      body: Container(child: _pictureGridView(),),
      );
  }

  Future<List<String>> preencheImagem() async{
    List<String> lista = [""];

    Future<List<String>> l = firebase.pegaListaImagensCardapio();
    await l.then((value) => itemCount=value.length-1);
    print("ItemCount"+itemCount.toString());
    return l;
  }

  @override
  void initState() {
    super.initState();
  }
  Widget _pictureGridView(){

    return MaterialApp(
      home:Scaffold(
        body:
            FutureBuilder(
              future: preencheImagem(),
              builder: (BuildContext context,AsyncSnapshot snapshot) {
              if(snapshot.hasData && snapshot.data.length > 1) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5),
                  itemBuilder: (BuildContext _context, int _index) {
                    return Container(
                      child:
                      SingleChildScrollView(
                          child: Column(
                              children: [
                                CircleAvatar(
                                    radius: 100,
                                    backgroundColor: Colors.grey,
                                    backgroundImage:
                                           NetworkImage(snapshot.data[_index+1])
                                )
                              ])
                      ),
                    );
                  },
                  itemCount: itemCount,
                );
              }else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              }
        )
      )
    );
  }
}