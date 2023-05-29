
class Estado {
  String id;
  String name;
  Estado(this.id, this.name);
}

class Ciudad {
  String id;
  String name;
  String estadoId;
  Ciudad(this.id, this.name, this.estadoId);
}

class Colonia {
  String id;
  String name;
  String ciudadId;
  Colonia(this.id, this.name, this.ciudadId);
}


