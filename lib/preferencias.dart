//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vecinapp_2/logica/funciones_usuario.dart';


class PreferenciasPag extends StatefulWidget {

  @override
  _PreferenciasPagState createState() => _PreferenciasPagState();
}

class _PreferenciasPagState extends State<PreferenciasPag> {
  final user = FirebaseAuth.instance.currentUser;
//  final String _userEmail = user.emailEmail ?? "";



  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // BARRA SUPERIOR
          appBar: AppBar(
              title: Text("Preferencias"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back,),
                onPressed: () {Navigator.pop(context);},
              )
          ),


          // CONTENIDO DE LA PÁGINA DE PERFIL
          body: ListView(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            children: <Widget>[
//              DrawerHeader(
//                decoration: BoxDecoration(
//                  color: Theme.of(context).colorScheme.inverseSurface,
//                ),
//                child: Text(
//                  'Perfil',
//                  style: TextStyle(
//                    color: Colors.white,
//                    fontSize: 24,
//                  ),
//                ),
//              ),

              // LISTA
              ListTile(
                leading: Icon(Icons.book),
                title: Text('Aprende a usar VecinApp'),
                onTap: () {
                  print("Manual de usuario.");
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Acerca de'),
                onTap: () {
                  print("Sobre el proyecto");
                },
              ),
              ListTile(
                leading: Icon(Icons.password),
                title: Text('Cambiar contraseña'),
                onTap: () async {
                  //https://firebase.google.com/docs/auth/flutter/manage-users?hl=es-419
                  print("Se va a enviar un correo electrónico.");
                  await FirebaseAuth.instance.setLanguageCode("es");
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: FirebaseAuth.instance.currentUser?.email ?? "");
                  SnackBar(
                    content: Text('Te enviamos un correo con la liga para restablecer tu contraseña.', style: Theme.of(context).textTheme.bodyMedium),
                    backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                  );
                  //ScaffoldMessenger.of(context).showSnackBar(
                   //   SnackBar(
                   //     content: Text('Te enviamos un correo con la liga para restablecer tu contraseña.', style: Theme.of(context).textTheme.bodyLarge),
                   //     backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                   //   )
                  //);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Cerrar sesión'),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
              ListTile(
                leading: Icon(Icons.dangerous),
                title: Text('Borrar cuenta'),
                onTap: () {
                  borrarCuenta(context);
                },
              ),
            ],
          ),
    );
  }

}