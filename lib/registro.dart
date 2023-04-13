import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


//import "main.dart";
//import "ingreso.dart";

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegistroPag extends StatefulWidget {
  @override
  _RegistroPagState createState() => _RegistroPagState();
}

class _RegistroPagState extends State<RegistroPag> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
//  late String _userEmail;


  // FUNCIÓN REGISTRO
  // debería llevar <Future>?
  void _register() async {
    final User? user = (
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
          //displayName: _nombreController.text,
          //apellido: _apellidoController.text,
        )
    ).user;

    //UserUpdateInfo().displayName = _nombreController.text;
    //UserUpdateInfo().photoURL = "photoURL";
    //await user?.updateProfile(profile);

    if (user != null) {
      await user.updateDisplayName(_nombreController.text);
      //await user.update(_apellidoController.text);
//      await user.

      await user.sendEmailVerification();

      setState(() {
        //_userEmail = user.email!;
        print("SE REGISTRÓ AL USUARIO CON ÉXITO");
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Te enviamos un correo para verificar tu cuenta.', style: Theme.of(context).textTheme.bodyLarge),
            //content: Text('Te has registrado con éxito. ¡Bienvenido a VecinApp!', style: Theme.of(context).textTheme.bodyLarge),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        )
      );
    } else {
      setState(() {
        print("NO SE PUDO REGISTRAR");
      });
    }
  }



  // GOOGLE SIGN IN
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      // MI API
      clientId: "944413830907-rvd45ucb788nid7ubd4eg406smm3v1i9.apps.googleusercontent.com",
    ).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    print("Se logró autenticar con Google.");
    Navigator.of(context).pushNamed("/home");
    final UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);

    return user;
  }



  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),

          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            height: MediaQuery.of(context).size.height,
            
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(height: 60,),

                    // TÍTULO / LOGO
                    Container(
                      padding: EdgeInsets.all(30),
                      child: Text("Registro",
                          //style: Theme.of(context).textTheme.displaySmall,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
    //                    fontFamily: "Arial",
    //                    color: Theme.of(context).colorScheme.shadow,
                        ),
                      ),
                    ),

                    SizedBox(height: 60),



                    // PEDIR NOMBRE
                    Container(
//                  width: 400,
                        //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

                        child: TextField(
                          controller: _nombreController,
                          decoration: InputDecoration(
                              labelText: "Nombre completo",
                              labelStyle: Theme.of(context).textTheme.bodySmall, //copyWith(fontWeight:...),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor,)
                              )
                          ),

                        )
                    ),

                    SizedBox(height: 30),


                    // PEDIR APELLIDOS
                    //Container(
//                  width: 400,
//                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

                    //    child: TextField(
                    //      controller: _apellidoController,
                    //      decoration: InputDecoration(
                    //          labelText: "Apellido (s)",
                      //        labelStyle: Theme.of(context).textTheme.bodySmall, //copyWith(fontWeight:...),
                     //         border: OutlineInputBorder(),
                    //          focusedBorder: OutlineInputBorder(
                    //              borderSide: BorderSide(color: Theme.of(context).primaryColor,)
                    //          )
                    //      ),
                    //  )
                    //),

                    //SizedBox(height: 30),


                    // PEDIR EMAIL
                    Container(
                        width: 400,
                        //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

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
                        //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

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
                            fontSize: 14,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            // - color:
                          ),
                        ),
                        onPressed: () async {
                          _register();
                          print("Registremos al usuario con su correo y contraseña.");

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
                          "Registrarte con Google",
                          style: Theme.of(context).textTheme.bodyMedium,
                          //style: TextStyle(
                          //  fontSize: 15,
                          //  fontFamily: "Montserrat",
                          //  fontWeight: FontWeight.bold,
                          // - color:
                          //),
                        ),
                        onPressed: () {
                          print("Chequemos con Google");
                          //Navigator.of(context).pop();
                          //
                          signInWithGoogle();
//                    var user;
                          //final user = userCredential.user;
                          //print(userCredential.user.uid);

                          //appState.RegistroPag
                        },
                      ),
                    ),


                    // BOTON 3
                    Container(
                      width: 300,
                      padding: EdgeInsets.all(10),

                      child: TextButton(
                        child: Text(
                          "Regresar",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onPressed: () {
                          print("Regresemos");
                          Navigator.of(context).pop();
                          //appState.RegistroPag
                        },
                      ),
                    ),

                    SizedBox(height: 45,)
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}