//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:vecinapp_2/comp/chat_widgets.dart';
import 'package:vecinapp_2/comp/estilos.dart';
import 'package:vecinapp_2/comp/chat_widgets.dart';
import 'package:vecinapp_2/comp/widgets_pag.dart';
import 'package:vecinapp_2/chat_pag.dart';
import 'package:vecinapp_2/logica/funciones.dart';


class MainChatPag extends StatefulWidget {
  const MainChatPag({Key? key}) : super(key: key);
  @override
  State<MainChatPag> createState() => _MainChatPagState();
}

class _MainChatPagState extends State<MainChatPag> {
  bool open  = false;

  @override
  void initState() {
     Funciones.updateData();
    super.initState();
  }

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,

      // BARRA SUPERIOR
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Chat'),
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  open == true? open = false: open = true;
                });
              },
              icon:  Icon(
                open == true? Icons.close_rounded :Icons.search_rounded,
                size: 30,
              ),
            ),
          )
        ],
      ),

      // MENU
      //drawer: ChatWidgets.drawer(),
      drawer: WidgetsPag.drawerMenu(context),


      // CONTENIDO PRINCIPAL DE LA PÁGINA
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // USUARIOS CONECTADOS / AMIGOS: PERSONAS DE LA COLONIA, AMIGOS AGREGADOS, ETC.
                // Pondría convertirse en un lugar para poner la colonia a la que se pertenece, como en el wireframe de figma.
                Container(
                  margin: const EdgeInsets.all(0),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8),
                    height: 160,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10),
                          child: Text(
                            'Personas conectadas',
                            style: Styles.h1(),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),   // era 10 pero se desbordaba por 5px
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              return ChatWidgets.circleProfile();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // LISTA DE CONVERSACIONES
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Container(
                      color: Colors.white70,
                      child: Container(
                        //margin: const EdgeInsets.only(top: 10),
                        decoration: Styles.friendsBox(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                'Conversaciones',
                                style: Styles.h1().copyWith(color: Theme.of(context).primaryColor),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: StreamBuilder(
                                  stream: firestore.collection("chatrooms").snapshots(),
                                  builder: (context, snapshot) {
                                    // selecciona los chatrooms de los que el usuario es miembro
                                    print("");
                                    print("INICIO SNAPSHOT");
                                    print("");
                                    print("Chatrooms snapshot has data: ${snapshot.hasData}");
                                    List data = !snapshot.hasData ? [] : snapshot.data!.docs.where((element) => element["miembros"].toString().contains(FirebaseAuth.instance.currentUser!.uid)).toList();
                                    return ListView.builder(
                                      itemCount: data.length,
                                      itemBuilder: (context, i) {
                                        // busca al usuario entre los miembros (amigo) y luego revisa si
                                        List miembros = data[i]["miembros"];
                                        var amigo = miembros.where((element) => element != FirebaseAuth.instance.currentUser!.uid);
                                        var usuario = amigo.isNotEmpty ? amigo.first : miembros.where((element) => element == FirebaseAuth.instance.currentUser!.uid).first ;
                                        print("amigo: $amigo");
                                        print("usuario: $usuario");
                                        print("mi id: ${FirebaseAuth.instance.currentUser?.uid}");
                                        print("tipo de chat: ${data[i]["tipo"]}");
                                        var amigoId = miembros[0]==FirebaseAuth.instance.currentUser?.uid && data[i]["tipo"]=="unoauno" ? miembros[1] : miembros[0];
                                        print("amigo id: $amigoId");
                                        return FutureBuilder(
                                          future: firestore.collection("usuarios").doc(amigoId).get(),
                                          builder: (context, AsyncSnapshot snap) {
                                            print("");
                                            print("INICIO MENSAJES");
                                            print("Usuarios snap has data: ${snap.hasData}");
                                            var nombre = snap.hasData ? snap.data["nombre"] : "El usuario ya no existe";
                                            return !snap.hasData ? Container() :  ChatWidgets.card(
                                              title: data[i]["tipo"]=="unoauno" ? nombre : data[i]["nombre-chat"],
                                              subtitle: data[i]["tipo"]=="unoauno" ? data[i]["ultimo-mensaje"] : "${data[i]['remitente-ultimo-mensaje']}: ${data[i]['ultimo-mensaje']}",
                                              time: DateFormat("hh:mm a").format(data[i]["hora-ultimo-mensaje"].toDate()),
                                              onTap: () {
                                                print("Ir a conversacion");
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      if (data[i]["tipo"] == "vecinal") {
                                                        return ChatPage(id: data[i].id, nombre: data[i]["nombre-chat"]);
                                                      } else {
                                                        //return ChatPage(id: usuario,);
                                                        return ChatPage(id: amigoId, nombre: nombre);
                                                      }
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        );
                                      },
                                    );
                                  }
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ChatWidgets.searchBar(open)
          ],
        ),
      ),
    );
  }
}