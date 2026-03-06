import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApiService {
  // API de Open-Meteo (gratuita, no requiere API key)
  static const String _baseUrl = 'https://api.open-meteo.com/v1';
  
  /// Obtiene el clima actual y recomendación ecológica
  static Future<WeatherData> getWeatherAndRecommendation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,weather_code&timezone=auto',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final current = data['current'];
        
        final temperature = current['temperature_2m'] as double;
        final weatherCode = current['weather_code'] as int;
        
        return WeatherData(
          temperature: temperature,
          weatherCode: weatherCode,
          weatherDescription: _getWeatherDescription(weatherCode),
          recommendation: _getEcoRecommendation(temperature, weatherCode),
          icon: _getWeatherIcon(weatherCode),
        );
      } else {
        throw Exception('Error al obtener el clima: ${response.statusCode}');
      }
    } catch (e) {
      // Retornar datos por defecto en caso de error
      return WeatherData(
        temperature: 22.0,
        weatherCode: 0,
        weatherDescription: 'Desconocido',
        recommendation: '¡Perfecto día para caminar o usar bicicleta!',
        icon: '☀️',
      );
    }
  }

  /// Obtiene descripción del clima basado en el código WMO
  static String _getWeatherDescription(int code) {
    final descriptions = {
      0: 'Despejado',
      1: 'Principalmente despejado',
      2: 'Parcialmente nublado',
      3: 'Nublado',
      45: 'Niebla',
      48: 'Niebla con escarcha',
      51: 'Llovizna ligera',
      53: 'Llovizna moderada',
      55: 'Llovizna intensa',
      61: 'Lluvia ligera',
      63: 'Lluvia moderada',
      65: 'Lluvia intensa',
      71: 'Nevada ligera',
      73: 'Nevada moderada',
      75: 'Nevada intensa',
      95: 'Tormenta eléctrica',
    };
    return descriptions[code] ?? 'Desconocido';
  }

  /// Obtiene recomendación ecológica basada en el clima
  static String _getEcoRecommendation(double temperature, int weatherCode) {
    // Lluvia o tormenta
    if (weatherCode >= 51 && weatherCode <= 65 || weatherCode >= 80 && weatherCode <= 82) {
      return '🌧️ Día lluvioso. Considera usar transporte público o compartir coche.';
    }
    
    // Nevado
    if (weatherCode >= 71 && weatherCode <= 77) {
      return '❄️ Día nevado. Usa transporte público para mayor seguridad.';
    }
    
    // Tormenta eléctrica
    if (weatherCode >= 95) {
      return '⛈️ Tormenta eléctrica. Evita salir si es posible.';
    }
    
    // Niebla
    if (weatherCode >= 45 && weatherCode <= 48) {
      return '🌫️ Día con niebla. Conduce con precaución o usa transporte público.';
    }
    
    // Temperatura muy alta
    if (temperature > 30) {
      return '☀️ Día muy caluroso. Mantente hidratado si caminas o usas bicicleta.';
    }
    
    // Temperatura muy baja
    if (temperature < 10) {
      return '🧥 Día frío. Vístete abrigado si sales a caminar o en bicicleta.';
    }
    
    // Día perfecto
    if (temperature >= 18 && temperature <= 25 && (weatherCode <= 3)) {
      return '🌱 ¡Día perfecto! Ideal para caminar, usar bicicleta o transporte público.';
    }
    
    // Default
    return '🌍 Considera opciones de transporte sostenible para hoy.';
  }

  /// Obtiene emoji del clima
  static String _getWeatherIcon(int code) {
    if (code == 0) return '☀️';
    if (code <= 3) return '⛅';
    if (code <= 48) return '🌫️';
    if (code <= 55) return '🌦️';
    if (code <= 65) return '🌧️';
    if (code <= 77) return '❄️';
    if (code <= 82) return '🌦️';
    if (code <= 85) return '🌨️';
    if (code >= 95) return '⛈️';
    return '🌡️';
  }
}

class WeatherData {
  final double temperature;
  final int weatherCode;
  final String weatherDescription;
  final String recommendation;
  final String icon;

  WeatherData({
    required this.temperature,
    required this.weatherCode,
    required this.weatherDescription,
    required this.recommendation,
    required this.icon,
  });
}
