
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void cerrarSesion() async {
  await FirebaseAuth.instance.signOut();
}


//Future<void> _alertaBorrarCuenta(context) async {
void borrarCuenta(context) async {
  final user = FirebaseAuth.instance.currentUser;
  return showDialog<void>(
    context: context,
//    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Eliminar cuenta'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListBody(
                children: const <Widget>[
                  Text('Si decides continuar, se borrarán tus datos de nuestro sistema.'),
                  SizedBox(height: 20,),
                  Text('¿Deseas continuar?'),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () async {
              Navigator.pop(context);
              FirebaseFirestore.instance.collection("usuarios").doc(user?.uid).delete()
                  .catchError((error) => print('Hubo un problema: $error'));   // borra el usuario de Firestore
              FirebaseAuth.instance.currentUser?.delete();   // Falta aquí otra función que borre al usuario del otro registro
              FirebaseAuth.instance.signOut();   // Cierra sesión y te regresa al inicio
              SnackBar(content: Text("Tus datos se han borrado con éxito."),);
              await user?.delete();
            },
          ),
        ],
      );
    },
  );
}