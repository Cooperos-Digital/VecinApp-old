import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


// requiere recent login para funcionar.
//Future<void> _alertaBorrarCuenta(context) async {
void borrarUsuario(context) async {
  print("Eliminar usuario");
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

              // Autenticar usuario
              var usuarioAutenticado = autenticarUsuario(user);

              // Borrar de FireStore
              FirebaseFirestore.instance.collection("usuarios").doc(user?.uid).delete()
                  .catchError((error) => print('Hubo un problema: $error')); // borra el usuario de Firestore
              FirebaseAuth.instance.signOut(); // Cierra sesión y te regresa al inicio

              // Borrar de FireBase usuarios
        //              FirebaseAuth.instance.currentUser?.delete();   // Falta aquí otra función que borre al usuario del otro registro
              //usuarioAutenticado?.user?.delete();
              usuarioAutenticado?.delete();
              await user?.delete();


              // Ver en qué chats está el usuario
              final chatrooms = await getChatroomsForMember(user?.uid, "chatrooms");
              for (final chatroom in chatrooms) {
                print('Chatroom ID: ${chatroom.id}');
                print('Chatroom members: ${chatroom["miembros"]}');
              }
              // Borrar del Chat
              deleteUserFromChatrooms(chatrooms, user?.uid, "chatrooms");


              // Ver en qué grupos de colonia está el usuario
              final colonias = await getChatroomsForMember(user?.uid, "colonias");
              for (final colonia in colonias) {
                print('Chatroom ID: ${colonia.id}');
                print('Chatroom members: ${colonia["miembros"]}');
              }
              // Borrar de grupos de colonia
              deleteUserFromChatrooms(chatrooms, user?.uid, "colonias");


              // Mensaje
              SnackBar(content: Text("Tus datos se han borrado con éxito."),);
            },
          ),
        ],
      );
    },
  );
}

autenticarUsuario(usuario) {
  print("Autenticando usuario");
//              var authResult
//              usuario = await usuario?.reauthenticateWithCredential(
//                  EmailAuthProvider.credential(email: 'email', password: 'password'),
//              );
  return usuario;
}


Future<List<DocumentSnapshot>> getChatroomsForMember(String? userId, String tipoGrupo) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection(tipoGrupo)
      .where('miembros', arrayContains: userId)
      .get();
  return querySnapshot.docs;
}



void deleteUserFromChatrooms(List<DocumentSnapshot> chatroomIds, String? userId, String tipoGrupo) {
  // Run a transaction for each chatroom ID
  chatroomIds.forEach((chatroom) {
    //final chatroomId = chatroom.id;
    print("Chatroom Id: Se hara lista? ${chatroom.id}");
    final chatroomRef = FirebaseFirestore.instance.collection(tipoGrupo).doc(chatroom.id);

    if (chatroom["tipo"] == "unoauno") {
      chatroomRef.delete();
    }

    FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(chatroomRef);
      final currentMembers = snapshot.get('miembros') as List<dynamic>;
      final updatedMembers = List<String>.from(currentMembers)..remove(userId);
      transaction.update(chatroomRef, {'miembros': updatedMembers});
    });
  });
}