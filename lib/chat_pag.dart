import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vecinapp_2/comp/estilos.dart';
import 'package:vecinapp_2/comp/chat_widgets.dart';

class ChatPage extends StatefulWidget {
  final String id;
  const ChatPage({Key? key, required this.id}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var chatroomId;


  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final usuario = FirebaseAuth.instance.currentUser;
//    print("Este es el id, ojalá se pueda leer: $id");

    return Scaffold(
      backgroundColor: Colors.indigo.shade400,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade400,
        title: const Text('Conversación ...'),
        elevation: 0,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
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
                Text(
                  'Chats',
                  style: Styles.h1(),
                ),
                const Spacer(),
                Text(
                  'Last seen: 04:50',
                  style: Styles.h1().copyWith(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.white70),
                ),

                const Spacer(),
                const SizedBox(width: 50,)
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
                    print("snapshot has data");

                    if (snapshot.data!.docs.isNotEmpty) {
                      print("snapshot no es empty");
                      //print("id: $id");
                      print("widget id: ${widget.id}");
                      print("usuario id: ${usuario?.uid}");

                      // mostrar solo los mensajes de esta conversación  /  o los de este miembro?
                      //List<QueryDocumentSnapshot?> allData = snapshot.data!.docs.where((element) => element["miembros"].contains(widget.id)  &&  element["miembros"].contains(usuario?.uid)).toList();
                      //List<QueryDocumentSnapshot?> allData = snapshot.data!.docs.where((element) => element["miembros"].contains(id)  &&  element["miembros"].contains(usuario?.uid)).toList();
                      //List<QueryDocumentSnapshot?> allData = snapshot.data!.docs.where((element) => element["miembros"].contains(usuario?.uid)).toList();
                      List<QueryDocumentSnapshot?> allData = snapshot.data!.docs.where((element) => element["miembros"].contains(widget.id)  &&  element["miembros"].contains(usuario?.uid)).toList();
                      QueryDocumentSnapshot? data = allData.isNotEmpty  ?  allData.first  :  null;

                      //print("data id: ${data.id}");
                      if (allData.isNotEmpty) {
                        print("data no es empty");
                      } else {
                        print("data es empty");
                      };
                      if (data != null) {
                        print("data no es null");
                        chatroomId = data.id;
                        print("success en cambiar chatroom id: $chatroomId");
                        print("widget id 2: ${widget.id}");
                        print("usuario id 2: ${usuario?.uid}");
                        //setState(() {chatroomId = data.id;});
                      }

                      // mostrar los mensaje en la conversación en orden.
                      return data == null  ?  Container()  :  StreamBuilder(
                        stream: data.reference.collection("mensajes").orderBy("hora", descending: true).snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                          print("snap has data: ${snap.hasData}");
                          print("snap: $snap");
                          print("chatroom id: $chatroomId");
                          //child: Text("Algo está mal"),
                          return !snap.hasData  ?  Container()  : ListView.builder(
                            itemCount: snap.data!.docs.length,
                            reverse: true,
                            itemBuilder: (context, i) {
                              var mensaje = snap.data!.docs[i];
                              return ChatWidgets.messagesCard(
                                  snap.data!.docs[i]["remitente"] != widget.id,
                                  snap.data!.docs[i]["mensaje"],
                                  DateFormat("hh:mm a").format(mensaje["hora"].toDate()));
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
                if (chatroomId != null) {
                  Map<String, dynamic> data = {
                    "mensaje": controller.text.trim(),
                    "remitente": usuario?.uid,
                    "hora": DateTime.now(),
                  };
                  firestore.collection("chatrooms").doc(chatroomId).collection("mensajes").add(data);

                } else {
                  Map<String, dynamic> data = {
                    "mensaje": controller.text.trim(),
                    "remitente": usuario?.uid,
                    "hora": DateTime.now(),
                  };
                  firestore.collection("chatrooms").add({
                    "miembros": [usuario?.uid]
                  }).then((value) async {
                    value.collection("mensajes").add(data);
                  });
                };

                controller.clear();
              }
            ),
          )

        ],
      ),
    );
  }
}