//import 'dart:convert';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:csv/csv.dart';
import 'package:vecinapp_2/comp/registro_direccion_csv.dart';



class RegistroPag extends StatefulWidget {
  @override
  _RegistroPagState createState() => _RegistroPagState();
}

class _RegistroPagState extends State<RegistroPag> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _error = false;
  String descripError = "";


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();


  List<Estado> estados = [Estado("19", "Nuevo León"), Estado("14", "Jalisco")];
  List<Ciudad> ciudades = [];
  List<Colonia> colonias = [];

  var selectedState;
  var selectedCity;
  var selectedNeighborhood;

  List<List<dynamic>> csvTable = [[]];



  // INIT STATE
  @override
  void initState() {
    super.initState();
    cargarColonias();
  }



  // BUILD METHOD -----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          scrollDirection: Axis.vertical,

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
                      ),
                    ),
                  ),

                  SizedBox(height: 60),



                  // PEDIR NOMBRE
                  Container(
                      width: 400,
                      child: TextField(
                        controller: _nombreController,
                        decoration: InputDecoration(
                            labelText: "Nombre(s)",
                            labelStyle: Theme.of(context).textTheme.bodySmall,
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).primaryColor,)
                            )
                        ),

                      )
                  ),

                  SizedBox(height: 30),


                  // PEDIR APELLIDOS
                  Container(
                    width: 400,
                    child: TextField(
                      controller: _apellidoController,
                      decoration: InputDecoration(
                        labelText: "Apellido(s)",
                        labelStyle: Theme.of(context).textTheme.bodySmall, //copyWith(fontWeight:...),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor,)
                        )
                      ),
                    )
                  ),

                  SizedBox(height: 30),



                  // PEDIR ESTADO
                  Container(
                    width: 400,
                    height: 55,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Entidad",
                        labelStyle: Theme.of(context).textTheme.bodySmall, //copyWith(fontWeight:...),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor,),
                        ),

                        suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: InputDecorator(
                            decoration: InputDecoration(border: InputBorder.none,),
                            child: DropdownButton<Estado>(
                              isExpanded: true,
                              value: selectedState,
                              items: estados.map((estado) => DropdownMenuItem(value: estado, child: Text(estado.name),)).toList(),
                              hint: Text("Selecciona tu estado", style: Theme.of(context).textTheme.bodySmall,),
                              underline: Container(height: 0,),

                              onChanged: (estado) {
                                setState(() {
                                  selectedState = estado;
                                  selectedCity = null;
                                  selectedNeighborhood = null;
                                });
                                cargarDropdown();
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  ),

                  SizedBox(height: 30),


                  // PEDIR CIUDAD
                  Container(
                      width: 400,
                      height: 60,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Ciudad",
                          labelStyle: Theme.of(context).textTheme.bodySmall, //copyWith(fontWeight:...),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor,)),
                          suffixIcon: Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: InputDecorator(
                              decoration: InputDecoration(border: InputBorder.none,),
                              child: DropdownButton<Ciudad>(
                                isExpanded: true,
                                value: selectedCity,
                                items: ciudades.map((ciudad) => DropdownMenuItem(value: ciudad, child: Text(ciudad.name),)).toList(),
                                hint: Text("Selecciona tu ciudad", style: Theme.of(context).textTheme.bodySmall,),
                                underline: Container(height: 0,),

                                onChanged: (ciudad) {
                                  setState(() {
                                    selectedCity = ciudad;
                                    selectedNeighborhood = null;
                                  });
                                  cargarDropdownColonias();
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                  ),

                  SizedBox(height: 30),



                  // PEDIR COLONIA
                  Container(
                      width: 400,
                      height: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Entidad",
                          labelStyle: Theme.of(context).textTheme.bodySmall, //copyWith(fontWeight:...),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor,)),
                          suffixIcon: Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: InputDecorator(
                              decoration: InputDecoration(
//                                border: InputBorder.none,
                              ),
                              child: DropdownButton<Colonia>(
                                isExpanded: true,
                                value: selectedNeighborhood,
                                items: colonias.map((colonia) => DropdownMenuItem(value: colonia, child: Text(colonia.name),)).toList(),
                                hint: Text("Selecciona tu colonia", style: Theme.of(context).textTheme.bodySmall,),
                                underline: Container(height: 0,),

                                onChanged: (colonia) {
                                  setState(() {
                                    selectedNeighborhood = colonia;
                                  });
                                  cargarDropdown();
                                  print("\nSelección: ${selectedNeighborhood.name} - ${selectedCity.name}, ${selectedState.name}");
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                  ),

                  SizedBox(height: 30),


                  // PEDIR EMAIL
                  Container(
                      width: 400,
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



                  //Spacer(flex: 1,),
                  SizedBox(height: 30,),

                  // MENSAJE DE ERROR, EN CASO DE HABER
                  Text(_error == true ? "Error: $descripError" : ""),

                  SizedBox(height: 30,),


                  // BOTONES
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
                        print("Registremos al usuario con su correo y contraseña.");
                        _register();
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
                        signInWithGoogle();
                        //final user = userCredential.user;
                        //print(userCredential.user.uid);
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
                      },
                    ),
                  ),

                  SizedBox(height: 45,)
                ],
              ),
            ),
          ),
        )
    );
  }




  // FUNCIONES  --------------------------------

  // Cargar datos de colonias, ciudades y estados del CSV
  Future<void> cargarColonias() async {
    final data = await rootBundle.loadString('assets/colonias.csv');
    setState(() {
      csvTable = CsvToListConverter().convert(data);
    });
  }


  // Cargar ciudades
  Future<void> cargarDropdown() async {
    print("Iniciando función para mostrar ciudades");
    for (var row in csvTable) {
      var ciudad = ciudades.firstWhere((ciudad) => ciudad.name == "${row[3]}" && ciudad.estadoId == selectedState.id,
          orElse: () => Ciudad("id", "nombre", "estadoId"));
      if (ciudad.name == "nombre") {
        ciudad = Ciudad("${row[2]}", "${row[3]}", selectedState.id);
        ciudades.add(ciudad);
      }
    }
  }


  // Cargar colonias
  Future<void> cargarDropdownColonias() async {
    print("Iniciando función para mostrar colonias en la ciudad seleccionada.");
    for (var row in csvTable) {
      var estadoId = "${row[0]}";
      var ciudadId = "${row[2]}";
      var coloniaNombre = "${row[4]}";
      var id = "$estadoId-$ciudadId-$coloniaNombre";

      var colonia = colonias.firstWhere((colonia) => colonia.name == coloniaNombre && colonia.ciudadId == selectedCity.id,
          orElse: () => Colonia("id", "nombre", "ciudadId"));
      if (colonia.name == "nombre") {
        //colonia = Colonia("1", coloniaNombre, selectedCity.id);   //ciudadId
        colonia = Colonia(id, coloniaNombre, ciudadId);
        colonias.add(colonia);
      };
    }
    colonias = colonias.where((colonia) => colonia.ciudadId == selectedCity.id).toList();
  }




  // FUNCIÓN CREAR COLONIA
  // Revisa si ya existe un grupo para la colonia seleccionada. Si sí, agrega al usuario. Si no, crea el grupo.
  Future<void> _crearColonia() async {
    CollectionReference coleccionColonias = _firestore.collection("colonias");
    DocumentReference docColonia = coleccionColonias.doc(selectedNeighborhood.id);

    QuerySnapshot snapshotColonias = await coleccionColonias.where("id", isEqualTo: selectedNeighborhood.id).get();

    // Si ya existe una colonia, se actualiza
    if (snapshotColonias.docs.isNotEmpty) {   // Revisar si existe una colección con ese id.
//      coleccionColonias.where("id", isEqualTo: selectedNeighborhood.id).update({)
      print("La colonia ya existe, vamos a agregar al usuario a los miembros.");
      await docColonia.update({
        "miembros": FieldValue.arrayUnion([_auth.currentUser?.uid]),
        //"miembros": FieldValue.arrayUnion([_firestore.collection("usuarios").doc(user?.uid).id]),
      });
      // Si no existe aún, se crea una
    } else {
      await docColonia.set({   // crear nuevo grupo de colonia     // o con .add()  ??
        "id": selectedNeighborhood.id,
        "nombre": selectedNeighborhood.name,
        "ciudad": selectedCity.name,
        "estado": selectedState.name,
        "miembros": [_auth.currentUser?.uid],
      });
    }
    crearChatColonia(docColonia);
  }



  // FUNCIÓN CREAR CHAT DE COLONIA
  Future<void> crearChatColonia(docColonia) async {
    print("");
    print("Funcion crear chat de colonia");

    CollectionReference coleccionChatrooms = _firestore.collection("chatrooms");
    DocumentReference docChatroom = coleccionChatrooms.doc(selectedNeighborhood.id);
    QuerySnapshot snapshotChatColonia = await coleccionChatrooms.where("colonia-id", isEqualTo: selectedNeighborhood.id).get();
    //QuerySnapshot snapshotChatColonia = await coleccionChatrooms.where("colonia-id", isEqualTo: )

    if (snapshotChatColonia.docs.isNotEmpty) {
      print("El chat de colonia ya existe, vamos a agregar al usuario a los miembros del chat.");
      await docChatroom.update({
        "miembros": FieldValue.arrayUnion([_auth.currentUser?.uid]),
      });
    } else {
      docChatroom.set({
        "tipo": "vecinal",
        "colonia-id": selectedNeighborhood.id,
        "colonia-nombre": selectedNeighborhood.id,
        "nombre-chat": "Chat general - ${selectedNeighborhood.name}",
        "miembros": [_auth.currentUser?.uid],
        "ultimo-mensaje": "::: : ¡Inicia la conversación! : ::: :",
        "hora-ultimo-mensaje": DateTime.now(),
        "remitente-ultimo-mensaje": "",
      });
    };
  }



  // FUNCIÓN REGISTRO
  // debería llevar <Future> o no?
  Future<void> _register() async {
    CollectionReference usuarios = _firestore.collection("usuarios");
    try {
      final User? user = (
          await _auth.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          )
      ).user;

      if (user != null) {
        await usuarios.doc(user.uid).set({
          "email": _emailController.text,
          "nombre": _nombreController.text,
          "apellido": _apellidoController.text,
          "estado": selectedState.name,
          "ciudad": selectedCity.name,
          "colonia": selectedNeighborhood.name,
          "colonia-id": selectedNeighborhood.id,
          "fecha-creacion": DateTime.now(),
          "ultima-conexion": DateTime.now(),
        });

        await user.updateDisplayName(_nombreController.text);

        await user.sendEmailVerification();

        print("SE REGISTRÓ AL USUARIO CON ÉXITO");

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              //content: Text('Te has registrado con éxito. ¡Bienvenido a VecinApp!', style: Theme.of(context).textTheme.bodyLarge),
              content: Text('Te enviamos un correo para verificar tu cuenta.', style: Theme.of(context).textTheme.bodyLarge),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            )
        );
      } else {
        print("NO SE PUDO REGISTRAR");
      }

      // ERRORES
    } on FirebaseException catch (e) {
      setState(() {_error = true;});

      if (e.message!.contains("weak-password")) {
        descripError = "La contraseña debe de contener un mínimo de 6 caracteres.";
      } else if (e.message!.contains("auth/email-already-in-use")) {
        descripError = "El correo ingresado ya se encuentra en el sistema.\nRegresa para iniciar sesión o restablece tu contraseña.";
      } else {
        descripError = e.message!;
      }
    }

    // Llamar la función para agregar al usuario a la colonia.
    _crearColonia();
  }





  // GOOGLE SIGN IN
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      clientId: "944413830907-rvd45ucb788nid7ubd4eg406smm3v1i9.apps.googleusercontent.com",        // MI API
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


}

