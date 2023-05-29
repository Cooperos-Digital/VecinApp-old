//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:vecinapp_2/comp/chat_widgets.dart';
import 'package:vecinapp_2/comp/estilos.dart';
import 'package:vecinapp_2/comp/chat_widgets.dart';
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
    //
     Funciones.updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,

      // BARRA SUPERIOR
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
                )),
          )
        ],
      ),

      // MENU
      drawer: ChatWidgets.drawer(),


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
                                child: ListView.builder(
                                  itemBuilder: (context, i) {
                                    return ChatWidgets.card(
                                      title: 'John Doe',
                                      subtitle: 'Hi, How are you !',
                                      time: '04:40',
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ChatPage(
                                                //id: data[i].id,
                                                //id: "${data[i].id}",
                                               // id: data[i].id,
                                                id: "",
                                                //id: data[i].id.toString(),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
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