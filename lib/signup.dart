import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignupPag extends StatefulWidget {
  @override
  _SignupPagState createState() => _SignupPagState();
}

class _SignupPagState extends State<SignupPag> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late bool _sucess;
  late String _userEmail;

  void _register() async {
    final User? user = (
        await _auth.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)
    ).user;

    if (user != null) {
      setState(() {
        _sucess = true;
        _userEmail = user.email!;
        print("SE REGISTRÓ AL USUARIO CON ÉXITO");
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Se ha creado el usuario con éxito. Regresa para ingresar.'))
      );
    } else {
      setState(() {
        _sucess = false;
        print("SE REGISTRÓ AL USUARIO CON ÉXITO");
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
                child: Text("Contraseña",
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
                        )
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


              Spacer(
                flex: 1,
              ),


              // BOTON 1
              Container(
                width: 300,
                padding: EdgeInsets.all(10),

                child: ElevatedButton(
                  child: Text(
                    "SIGUIENTE",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      // - color:
                    ),
                  ),
                  onPressed: () async {
                    _register();
                    print("Registremos al usuario con su correo y contraseña.");

                    //if (App)
                    //Navigator.of(context).pushNamed("/signup");
                    //appState.RegistroPag  // esta es la otra forma de cambiar de página. Cambiar el estado de la página con otra clase que rellene el contenedor (la página).

                  },
                ),
              ),


              // BOTON 2
              Container(
                width: 300,
                padding: EdgeInsets.all(10),

                child: OutlinedButton(
                  child: Text(
                    "Regresar",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      // - color:
                    ),
                  ),
                  onPressed: () {
                    print("Regresemos");
                    Navigator.of(context).pop();
                    //appState.RegistroPag
                  },
                ),
              ),

              SizedBox(height: 30,),
            ],
          ),
        )
    );
  }
}