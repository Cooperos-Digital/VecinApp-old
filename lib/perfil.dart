//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


class PerfilPag extends StatefulWidget {
  @override
  _PerfilPagState createState() => _PerfilPagState();
}

class _PerfilPagState extends State<PerfilPag> {
  String imagenUrl = "";


  // ESCOGER IMAGEN DE PERFIL
  // https://www.youtube.com/watch?v=0mLICZlWb2k&t=94s
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
  PickedFile? _image;
  Future<void> getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedFile;
    });
  }
  // Implement function to upload image to Firebase storage
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadFile() async {
    Reference reference = storage.ref().child('images/${_image!.path}');
    UploadTask uploadTask = reference.putFile(File(_image!.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      imagenUrl = url;
    });
    return url;
  }

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

        child: SizedBox(
          height: MediaQuery.of(context).size.height,
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
                    uploadFile();
                    print("Imagen de usuario: ${imagenUrl}");
                  },

                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: MediaQuery.of(context).size.width * 0.12,

                    //child: FirebaseAuth.instance.currentUser?.photoURL != null ?
                    //Image.network(FirebaseAuth.instance.currentUser?.photoURL.toString() ?? "", width: 80,) :
                    //Icon(Icons.person_add, size: 80, color: Theme.of(context).splashColor,),

                    child: imagenUrl == "" ?
                      Icon(Icons.person_add, size: 80, color: Theme.of(context).splashColor,) :
                      Image.network(imagenUrl, width: 80,)

                    //CircleAvatar(
                    //  backgroundImage: AssetImage("assets/usuario1.jpg",),
                    //  radius: MediaQuery.of(context).size.width * 0.11,
                    //)

                  ),
                ),

                SizedBox(height: 45,),

                Text("Foto: ${FirebaseAuth.instance.currentUser?.photoURL}"),


                // DATOS DEL USUARIO
  //          Text("Tu correo: ${widget.userEmail}"),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Text("Nombre"),
                        subtitle: Text(FirebaseAuth.instance.currentUser?.displayName ?? "Persona"),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            print("se verá más bonito?");
                          }
                        ),
                      ),
                      //ListTile(
                      //  title: Text("Apellido"),
                      //  subtitle: Text(FirebaseAuth.instance.currentUser?.providerData.first.displayName  ?? "Anónima"),
                      //  trailing: IconButton(
                      //    icon: Icon(Icons.edit),
                      //    onPressed: () {
                      //      print("se verá más bonito?");
                      //    }
                      //  ),
                      //),
                      ListTile(
                        //                leading: ,
                        title: Text("Correo electrónico"),
                        subtitle: Text(FirebaseAuth.instance.currentUser?.email ?? "Aún no tienes correo, ingresa uno."),
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
                          //if ( FirebaseAuth.instance.currentUser?.emailVerified == true) {
                          //  FirebaseAuth.instance.currentUser?.emailVerified : "Aún no tienes correo, ingresa uno."),
                          //}

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
                ),

                SizedBox(height: 30,),




                // ----------------------
            // Retrieve image URL from user's profile in Firestore and display it
            //StreamBuilder<DocumentSnapshot>(
            //  stream: firestore.collection('users').doc('userId').snapshots(),
            //  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            //    if (snapshot.hasError) {
            //      return Text('Error: ${snapshot.error}');
            //    } else if (!snapshot.hasData) {
            //      return Text('Loading...');
            //    } else {
            //      String imageUrl = snapshot.data!.get('profileImageUrl');
            //      return Image.network(imageUrl);
            //    }
            //  },
            //);
              // -------------


                // BOTÓN CERRAR SESIÓN
                Container(
                  child: TextButton(
                    child: Text(
                      "Cerrar sesión",
                      //style: ButtonThemeData.textTheme,
                    ),
                    onPressed: () {
                      print("Cerrando sesión...");
                      FirebaseAuth.instance.signOut();
                      //Navigator.of(context).pup();
                      Navigator.pop(context);
                    },
                  ),
                ),

                SizedBox(height: 15,),


                // BOTÓN ELIMINAR CUENTA
                Container(
                  child: TextButton(
                    child: Text(
                      "Eliminar cuenta",
                      //style: ButtonThemeData.textTheme,
                    ),
                    onPressed: () async {
                      print("Eliminar cuenta...");
                      if (FirebaseAuth.instance.currentUser != null) {
                        await FirebaseAuth.instance.currentUser?.delete();
                        //Navigator.of(context).pop();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Es una pena ver que te vas. Tu cuenta se ha eliminado.', style: Theme.of(context).textTheme.bodyLarge),
                              backgroundColor: Theme.of(context).colorScheme.surface,
                            )
                        );
                      }
//                     await user? delete;
                    },
                  ),
                ),

                SizedBox(height: 15,),


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

                SizedBox(height: 120,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}