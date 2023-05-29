import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WidgetsPag {
  static drawerMenu(context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: Text(
              'Men�',
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
              print("Ir a pag Mensajes");
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/chat");
              //Navigator.push(MaterialPageRoute(builder: (context)=>MainChatPag()))
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Perfil'),
            onTap: () {
              print("Ir a pag Perfil");
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/perfil");
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Preferencias'),
            onTap: () {
              print("Ir a pag Preferencias");
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/preferencias");
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesi�n'),
            onTap: () {
              print("Cerrar sesion");
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}