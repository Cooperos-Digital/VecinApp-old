import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vecinapp_2/comp/estilos.dart';
import 'package:vecinapp_2/comp/chat_widgets.dart';
import 'package:vecinapp_2/logica/funciones_chat/enviar_mensaje.dart';

class ChatPage extends StatefulWidget {
  final String id;
  final String nombre;
  const ChatPage({Key? key, required this.id, required this.nombre}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var chatroomId;
  var tipoChat;


  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final usuario = FirebaseAuth.instance.currentUser;
//    print("Este es el id, ojalá se pueda leer: $id");

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: widget.nombre == null ? Text("conversación") : Text(widget.nombre) ,
        elevation: 0,
        actions: [IconButton(onPressed: () {

        }, icon: const Icon(Icons.more_vert))],
      ),


      // TÍTULO DE LA CONVERSACIÓN
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 50,),
                const Spacer(),
                Text('Ultimo mensaje: 04:50', style: Styles.h1().copyWith(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.black38),),
                const Spacer(),
                const SizedBox(width: 50,),
              ],
            ),
          ),

          // CONVERSACIÓN
          Expanded(
            child: Container(
              decoration: Styles.friendsBox(),
              child: StreamBuilder(
                stream: firestore.collection("chatrooms").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    print("INICIO");
                    print("chatrooms snapshot has data");

                    if (snapshot.data!.docs.isNotEmpty) {
                      print("widget id: ${widget.id}");
                      print("usuario id: ${usuario?.uid}");

                      // mostrar solo los mensajes de esta conversación  /  buscnado a sus miembros?
                      //List<QueryDocumentSnapshot?> allData = snapshot.data!.docs.where((element) => element["miembros"].contains(widget.id)  &&  element["miembros"].contains(usuario?.uid)).toList();
//                      List<QueryDocumentSnapshot?> allData = snapshot.data!.docs.where((element) => element["colonia-id"] == widget.id).toList();
                      List<QueryDocumentSnapshot> allData = snapshot.data!.docs.where((element) => element["tipo"]=="vecinal"   ?   element["colonia-id"]==widget.id   :   element["miembros"].contains(widget.id)  &&  element["miembros"].contains(usuario?.uid)).toList();
                      QueryDocumentSnapshot? data = allData.isNotEmpty  ?  allData.first  :  null;

                      print("data: $data");
                      print("data tipo: ${data?["tipo"]}");
                      tipoChat = data?["tipo"];
                      if (data != null && tipoChat != "vecinal") {
                        chatroomId = data.id;
                        print("Cambiar el chatroom id: $chatroomId");
                      }
                      else if (data != null && tipoChat == "vecinal") {
                        chatroomId = data["colonia-id"];
                      }

                      // mostrar los mensaje en la conversación en orden.
                      return data == null  ?  Container()  :  StreamBuilder(
                        stream: data.reference.collection("mensajes").orderBy("hora", descending: true).snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                          print("");
                          print("INICIO MENSAJES");
                          print("mensajes snap has data: ${snap.hasData}");
                          return !snap.hasData  ?  Container()  : ListView.builder(
                            itemCount: snap.data!.docs.length,
                            reverse: true,
                            itemBuilder: (context, i) {
                              var mensaje = snap.data!.docs[i];
                              return ChatWidgets.messagesCard(
                                  snap.data!.docs[i]["remitente"] == FirebaseAuth.instance.currentUser!.uid,   // widget.id   // estaba en !=, pero salían al revés.
                                  snap.data!.docs[i]["mensaje"],
                                  DateFormat("hh:mm a").format(mensaje["hora"].toDate()).toLowerCase(),
                                  //snap.data!.docs[i]["remitente"],
                                  "adan caballero",
                              );
                            },
                          );
                        }
                      );
                    } else {
                      return Text("No se encontró información", style: Styles.h1(),);
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),
                    );
                  }
                }
              ),
            ),
          ),

          Container(
            color: Colors.white,
            child: ChatWidgets.messageField(
              onSubmit: (controller) {
                enviarMensaje(firestore, usuario, controller, widget, chatroomId, tipoChat);
                controller.clear();
              }
            ),
          ),
          SizedBox(height: 6,),

        ],
      ),
    );
  }
}