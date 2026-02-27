enum ActivityType {
  transporte,
  energia,
  alimento,
  producto,
}

enum TransportType {
  coche,
  avion,
  autobus,
  tren,
  bicicleta,
  caminar,
  scooter,
}

class Activity {
  int? id;
  int userId;
  ActivityType type;
  TransportType? transportType;
  DateTime fecha;
  double distancia; // en km
  double emisionesCO2; // en kg
  int puntosGanados;
  String? descripcion;

  Activity({
    this.id,
    required this.userId,
    required this.type,
    this.transportType,
    required this.fecha,
    required this.distancia,
    required this.emisionesCO2,
    this.puntosGanados = 0,
    this.descripcion,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'userId': userId,
      'type': type.index,
      'transportType': transportType?.index,
      'fecha': fecha.toIso8601String(),
      'distancia': distancia,
      'emisionesCO2': emisionesCO2,
      'puntosGanados': puntosGanados,
      'descripcion': descripcion,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      userId: map['userId'],
      type: ActivityType.values[map['type']],
      transportType: map['transportType'] != null 
          ? TransportType.values[map['transportType']] 
          : null,
      fecha: DateTime.parse(map['fecha']),
      distancia: map['distancia'].toDouble(),
      emisionesCO2: map['emisionesCO2'].toDouble(),
      puntosGanados: map['puntosGanados'] ?? 0,
      descripcion: map['descripcion'],
    );
  }

  String get tipoActividad {
    switch (type) {
      case ActivityType.transporte:
        return 'Transporte';
      case ActivityType.energia:
        return 'Energía';
      case ActivityType.alimento:
        return 'Alimentación';
      case ActivityType.producto:
        return 'Producto';
    }
  }

  String get icono {
    switch (type) {
      case ActivityType.transporte:
        return '🚗';
      case ActivityType.energia:
        return '💡';
      case ActivityType.alimento:
        return '🥗';
      case ActivityType.producto:
        return '🛒';
    }
  }
}
