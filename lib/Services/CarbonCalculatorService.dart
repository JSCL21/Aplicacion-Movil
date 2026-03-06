import '../Models/Activity_model.dart';

class CarbonCalculatorService {
  // Emisiones de CO2 por tipo de transporte (kg CO2 por km)
  static const Map<TransportType, double> emisionesTransporte = {
    TransportType.coche: 0.21,      // 210g CO2/km (vehículo promedio)
    TransportType.avion: 0.255,     // 255g CO2/km (promedio)
    TransportType.autobus: 0.089,    // 89g CO2/km
    TransportType.tren: 0.041,      // 41g CO2/km
    TransportType.bicicleta: 0.0,   // 0 emisiones
    TransportType.caminar: 0.0,     // 0 emisiones
    TransportType.scooter: 0.05,   // 50g CO2/km (eléctrico)
  };

  // Emisiones de CO2 por tipo de energia (kg CO2 por unidad)
  static const Map<EnergyType, double> emisionesEnergia = {
    EnergyType.electricidad: 0.5,   // 0.5 kg CO2/kWh (mix promedio)
    EnergyType.gas_natural: 2.0,    // 2 kg CO2/m³
    EnergyType.gasolina: 2.3,      // 2.3 kg CO2/litro
  };

  // Emisiones de CO2 por tipo de alimento (kg CO2 por kg)
  static const Map<FoodType, double> emisionesAlimento = {
    FoodType.carne_res: 27.0,      // 27 kg CO2 por kg
    FoodType.carne_pollo: 6.9,     // 6.9 kg CO2 por kg
    FoodType.pescado: 5.0,         // 5 kg CO2 por kg
    FoodType.huevos: 4.8,          // 4.8 kg CO2 por kg
    FoodType.leche: 3.2,           // 3.2 kg CO2 por kg
    FoodType.arroz: 2.7,           // 2.7 kg CO2 por kg
    FoodType.vegetales: 0.4,       // 0.4 kg CO2 por kg
    FoodType.frutas: 0.5,          // 0.5 kg CO2 por kg
    FoodType.legumbres: 0.9,       // 0.9 kg CO2 por kg
  };

  // Emisiones de CO2 por tipo de producto (kg CO2 por kg)
  static const Map<ProductType, double> emisionesProducto = {
    ProductType.electronicos: 50.0,  // 50 kg CO2 por kg (alto impacto)
    ProductType.ropa: 10.0,          // 10 kg CO2 por kg
    ProductType.plastico: 6.0,       // 6 kg CO2 por kg
    ProductType.papel: 1.5,         // 1.5 kg CO2 por kg
    ProductType.vidrio: 1.0,         // 1 kg CO2 por kg
    ProductType.metal: 8.0,         // 8 kg CO2 por kg
  };

  /// Calcula las emisiones de CO2 para una actividad de transporte
  static double calcularEmisionesTransporte(TransportType tipo, double distanciaKm) {
    final factorEmision = emisionesTransporte[tipo] ?? 0.0;
    return distanciaKm * factorEmision;
  }

  /// Calcula las emisiones de CO2 para actividades de energía
  static double calcularEmisionesEnergia(EnergyType tipo, double cantidad) {
    final factorEmision = emisionesEnergia[tipo] ?? 0.0;
    return cantidad * factorEmision;
  }

  /// Calcula las emisiones de CO2 para alimentos
  static double calcularEmisionesAlimento(FoodType tipo, double cantidadKg) {
    final factorEmision = emisionesAlimento[tipo] ?? 0.0;
    return cantidadKg * factorEmision;
  }

  /// Calcula las emisiones de CO2 para productos
  static double calcularEmisionesProducto(ProductType tipo, double cantidadKg) {
    final factorEmision = emisionesProducto[tipo] ?? 0.0;
    return cantidadKg * factorEmision;
  }

  /// Calcula puntos ganados según las emisiones ahorradas
  static int calcularPuntos(double emisionesCO2, ActivityType tipo) {
    switch (tipo) {
      case ActivityType.transporte:
        // Más puntos por transporte sostenible
        return (emisionesCO2 * 10).round() + 5;
      case ActivityType.energia:
        return (emisionesCO2 * 8).round() + 3;
      case ActivityType.alimento:
        return (emisionesCO2 * 15).round() + 10;
      case ActivityType.producto:
        return (emisionesCO2 * 5).round() + 2;
    }
  }

  /// Obtiene el nivel del usuario basado en puntos acumulados
  static int getNivel(int puntos) {
    if (puntos < 100) return 1;
    if (puntos < 300) return 2;
    if (puntos < 600) return 3;
    if (puntos < 1000) return 4;
    if (puntos < 2000) return 5;
    return 6 + ((puntos - 2000) ~/ 2000);
  }

  /// Obtiene el nombre del nivel
  static String getNombreNivel(int nivel) {
    switch (nivel) {
      case 1:
        return 'Principiante Verde';
      case 2:
        return 'Explorador Eco';
      case 3:
        return 'Defensor Ambiental';
      case 4:
        return 'Guardián del Planeta';
      case 5:
        return 'Héroe Sostenible';
      case 6:
        return 'Maestro Eco';
      default:
        return 'Leyenda Verde';
    }
  }

  /// Calcula el porcentaje de reducción comparado con el día anterior
  static double calcularPorcentajeReduccion(double emisionesHoy, double emisionesAyer) {
    if (emisionesAyer == 0) return 0;
    return ((emisionesAyer - emisionesHoy) / emisionesAyer * 100);
  }

  /// Obtiene una recomendación basada en las emisiones
  static String getRecomendacion(double emisionesCO2) {
    if (emisionesCO2 < 5) {
      return '¡Excelente! Sigue así, estás haciendo un gran trabajo por el planeta 🌍';
    } else if (emisionesCO2 < 15) {
      return 'Bien hecho. Considera usar transporte público o bicicleta 🚲';
    } else if (emisionesCO2 < 30) {
      return 'Puedes mejorar. Intenta reducir el uso del coche esta semana 🚗';
    } else {
      return 'Alto consumo detected. Te desafiamos a reducir un 20% esta semana ⚡';
    }
  }
}

