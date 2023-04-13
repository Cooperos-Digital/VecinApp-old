import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


//import "registro.dart";


//final FirebaseAuth _auth = FirebaseAuth.instance;


class HomePag extends StatefulWidget {
  final String userEmail;
  const HomePag({required this.userEmail});

  @override
  _HomePagState createState() => _HomePagState();
}



class _HomePagState extends State<HomePag> {
  //final String _userEmail;

  //cerrarSesion() {
  //  FirebaseAuth.instance.signOut();
  //}



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // BARRA SUPERIOR
      appBar: AppBar(
        title: Text("VecinApp"),
        //actions: [
        //  IconButton(
        //    icon: Icon(Icons.menu),
        //    onPressed: (){
        ////      Scaffold.of(context).openDrawer();
        //      ScaffoldMessenger.of(context).showSnackBar(
        //          const SnackBar(
        //            content: Text('Se abre el menú.'),
        //          )
        //      );
        //    },
        //  )
        //],
      ),


      // MENÚ
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Mensajes'),
              onTap: () {
                print("Mensajes");
                },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Perfil'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/perfil");
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Preferencias'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/preferencias");
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar sesión'),
              onTap: () {
                //cerrarSesion();
                FirebaseAuth.instance.signOut();
              },
            ),
//            ListTile
  //            leading: Icon(Icons.face_3_outlined),
    //          title: Text('Cerrar menú'),
      //        onTap: () {Navigator.pop(context);},
        //    ),
          ],
        ),
      ),


      // CONTENIDO DE LA PÁGINA PRINCIPAL
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // TÍTULO
            Text(
              "Página principal",
              style: Theme.of(context).textTheme.displaySmall,
            ),




            // ESTO QUE SIGUE YA NO DEBERÍA ESTAR AQUÍ, SE IRÍA A LA PÁG DE PERFIL
            // IMAGEN DEL USUARIO


            // DATOS DEL USUARIO
            Text("Tu correo: ${widget.userEmail}"),


            // BOTÓN CERRAR SESIÓN
            Container(
              padding: EdgeInsets.all(5),
              child: TextButton(
                child: Text(
                  "Cerrar sesión",
                  //style: ButtonThemeData.textTheme,
                ),
//                onHover: ,
                onPressed: () {   // necesariamente debe ser async?
                  FirebaseAuth.instance.signOut();
                },
              ),
            )




          ],
        ),
      )
    );
  }
}