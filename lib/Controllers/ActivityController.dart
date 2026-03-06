import '../Models/Activity_model.dart';
import '../Services/CarbonCalculatorService.dart';

class ActivityController {
  // Lista en memoria de actividades (en una app real vendría de la base de datos)
  final List<Activity> _actividades = [];

  List<Activity> get actividades => _actividades;

  /// Agrega una nueva actividad
  Future<void> agregarActividad(Activity actividad) async {
    // Calcular emisiones y puntos
    double emisiones = 0;
    int puntos = 0;

    if (actividad.type == ActivityType.transporte && actividad.transportType != null) {
      // Transporte - cantidad en km
      emisiones = CarbonCalculatorService.calcularEmisionesTransporte(
        actividad.transportType!,
        actividad.cantidad,
      );
    } else if (actividad.type == ActivityType.energia && actividad.energyType != null) {
      // Energía - cantidad según tipo
      emisiones = CarbonCalculatorService.calcularEmisionesEnergia(
        actividad.energyType!,
        actividad.cantidad,
      );
    } else if (actividad.type == ActivityType.alimento && actividad.foodType != null) {
      // Alimento - cantidad en kg
      emisiones = CarbonCalculatorService.calcularEmisionesAlimento(
        actividad.foodType!,
        actividad.cantidad,
      );
    } else if (actividad.type == ActivityType.producto && actividad.productType != null) {
      // Producto - cantidad en kg
      emisiones = CarbonCalculatorService.calcularEmisionesProducto(
        actividad.productType!,
        actividad.cantidad,
      );
    }

    puntos = CarbonCalculatorService.calcularPuntos(emisiones, actividad.type);

    final actividadFinal = Activity(
      id: _actividades.length + 1,
      userId: actividad.userId,
      type: actividad.type,
      transportType: actividad.transportType,
      energyType: actividad.energyType,
      foodType: actividad.foodType,
      productType: actividad.productType,
      fecha: actividad.fecha,
      cantidad: actividad.cantidad,
      emisionesCO2: emisiones,
      puntosGanados: puntos,
      descripcion: actividad.descripcion,
    );

    _actividades.add(actividadFinal);
  }

  /// Obtiene todas las actividades de un usuario
  List<Activity> getActividadesUsuario(int userId) {
    return _actividades.where((a) => a.userId == userId).toList();
  }

  /// Obtiene las actividades de hoy
  List<Activity> getActividadesHoy(int userId) {
    final ahora = DateTime.now();
    final inicioDia = DateTime(ahora.year, ahora.month, ahora.day);
    final finDia = inicioDia.add(const Duration(days: 1));

    return _actividades.where((a) {
      return a.userId == userId &&
          a.fecha.isAfter(inicioDia) &&
          a.fecha.isBefore(finDia);
    }).toList();
  }

  /// Obtiene las actividades de la semana actual
  List<Activity> getActividadesSemana(int userId) {
    final ahora = DateTime.now();
    final inicioSemana = ahora.subtract(Duration(days: ahora.weekday - 1));
    final inicio = DateTime(inicioSemana.year, inicioSemana.month, inicioSemana.day);

    return _actividades.where((a) {
      return a.userId == userId && a.fecha.isAfter(inicio);
    }).toList();
  }

  /// Calcula el total de emisiones de CO2 de hoy
  double getEmisionesHoy(int userId) {
    return getActividadesHoy(userId)
        .fold(0.0, (sum, a) => sum + a.emisionesCO2);
  }

  /// Calcula el total de emisiones de CO2 de la semana
  double getEmisionesSemana(int userId) {
    return getActividadesSemana(userId)
        .fold(0.0, (sum, a) => sum + a.emisionesCO2);
  }

  /// Calcula el total de puntos acumulados
  int getPuntosTotales(int userId) {
    return getActividadesUsuario(userId)
        .fold(0, (sum, a) => sum + a.puntosGanados);
  }

  /// Obtiene el desglose de emisiones por tipo
  Map<ActivityType, double> getDesgloseEmisiones(int userId) {
    final actividades = getActividadesUsuario(userId);
    final Map<ActivityType, double> desglose = {};

    for (var actividad in actividades) {
      desglose[actividad.type] = (desglose[actividad.type] ?? 0) + actividad.emisionesCO2;
    }

    return desglose;
  }

  /// Elimina una actividad
  Future<void> eliminarActividad(int id) async {
    _actividades.removeWhere((a) => a.id == id);
  }
}

