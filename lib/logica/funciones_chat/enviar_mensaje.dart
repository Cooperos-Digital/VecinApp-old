enviarMensaje(firestore, usuario, controller, widget, chatroomId, tipo) {

  if (chatroomId != null  && tipo != "vecinal") {
    Map<String, dynamic> data = {
      "mensaje": controller.text.trim(),
      "remitente": usuario?.uid,
      "hora": DateTime.now(),
    };
    firestore.collection("chatrooms").doc(chatroomId).update({
      "ultimo-mensaje": controller.text,
      "remitente-ultimo-mensaje": usuario?.displayName,
      "hora-ultimo-mensaje": DateTime.now(),
    });
    firestore.collection("chatrooms").doc(chatroomId).collection("mensajes").add(data);
    print("Mensaje enviado: ${controller.text.trim}");


  } else if (tipo == "vecinal") {
    Map<String, dynamic> data = {
      "mensaje": controller.text.trim(),
      "remitente": usuario?.uid,
      "hora": DateTime.now(),
    };
    firestore.collection("chatrooms").doc(chatroomId).update({
      "ultimo-mensaje": controller.text,
      "remitente-ultimo-mensaje": usuario?.displayName,
      "hora-ultimo-mensaje": DateTime.now(),
    });
    firestore.collection("chatrooms").doc(chatroomId).collection("mensajes").add(data);


  } else {
    Map<String, dynamic> data = {
      "mensaje": controller.text.trim(),
      "remitente": usuario?.uid,
      "hora": DateTime.now(),
    };
    firestore.collection("chatrooms").add({
      "tipo": "unoauno",
      "miembros": [widget.id, usuario?.uid],
      "ultimo-mensaje": controller.text,
      "remitente-ultimo-mensaje": usuario?.displayName,
      "hora-ultimo-mensaje": DateTime.now(),
    }).then((value) async {
      value.collection("mensajes").add(data);
    });
  };
}