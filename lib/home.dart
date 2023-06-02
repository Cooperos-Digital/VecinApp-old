import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vecinapp_2/comp/widgets_pag.dart';



class HomePag extends StatefulWidget {
  final String userEmail;
  const HomePag({required this.userEmail});

  @override
  _HomePagState createState() => _HomePagState();
}


class _HomePagState extends State<HomePag> {
  final User? user = FirebaseAuth.instance.currentUser;
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
      drawer: WidgetsPag.drawerMenu(context),

      // CONTENIDO DE LA PÁGINA PRINCIPAL
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // TÍTULO
            Text(
              "Bienvenido a VecinApp",
              style: Theme.of(context).textTheme.displaySmall,
            ),




            // ESTO QUE SIGUE YA NO DEBERÍA ESTAR AQUÍ, SE IRÍA A LA PÁG DE PERFIL
            // DATOS DEL USUARIO
            Center(
              child: Column(
                children: [
                  Text("Tu correo: ${widget.userEmail}"),
                  Text("Tu correo: ${user?.email}"),
                  //Text("Tu vecindad: ${user?}"),
                ],
              ),
            ),


            // BOTÓN CERRAR SESIÓN
            Container(
              padding: EdgeInsets.all(5),
              child: TextButton(
                child: Text(
                  "Cerrar sesión",
                  //style: ButtonThemeData.textTheme,
                ),
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