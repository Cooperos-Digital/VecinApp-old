import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Funciones {
  // esta función se corre justo cuando se conecta un usuario a la app (está en el initState de Main Chat Page
  // Actualiza los datos del usuario en Firestore con el date_time en que entró a la app
  // Sirve para mostrar cuándo fue la última conexión, o desde cuándo está conectado.
  static void updateData() {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;

    final data = {
      "nombre": _auth.currentUser?.displayName,
      "email": _auth.currentUser?.email,
      "ultima-conexion": DateTime.now(),   // a qué hora se conectó el usuario
    };

    try {
      //_firestore.collection("usuarios").doc(_auth.currentUser?.uid).set(data);   // esto reescribe todo el documento, yo solo quieor modificar unos valores.
      _firestore.collection("usuarios").doc(_auth.currentUser?.uid).update(data);   // esto reescribe todo el documento, yo solo quieor modificar unos valores.

    } catch (e) {
      print(e);
    };
  }
}