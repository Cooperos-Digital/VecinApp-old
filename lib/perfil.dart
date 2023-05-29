//import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

import 'package:image_picker_web/image_picker_web.dart';
import 'package:vecinapp_2/logica/funciones_usuario.dart';


class PerfilPag extends StatefulWidget {
  @override
  _PerfilPagState createState() => _PerfilPagState();
}

class _PerfilPagState extends State<PerfilPag> {
  String _nombre = "Persona";
  String _apellido = "Anónima";
  String _email = "sin correo";
  String _colonia_id = "colonia id";
  String _colonia = "colonia";
  String _ciudad = "ciudad";
  String _estado = "estado";
  String _photoUrl = "";

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // TRAER LA INFO DEL USUARIO DE FIRESTORE DATABASE
  Future<void> _getUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('usuarios').doc(user?.uid).get();

    setState(() {
      _nombre = snapshot.get('nombre');
      _apellido = snapshot.get("apellido");
      _email = snapshot.get('email');
      _colonia_id = snapshot.get('colonia-id');
      _colonia = snapshot.get('colonia');
      _ciudad = snapshot.get("ciudad");
      _estado = snapshot.get('estado');
      //_photoUrl = snapshot.get('photoUrl');
    });
  }

  // ESCOGER IMAGEN DE PERFIL  -
  // https://www.youtube.com/watch?v=0mLICZlWb2k&t=94s
  // and this one for web: https://www.youtube.com/watch?v=vZHWE6S9RHY
  // Tristemente creo que no funcionan bien. Aún. Falta entenderle más
  //void escogerImagenPerfil() async {
  //  print("subiendo imagen...");
  //  final imagen = await ImagePicker().pickImage(
  //    source: ImageSource.gallery,
  //    maxWidth: 520,
  //    maxHeight: 520,
  //    imageQuality: 75,
  //  );
  //  Reference ref = FirebaseStorage.instance.ref().child("profilepic.jpg");
  //  await ref.putFile(File(imagen!.path));
  //  ref.getDownloadURL().then((value) => {
  //    //FirebaseAuth.instance.currentUser?.photoURL = value,
  //    FirebaseAuth.instance.currentUser?.updatePhotoURL(value.toString()),
  //    print(value.toString()),
  //    print(value),
  //    setState(() {
  //      imagenUrl = value;
  //    }),
  //  });
  //}
  //PickedFile? _image;

  Future<void> getImage() async {
    PickedFile? pickedFile;
    if (kIsWeb) {
      print("Aplicación corriendo en Web");
//      pickedFile = await ImagePickerWeb.getImageAsFile();   // or as a File?
      print(pickedFile);

    } else {
      pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
      print(pickedFile);
    }

    setState(() {
    //  _image = pickedFile! ?? "";
    });
  }
  // Implement function to upload image to Firebase storage
  //FirebaseStorage storage = FirebaseStorage.instance;

  //Future<String> uploadFile() async {
  //  Reference reference = storage.ref().child('images/${_image!.path}');
  //  UploadTask uploadTask = reference.putFile(File(_image!.path));
  //  TaskSnapshot taskSnapshot = await uploadTask;
  //  String url = await taskSnapshot.ref.getDownloadURL();
  //  setState(() {
  //    imagenUrl = url;
  //  });
  //  return url;
  //}

// Save image URL to user's profile in Firestore
//  final FirebaseFirestore firestore = FirebaseFirestore.instance;

//  void saveImageToProfile(String imageUrl) {
//    firestore.collection('users').doc('userId').update({
//      'profileImageUrl': imageUrl,
//    });
//  }







  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 0.9,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).primaryColorDark,
          onPressed: () {
            Navigator.of(context).pushNamed("/home");
//            Navigator.of(context).pop();
          },
        ),
      ),


      // CONTENIDO DE LA PÁGINA DE PERFIL
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        scrollDirection: Axis.vertical,

        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,

            children: [
              //SizedBox(height: 30,),

              Text(
                "Perfil",
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              SizedBox(height: 30,),


              // IMAGEN DEL USUARIO
              GestureDetector(
                onTap: () async {
                  //escogerImagenPerfil();
                  getImage();
                  //uploadFile();
                  print("Imagen de usuario: ${_photoUrl}");
                },

                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: MediaQuery.of(context).size.width * 0.12,

                  //child: FirebaseAuth.instance.currentUser?.photoURL != null ?
                  //Image.network(FirebaseAuth.instance.currentUser?.photoURL.toString() ?? "", width: 80,) :
                  //Icon(Icons.person_add, size: 80, color: Theme.of(context).splashColor,),

                  child: _photoUrl == "" ?
                    Icon(Icons.person_add, size: 80, color: Theme.of(context).splashColor,) :
                    Image.network(_photoUrl, width: 80,)

                  //CircleAvatar(
                  //  backgroundImage: AssetImage("assets/usuario1.jpg",),
                  //  radius: MediaQuery.of(context).size.width * 0.11,
                  //)

                ),
              ),


              Text("Foto: ${FirebaseAuth.instance.currentUser?.photoURL}"),
              Text("Foto: ${_photoUrl}"),
              Text("$_colonia."),
              Text("$_ciudad, $_estado."),
              Text("$_colonia_id"),
              Text("Gente de tu colonia"),

              SizedBox(height: 45,),


              // DATOS DEL USUARIO
              ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text("Nombre"),
                    subtitle: Text(_nombre),
//                        subtitle: Text(FirebaseAuth.instance.currentUser?.displayName ?? "Persona"),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {}
                    ),
                  ),
                  ListTile(
                    title: Text("Apellido"),
                    subtitle: Text(_apellido),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {}
                    ),
                  ),
                  ListTile(
                    //leading: ,
                    title: Text("Correo electrónico"),
                    subtitle: Text(_email),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        print("se verá más bonito?");
                      },
                    )
                  ),
                  ListTile(
                    title: Text("Verificación"),
                    subtitle: Text(
                      FirebaseAuth.instance.currentUser?.emailVerified == true ? "Usuario verificado" : "Aún no estás verificado. ¡Solicita tu correo de verificación!"
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        print("se verá más bonito?");
                      },
                    )
                  ),
                ],
              ),

              SizedBox(height: 50,),


              // BOTÓN CERRAR SESIÓN
              Container(
                child: TextButton(
                  child: Text(
                    "Cerrar sesión",
                    //style: ButtonThemeData.textTheme,
                  ),
                  onPressed: () {
                    print("Cerrando sesión...");
                    cerrarSesion();
                    //FirebaseAuth.instance.signOut();
                    //Navigator.of(context).pup();
                    Navigator.pop(context);
                  },
                ),
              ),

              SizedBox(height: 15,),


              // BOTÓN ELIMINAR CUENTA
              //Container(
              //  child: TextButton(
              //    child: Text(
              //      "Eliminar cuenta",
              //      //style: ButtonThemeData.textTheme,
              //    ),
              //    onPressed: () async {
              //      print("Eliminar cuenta...");
              //      if (FirebaseAuth.instance.currentUser != null) {
              //        eliminarCuenta();
              //      }
//            //         await user? delete;
              //    },
              //  ),
              //),

              //SizedBox(height: 15,),


              // BOTÓN RESTABLECER CONTRASEÑA
              Container(
                child: TextButton(
                  child: Text(
                    "Restablecer contraseña",
                    //style: ButtonThemeData.textTheme,
                  ),
                  onPressed: () async {
                    print("Mandar correo para restablecer contraseña...");
                    if (FirebaseAuth.instance.currentUser != null) {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: FirebaseAuth.instance.currentUser?.email ?? "");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Te enviamos un correo con la liga para restablecer tu contraseña.', style: Theme.of(context).textTheme.bodyMedium),
                          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                        )
                      );
                    }
                  },
                ),
              ),

              SizedBox(height: 90,),
            ],
          ),
        ),
      ),
    );
  }
}