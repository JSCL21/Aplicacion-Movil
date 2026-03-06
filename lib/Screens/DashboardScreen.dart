import 'package:flutter/material.dart';
import '../Models/Activity_model.dart';
import '../Controllers/ActivityController.dart';
import '../Services/CarbonCalculatorService.dart';
import '../Services/WeatherApiService.dart';
import 'MapScreen.dart';


class DashboardScreen extends StatefulWidget {
  final int userId;
  
  const DashboardScreen({super.key, required this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ActivityController _activityController = ActivityController();
  
  double _emisionesHoy = 0;
  double _emisionesAyer = 0;
  Map<ActivityType, double> _desglose = {};
  int _puntosTotales = 0;
  int _nivel = 1;
  WeatherData? _weatherData;
  bool _loadingWeather = true;


  @override
  void initState() {
    super.initState();
    _cargarDatos();
    _cargarClima();
  }

  Future<void> _cargarClima() async {
    final weather = await WeatherApiService.getWeatherAndRecommendation(
      latitude: 19.4326, // Ciudad de México
      longitude: -99.1332,
    );
    if (mounted) {
      setState(() {
        _weatherData = weather;
        _loadingWeather = false;
      });
    }
  }


  void _cargarDatos() {
    setState(() {
      _emisionesHoy = _activityController.getEmisionesHoy(widget.userId);
      _emisionesAyer = _emisionesHoy * 1.2; // Simulación para el ejemplo
      _desglose = _activityController.getDesgloseEmisiones(widget.userId);
      _puntosTotales = _activityController.getPuntosTotales(widget.userId);
      _nivel = CarbonCalculatorService.getNivel(_puntosTotales);
    });
  }

  @override
  Widget build(BuildContext context) {
    final porcentajeReduccion = CarbonCalculatorService.calcularPorcentajeReduccion(
      _emisionesHoy, 
      _emisionesAyer,
    );
    final recomendacion = CarbonCalculatorService.getRecomendacion(_emisionesHoy);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 20),
              
              // Widget del clima
              _buildWeatherWidget(),
              const SizedBox(height: 20),
              
              // Botones de acción rápida
              _buildQuickActions(),
              const SizedBox(height: 20),
              
              // Tarjeta principal de huella de carbono

              _buildMainCard(porcentajeReduccion),
              const SizedBox(height: 20),
              
              // Desglose por categorías (ahora con 4 categorías)
              _buildCategoryCards(),
              const SizedBox(height: 20),
              
              // Meta semanal
              _buildWeeklyGoal(),
              const SizedBox(height: 20),
              
              // Recomendación del día
              _buildRecommendationCard(recomendacion),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '☀️ Buenos días!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getFechaActual(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2ECC71),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.white, size: 18),
              const SizedBox(width: 4),
              Text(
                'Nivel $_nivel',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainCard(double porcentajeReduccion) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2ECC71).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'HUELLA DE HOY',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _emisionesHoy.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  ' kg CO₂',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  porcentajeReduccion >= 0 ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${porcentajeReduccion.abs().toStringAsFixed(0)}% vs ayer',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Desglose por categoría',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        // Primera fila: Transporte y Energía
        Row(
          children: [
            Expanded(
              child: _buildCategoryCard(
                '🚗',
                'Transporte',
                _desglose[ActivityType.transporte] ?? 0,
                const Color(0xFF3498DB),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryCard(
                '⚡',
                'Energía',
                _desglose[ActivityType.energia] ?? 0,
                const Color(0xFFF1C40F),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Segunda fila: Alimentación y Producto
        Row(
          children: [
            Expanded(
              child: _buildCategoryCard(
                '🥗',
                'Alimentación',
                _desglose[ActivityType.alimento] ?? 0,
                const Color(0xFFE67E22),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryCard(
                '🛒',
                'Producto',
                _desglose[ActivityType.producto] ?? 0,
                const Color(0xFF9B59B6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String icono, String titulo, double valor, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(icono, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            titulo,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${valor.toStringAsFixed(1)} kg',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyGoal() {
    double metaSemanal = 65.0;
    double actual = _activityController.getEmisionesSemana(widget.userId);
    double progreso = (actual / metaSemanal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text('🌱', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text(
                    'Meta semanal',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Text(
                '${actual.toStringAsFixed(0)}/${metaSemanal.toInt()} kg',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2ECC71),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF2ECC71)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(String recomendacion) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3498DB).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3498DB).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              recomendacion,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFechaActual() {
    final now = DateTime.now();
    final meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${now.day} de ${meses[now.month - 1]}, ${now.year}';
  }

  Widget _buildWeatherWidget() {
    if (_loadingWeather) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2ECC71)),
              ),
            ),
            SizedBox(width: 12),
            Text('Cargando clima...'),
          ],
        ),
      );
    }

    if (_weatherData == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3498DB).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _weatherData!.icon,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_weatherData!.temperature.toStringAsFixed(0)}°C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _weatherData!.weatherDescription,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.eco,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _weatherData!.recommendation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.map,
            label: 'Ver Mapa',
            color: const Color(0xFF9B59B6),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.camera_alt,
            label: 'Cámara',
            color: const Color(0xFFE74C3C),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cámara disponible en pantalla de Actividad'),
                  backgroundColor: Color(0xFF2ECC71),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.share,
            label: 'Compartir',
            color: const Color(0xFF3498DB),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Comparte tu progreso eco!'),
                  backgroundColor: Color(0xFF2ECC71),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

