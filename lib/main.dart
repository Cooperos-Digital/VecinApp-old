// APLICACIÓN
// -- VECINAPP

// MÓDULOS pubspec
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';


// CLASES
import 'ingreso.dart';
//import 'registro_cloud.dart';
import "registro.dart";
import 'perfil.dart';
import 'home.dart';
import "preferencias.dart";


// INICIALIZAR LA APP
// Void main() async {}...
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
//  await FirebaseAuth.instance.useAuthEmulator('localhost', 53531);


  // ESTO POR AHORA NO HACE NADA
  // PERO ESTO SE PUEDE USAR PARA DETECTAR SI EL USUARIO YA ESTABA REGISTRADO Y MANDARLO DIRECTAMENTE AL HOME.
  // con un StreamBuilder widget.
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
      print("Usuario id: ${user?.uid}");
      //Navigator.of(context).pushNamed("/registro");
    } else {
      print('User is signed in!');
      //Navigator.of(context).pushNamed("/home");
    }
  });

  //final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //final user = userCredential.user;





  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String userEmail = "";

  // CONFIGURACIÓN INICIAL
    return MaterialApp(
        home: const MyHomePage(title: 'VecinApp'),
        debugShowCheckedModeBanner: false,
        title: 'VecinApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          //buttonColor: Colors.lightGreen,
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
          ),
          useMaterial3: true,
        ),


      // RUTAS (PÁGINAS)
      routes: <String, WidgetBuilder> {
        "/ingreso": (BuildContext context) => IngresoPag(),
        "/registro": (BuildContext context) => RegistroPag(),
        "/home": (BuildContext context) => HomePag(userEmail: userEmail),
        "/perfil": (BuildContext context) => PerfilPag(),
        "/preferencias": (BuildContext context) => PreferenciasPag(),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// PÁGINA PRINCIPAL
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,

        // ESTRUCTURA
        children: <Widget>[
          SizedBox(height: 120),

          // TÍTULO
          Container(
              child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(30),
                child: Text(
                  "VecinApp",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Arial",
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            ],
          )),

          SizedBox(height: 40),

          //PRESENTACIÓN / FRASE
          Container(
              padding: EdgeInsets.all(20),
              child: Text(
                "A ponernos de acuerdo",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Montserrat",
                ),
              )),

          //SizedBox(height: 300),
          Spacer(
            flex: 2,
          ),

          // BOTÓN
          Container(
              width: 300,
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                child: Text(
                  "INGRESAR",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    // - color:
                  ),
                ),
                onPressed: () {
                  print("Vamos a la página de ingreso.");
                  //Navigator.of(context).pushNamed("/registro");

                  FirebaseAuth.instance.authStateChanges().listen((User? user) {
                    if (user == null) {
                      Navigator.of(context).pushNamed("/ingreso");
                      print('User is currently signed out!');
                    } else {
                      Navigator.of(context).pushNamed("/home");
                      print('User is signed in!');
                      print("User id: ${user.uid}");
                      print("User email: ${user.email}");
                      //appState.userEmail = user.email;
//                      _userEmail = user.email == null ? user.email : "";
//                      var fwe = user.email;
//                      Navigator.of(context).push(
//                        MaterialPageRoute(
//                          builder: (context) => HomePag(userEmail: fwe),
//                        ),
//                      );

                    }
                  });
                },
              )),

          SizedBox(height: 60),
        ],
      ),
    ));
  }
}
