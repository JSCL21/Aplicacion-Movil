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

enum EnergyType {
  electricidad,
  gas_natural,
  gasolina,
}

enum FoodType {
  carne_res,
  carne_pollo,
  pescado,
  huevos,
  leche,
  arroz,
  vegetales,
  frutas,
  legumbres,
}

enum ProductType {
  electronicos,
  ropa,
  plastico,
  papel,
  vidrio,
  metal,
}

class Activity {
  int? id;
  int userId;
  ActivityType type;
  TransportType? transportType;
  EnergyType? energyType;
  FoodType? foodType;
  ProductType? productType;
  DateTime fecha;
  double cantidad; // km para transporte, kWh para energia, kg para alimentos/productos
  double emisionesCO2; // en kg
  int puntosGanados;
  String? descripcion;

  Activity({
    this.id,
    required this.userId,
    required this.type,
    this.transportType,
    this.energyType,
    this.foodType,
    this.productType,
    required this.fecha,
    required this.cantidad,
    required this.emisionesCO2,
    this.puntosGanados = 0,
    this.descripcion,
  });

  // Getter para mantener compatibilidad con código existente
  double get distancia => cantidad;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'userId': userId,
      'type': type.index,
      'transportType': transportType?.index,
      'energyType': energyType?.index,
      'foodType': foodType?.index,
      'productType': productType?.index,
      'fecha': fecha.toIso8601String(),
      'cantidad': cantidad,
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
      energyType: map['energyType'] != null 
          ? EnergyType.values[map['energyType']] 
          : null,
      foodType: map['foodType'] != null 
          ? FoodType.values[map['foodType']] 
          : null,
      productType: map['productType'] != null 
          ? ProductType.values[map['productType']] 
          : null,
      fecha: DateTime.parse(map['fecha']),
      cantidad: map['cantidad'].toDouble(),
      emisionesCO2: map['emisionesCO2'].toDouble(),
      puntosGanados: map['puntosGanados'] ?? 0,
      descripcion: map['descripcion'],
    );
  }

  String get tipoActividad {
    switch (type) {
      case ActivityType.transporte:
        if (transportType != null) {
          return 'Transporte - ${nombreTransporte}';
        }
        return 'Transporte';
      case ActivityType.energia:
        if (energyType != null) {
          return 'Energía - ${nombreEnergia}';
        }
        return 'Energía';
      case ActivityType.alimento:
        if (foodType != null) {
          return 'Alimentación - ${nombreAlimento}';
        }
        return 'Alimentación';
      case ActivityType.producto:
        if (productType != null) {
          return 'Producto - ${nombreProducto}';
        }
        return 'Producto';
    }
  }

  String get icono {
    switch (type) {
      case ActivityType.transporte:
        return _getTransporteIcono();
      case ActivityType.energia:
        return _getEnergiaIcono();
      case ActivityType.alimento:
        return _getAlimentoIcono();
      case ActivityType.producto:
        return _getProductoIcono();
    }
  }

  String _getTransporteIcono() {
    if (transportType == null) return '🚗';
    switch (transportType!) {
      case TransportType.coche:
        return '🚗';
      case TransportType.avion:
        return '✈️';
      case TransportType.autobus:
        return '🚌';
      case TransportType.tren:
        return '🚆';
      case TransportType.bicicleta:
        return '🚲';
      case TransportType.caminar:
        return '🚶';
      case TransportType.scooter:
        return '🛴';
    }
  }

  String _getEnergiaIcono() {
    if (energyType == null) return '💡';
    switch (energyType!) {
      case EnergyType.electricidad:
        return '⚡';
      case EnergyType.gas_natural:
        return '🔥';
      case EnergyType.gasolina:
        return '⛽';
    }
  }

  String _getAlimentoIcono() {
    if (foodType == null) return '🥗';
    switch (foodType!) {
      case FoodType.carne_res:
        return '🥩';
      case FoodType.carne_pollo:
        return '🍗';
      case FoodType.pescado:
        return '🐟';
      case FoodType.huevos:
        return '🥚';
      case FoodType.leche:
        return '🥛';
      case FoodType.arroz:
        return '🍚';
      case FoodType.vegetales:
        return '🥬';
      case FoodType.frutas:
        return '🍎';
      case FoodType.legumbres:
        return '🫘';
    }
  }

  String _getProductoIcono() {
    if (productType == null) return '🛒';
    switch (productType!) {
      case ProductType.electronicos:
        return '📱';
      case ProductType.ropa:
        return '👕';
      case ProductType.plastico:
        return '🧴';
      case ProductType.papel:
        return '📄';
      case ProductType.vidrio:
        return '🫙';
      case ProductType.metal:
        return '🔧';
    }
  }

  String get nombreTransporte {
    if (transportType == null) return 'Transporte';
    switch (transportType!) {
      case TransportType.coche:
        return 'Coche';
      case TransportType.avion:
        return 'Avión';
      case TransportType.autobus:
        return 'Autobús';
      case TransportType.tren:
        return 'Tren';
      case TransportType.bicicleta:
        return 'Bicicleta';
      case TransportType.caminar:
        return 'Caminar';
      case TransportType.scooter:
        return 'Scooter';
    }
  }

  String get nombreEnergia {
    if (energyType == null) return 'Energía';
    switch (energyType!) {
      case EnergyType.electricidad:
        return 'Electricidad';
      case EnergyType.gas_natural:
        return 'Gas Natural';
      case EnergyType.gasolina:
        return 'Gasolina';
    }
  }

  String get nombreAlimento {
    if (foodType == null) return 'Alimento';
    switch (foodType!) {
      case FoodType.carne_res:
        return 'Carne de Res';
      case FoodType.carne_pollo:
        return 'Carne de Pollo';
      case FoodType.pescado:
        return 'Pescado';
      case FoodType.huevos:
        return 'Huevos';
      case FoodType.leche:
        return 'Leche';
      case FoodType.arroz:
        return 'Arroz';
      case FoodType.vegetales:
        return 'Vegetales';
      case FoodType.frutas:
        return 'Frutas';
      case FoodType.legumbres:
        return 'Legumbres';
    }
  }

  String get nombreProducto {
    if (productType == null) return 'Producto';
    switch (productType!) {
      case ProductType.electronicos:
        return 'Electrónicos';
      case ProductType.ropa:
        return 'Ropa';
      case ProductType.plastico:
        return 'Plástico';
      case ProductType.papel:
        return 'Papel';
      case ProductType.vidrio:
        return 'Vidrio';
      case ProductType.metal:
        return 'Metal';
    }
  }

  // Obtener la unidad de medida según el tipo
  String get unidadMedida {
    switch (type) {
      case ActivityType.transporte:
        return 'km';
      case ActivityType.energia:
        switch (energyType) {
          case EnergyType.electricidad:
            return 'kWh';
          case EnergyType.gas_natural:
            return 'm³';
          case EnergyType.gasolina:
            return 'litros';
          default:
            return 'kWh';
        }
      case ActivityType.alimento:
      case ActivityType.producto:
        return 'kg';
    }
  }
}

