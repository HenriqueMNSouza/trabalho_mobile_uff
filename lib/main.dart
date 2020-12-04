import 'package:flutter/material.dart';
import 'package:trabalho_final/Components/Route_Generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trabalho_final/views/GridView.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: HomePage(),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/entrar',
    );
  }
}
