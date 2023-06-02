import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Funciones {
  // esta funci�n se corre justo cuando se conecta un usuario a la app (est� en el initState de Main Chat Page
  // Actualiza los datos del usuario en Firestore con el date_time en que entr� a la app
  // Sirve para mostrar cu�ndo fue la �ltima conexi�n, o desde cu�ndo est� conectado.
  static void updateData() {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;

    final data = {
      "nombre": _auth.currentUser?.displayName,
      "email": _auth.currentUser?.email,
      "ultima-conexion": DateTime.now(),   // a qu� hora se conect� el usuario
    };

    try {
      //_firestore.collection("usuarios").doc(_auth.currentUser?.uid).set(data);   // esto reescribe todo el documento, yo solo quieor modificar unos valores.
      _firestore.collection("usuarios").doc(_auth.currentUser?.uid).update(data);   // esto reescribe todo el documento, yo solo quieor modificar unos valores.

    } catch (e) {
      print(e);
    };
  }
}