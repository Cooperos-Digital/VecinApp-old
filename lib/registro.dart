import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';    // este es del otro proceso para usar el firestorecloud

final FirebaseAuth _auth = FirebaseAuth.instance;


class RegistroPag extends StatefulWidget {
  @override
  _RegistroPagState createState() => _RegistroPagState();
}


class _RegistroPagState extends State<RegistroPag> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late bool _sucess;
  late String _userEmail;

  void _login() async {
    print("Corriendo función _login()");
    final User? user = (
      await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)
    ).user;

    if (user != null) {
      setState(() {
        _sucess = true;
        _userEmail = user.email!;
        print("SE PUDO INGRESAR CON ÉXITO. Correo: ${_userEmail}");
        Navigator.of(context).pushNamed("/home");
      });
    } else {
      setState(() {
        // Creo que esto aún no se corre porque falta agregar un handle error en el  await _auth.signIn...  o algo así
        _sucess = false;
        print("NO SE PUDO INGRESAR");
      });
    }
  }


  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 60,),

              // TÍTULO / LOGO
              Container(
                padding: EdgeInsets.all(30),
                child: Text("Inicio",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Arial",
                    color: Theme.of(context).colorScheme.shadow,
                  ),
                ),
              ),

              SizedBox(height: 60),

              // PEDIR EMAIL
              Container(
                width: 400,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Correo electrónico",
                    labelStyle: Theme.of(context).textTheme.bodySmall, //copyWith(fontWeight:...),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor,)
                    ),
                  ),

                )
              ),

              SizedBox(height: 30),

              // PEDIR CONTRASEÑA
              Container(
                  width: 400,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: "Contraseña",
                        labelStyle: Theme.of(context).textTheme.bodySmall, //copyWith(fontWeight:...),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor,)
                        ),
                    ),
                    obscureText: true,

                  )
              ),

              //SizedBox(height: 120),
              Spacer(
                flex: 1,
              ),

              // BOTON 1
              Container(
                width: 300,
                padding: EdgeInsets.all(10),

                child: ElevatedButton(
                  child: Text(
                    "INGRESAR",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      // - color:
                    ),
                  ),
                  onPressed: () {
                    print("Más adelante."
                        "Probemos si el correo ingresado existe en el sistema. "
                        "Si no, vayamos a la página de registro."
                        "Si sí, vayamos al perfil del usuario");

                    //Navigator.of(context).pushNamed("/signup");
                    //appState.RegistroPag  // esta es la otra forma de cambiar de página. Cambiar el estado de la página con otra clase que rellene el contenedor (la página).
                    _login();

                    if (_sucess == true) {
                      print("Si te registraste bien y esta cosa funciona, aquí debería aparecer tu correo: ${_userEmail}");
                    }

                  },
                ),
              ),

              // BOTON 2
              Container(
                width: 300,
                padding: EdgeInsets.all(10),

                child: OutlinedButton(
                  child: Text(
                    "Registro",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      // - color:
                    ),
                  ),
                  onPressed: () {
                    print("Registro");
                    Navigator.of(context).pushNamed("/signup");
                    //appState.RegistroPag
                  },
                ),
              ),


              // BOTON 3
              Container(
                //width: 300,
                //padding: EdgeInsets.all(5),

                child: TextButton(
                  child: Text(
                    "Olvidé mi contraseña",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onPressed: () {
                    print("Necesito hacer una nueva constraseña");
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Si tus datos se encuentran registrados, te enviaremos un correo con instrucciones para reestablecer tu contraseña.'))
                    );
                    //Navigator.of(context).pushNamed("/nuevaSenha");
                    //appState.RegistroPag
                  },
                ),
              ),


              // MENSAJITO
              Container(
                child: Column(  //esta no debería ser Column, sino un mensajito que aparezca abajo, puede ser un SnackBox()
                  children: [
                    //Text("Aparecerá esto?"),
                  ],
                ),
              ),

              SizedBox(height: 30,),

            ],
          ),
        )
    );
  }
}