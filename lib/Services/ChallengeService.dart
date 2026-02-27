import '../Models/Challenge_model.dart';

class ChallengeService {
  /// Genera nuevos retos semanales aleatorios
  static List<Challenge> generarRetosSemanales(int userId) {
    final retosBase = Challenge.getDefaultChallenges(userId);
    
    // Filtrar solo los activos (que aún no han terminado)
    final ahora = DateTime.now();
    return retosBase.where((reto) => reto.fechaFin.isAfter(ahora)).toList();
  }

  /// Verifica y actualiza el progreso de un reto
  static Challenge actualizarProgreso(
    Challenge reto,
    String tipoActividad,
    double valor,
  ) {
    if (reto.completado) return reto;
    if (reto.tipo != tipoActividad) return reto;

    int nuevoProgreso = reto.progresoActual;
    
    switch (tipoActividad) {
      case 'transporte':
        nuevoProgreso = reto.progresoActual + 1;
        break;
      case 'energia':
        nuevoProgreso = (reto.progresoActual + valor).round();
        break;
      case 'alimentacion':
        nuevoProgreso = reto.progresoActual + 1;
        break;
    }

    bool completado = nuevoProgreso >= reto.objetivo;
    
    return Challenge(
      id: reto.id,
      userId: reto.userId,
      titulo: reto.titulo,
      descripcion: reto.descripcion,
      icono: reto.icono,
      tipo: reto.tipo,
      objetivo: reto.objetivo,
      progresoActual: nuevoProgreso.clamp(0, reto.objetivo),
      fechaInicio: reto.fechaInicio,
      fechaFin: reto.fechaFin,
      completado: completado,
      puntosRecompensa: reto.puntosRecompensa,
    );
  }

  /// Obtiene los puntos totales de recompensas disponibles
  static int getPuntosDisponibles(List<Challenge> retos) {
    return retos
        .where((r) => !r.completado)
        .fold(0, (sum, reto) => sum + reto.puntosRecompensa);
  }

  /// Obtiene el progreso total de todos los retos activos
  static double getProgresoTotal(List<Challenge> retos) {
    if (retos.isEmpty) return 0;
    
    final total = retos.fold(0.0, (sum, reto) => sum + reto.porcentajeProgreso);
    return total / retos.length;
  }

  /// Obtiene una lista de retos filtrados por tipo
  static List<Challenge> filtrarPorTipo(List<Challenge> retos, String tipo) {
    return retos.where((r) => r.tipo == tipo).toList();
  }

  /// Obtiene los retos completados
  static List<Challenge> getCompletados(List<Challenge> retos) {
    return retos.where((r) => r.completado).toList();
  }

  /// Obtiene los retos activos (no completados y dentro de fecha)
  static List<Challenge> getActivos(List<Challenge> retos) {
    final ahora = DateTime.now();
    return retos
        .where((r) => !r.completado && r.fechaFin.isAfter(ahora))
        .toList();
  }
}
