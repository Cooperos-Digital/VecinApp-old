import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PerfilPag extends StatefulWidget {
  @override
  _PerfilPagState createState() => _PerfilPagState();
}

class _PerfilPagState extends State<PerfilPag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Tu perfil"),
        ],
      )
    );
  }
}