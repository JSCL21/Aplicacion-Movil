import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Verifica y solicita permisos de ubicación
  static Future<bool> verificarPermisos() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Obtiene la ubicación actual
  static Future<Position?> getPosicionActual() async {
    try {
      final tienePermisos = await verificarPermisos();
      if (!tienePermisos) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  /// Calcula la distancia entre dos puntos en kilómetros
  static double calcularDistancia(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  /// Obtiene la última posición conocida
  static Future<Position?> getUltimaPosicion() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      return null;
    }
  }

  /// Calcula las emisiones de CO2 para una ruta basada en el modo de transporte
  static double calcularEmisionesRuta(
    double distanciaKm,
    String modoTransporte,
  ) {
    // Emisiones en kg CO2 por km
    final emisionesPorKm = {
      'coche': 0.21,
      'autobus': 0.089,
      'tren': 0.041,
      'bicicleta': 0.0,
      'caminar': 0.0,
    };

    final factor = emisionesPorKm[modoTransporte] ?? 0.21;
    return distanciaKm * factor;
  }

  /// Compara emisiones entre diferentes modos de transporte
  static Map<String, double> compararEmisionesRuta(double distanciaKm) {
    return {
      'coche': calcularEmisionesRuta(distanciaKm, 'coche'),
      'autobus': calcularEmisionesRuta(distanciaKm, 'autobus'),
      'tren': calcularEmisionesRuta(distanciaKm, 'tren'),
      'bicicleta': calcularEmisionesRuta(distanciaKm, 'bicicleta'),
    };
  }

  /// Obtiene la mejor opción de transporte sostenible
  static String getMejorOpcion(double distanciaKm) {
    if (distanciaKm < 2) {
      return 'caminar';
    } else if (distanciaKm < 10) {
      return 'bicicleta';
    } else {
      return 'transporte_publico';
    }
  }
}
