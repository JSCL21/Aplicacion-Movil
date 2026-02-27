import 'package:flutter/material.dart';
import '../Controllers/ActivityController.dart';
import '../Services/CarbonCalculatorService.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ActivityController _activityController = ActivityController();
  
  int _puntosTotales = 0;
  int _nivel = 1;
  String _nombreNivel = '';
  double _emisionesTotales = 0;
  int _actividadesTotales = 0;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() {
    setState(() {
      _puntosTotales = _activityController.getPuntosTotales(widget.userId);
      _nivel = CarbonCalculatorService.getNivel(_puntosTotales);
      _nombreNivel = CarbonCalculatorService.getNombreNivel(_nivel);
      _emisionesTotales = _activityController.getEmisionesSemana(widget.userId);
      _actividadesTotales = _activityController.getActividadesUsuario(widget.userId).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildStatsGrid(),
              const SizedBox(height: 24),
              _buildLevelProgress(),
              const SizedBox(height: 24),
              _buildSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
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
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🌿', style: TextStyle(fontSize: 50)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Usuario EcoTrack',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.eco, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  _nombreNivel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('⭐', 'Puntos', '$_puntosTotales', const Color(0xFFF1C40F)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('📊', 'Actividades', '$_actividadesTotales', const Color(0xFF3498DB)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('🌍', 'CO₂ Total', '${_emisionesTotales.toStringAsFixed(1)} kg', const Color(0xFFE74C3C)),
        ),
      ],
    );
  }

  Widget _buildStatCard(String icono, String titulo, String valor, Color color) {
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
          Text(icono, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(valor, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
          const SizedBox(height: 4),
          Text(titulo, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLevelProgress() {
    int puntosSiguienteNivel;
    switch (_nivel) {
      case 1: puntosSiguienteNivel = 100; break;
      case 2: puntosSiguienteNivel = 300; break;
      case 3: puntosSiguienteNivel = 600; break;
      case 4: puntosSiguienteNivel = 1000; break;
      case 5: puntosSiguienteNivel = 2000; break;
      default: puntosSiguienteNivel = _puntosTotales + 2000;
    }
    double progreso = (_puntosTotales / puntosSiguienteNivel).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
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
              Text('Nivel $_nivel', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Nivel ${_nivel + 1}', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 12,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF2ECC71)),
            ),
          ),
          const SizedBox(height: 12),
          Text('$_puntosTotales / $puntosSiguienteNivel puntos para el siguiente nivel',
              style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
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
          _buildSettingItem(Icons.notifications_outlined, 'Notificaciones', true),
          _buildSettingItem(Icons.lock_outline, 'Privacidad', true),
          _buildSettingItem(Icons.help_outline, 'Ayuda', false),
          _buildSettingItem(Icons.info_outline, 'Acerca de', false),
          _buildSettingItem(Icons.logout, 'Cerrar Sesión', false, isLast: true),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icono, String titulo, bool tieneSwitch, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icono, color: Colors.grey[600]),
              const SizedBox(width: 16),
              Expanded(child: Text(titulo, style: const TextStyle(fontSize: 16))),
              if (tieneSwitch)
                Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: const Color(0xFF2ECC71),
                )
              else
                Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, indent: 56, color: Colors.grey[200]),
      ],
    );
  }
}
