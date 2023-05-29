import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vecinapp_2/comp/chat_widgets.dart';
import 'package:vecinapp_2/chat_pag.dart';


class AnimatedDialog extends StatefulWidget {
  final double height;
  final double width;

  const AnimatedDialog({Key? key, required this.height, required this.width})
      : super(key: key);

  @override
  State<AnimatedDialog> createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog> {
  final _firestore = FirebaseFirestore.instance;
  var search = "";
  bool show = false;

  @override
  Widget build(BuildContext context) {
    if(widget.height != 0){
      Timer(const Duration(milliseconds: 200), () {
        setState(() {
          show = true;
        });
      });
    }else{
      setState(() {
        show = false;
      });
    }

    // BOTÓN Y MENÚ DE SEARCH
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
              color:widget.width == 0 ? Colors.indigo.withOpacity(0):  Colors.indigo.shade400,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.width == 0 ? 100 : 0),
                bottomRight: Radius.circular(widget.width == 0 ? 100 : 0),
                bottomLeft: Radius.circular(widget.width == 0 ? 100 : 0),
              )),
          child: widget.width == 0 ? null : !show ? null :  Column(
            children: [
              ChatWidgets.searchField(
                onChange: (input) {
                  setState(() {
                    search = input;
                  });
                }
              ),

              // MENÚ DESPLEGABLE CON RESULTADOS DE SEARCH
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: StreamBuilder(
                    stream: _firestore.collection("usuarios").snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      List data = !snapshot.hasData?  []:  snapshot.data!.docs.where((usuario) => usuario["email"].toString().contains(search)).toList();
                      // data van a ser los usuarios
                      return data.isEmpty || data == [] ? Padding(padding: EdgeInsets.all(10), child: Text("No se encontraron resultados"),)  :  ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, i) {
                          Timestamp time = data[i]["ultima-conexion"];
                          return ChatWidgets.card(
                            title: data[i]["nombre"] ?? "No hay resultados",
                            subtitle: "oij",
                            time: DateFormat("EEE hh:mm").format(time.toDate()),    // requiere el package "intl"
                            //time: time.toString(),
                            onTap: () {
                              //Navigator.of(context).pop();
                              //setState(() {show: false;});
                              print("Abrir conversacion");
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ChatPage(   // este ChatPage era un  const  pero eso marcaba error.
                                      id: data[i].id.toString(),
//                                      id: "",
                                    );
                                  },
                                ),
                              );
                            },
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
      ],
    );
  }
}