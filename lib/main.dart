// APLICACIÓN
// -- VECINAPP

// MÓDULOS pubspec
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_core.auth';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// CLASES
import 'registro.dart';
//import 'registro_cloud.dart';
import "signup.dart";
import 'perfil.dart';
import 'home.dart';



// INICIALIZAR LA APP
// Future<void> main() async {}...
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  // CONFIGURACIÓN INICIAL
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
        "/registro": (BuildContext context) => RegistroPag(),
        "/signup": (BuildContext context) => SignupPag(),
        "/home": (BuildContext context) => HomePag(),
        "/perfil": (BuildContext context) => PerfilPag(),
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
                    child: Text("VecinApp",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Arial",
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                ],
              )
            ),

            SizedBox(height: 40),

            //PRESENTACIÓN / FRASE
            Container(
                padding: EdgeInsets.all(20),
                child: Text("A ponernos de acuerdo",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Montserrat",
                  ),
                )
            ),

            //SizedBox(height: 300),
            Spacer(flex: 2,),

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
                  Navigator.of(context).pushNamed("/registro");
                  //appState.RegistroPag
                },
              )
            ),

            SizedBox(height: 60),
          ],
        ),
      )
    );
  }
}
