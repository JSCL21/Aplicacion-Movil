import 'package:flutter/material.dart';
import '../Models/Activity_model.dart';
import '../Controllers/ActivityController.dart';

class ActivityScreen extends StatefulWidget {
  final int userId;
  
  const ActivityScreen({super.key, required this.userId});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final ActivityController _activityController = ActivityController();
  ActivityType _tipoSeleccionado = ActivityType.transporte;
  TransportType? _transporteSeleccionado;
  double _distancia = 0;
  final TextEditingController _distanciaController = TextEditingController();

  @override
  void dispose() {
    _distanciaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Añadir Actividad',
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Qué tipo de actividad?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Tipos de actividad principales
            _buildActivityTypes(),
            const SizedBox(height: 24),
            
            // Tipos de transporte (si se seleccionó transporte)
            if (_tipoSeleccionado == ActivityType.transporte) ...[
              const Text(
                'Medio de transporte',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTransportTypes(),
              const SizedBox(height: 24),
            ],
            
            // Slider de distancia
            _buildDistanceSlider(),
            const SizedBox(height: 24),
            
            // Botón calcular
            _buildCalculateButton(),
            const SizedBox(height: 24),
            
            // Historial de actividades recientes
            _buildRecentActivities(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTypes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActivityTypeCard(
          ActivityType.transporte,
          '🚗',
          'Transporte',
        ),
        _buildActivityTypeCard(
          ActivityType.energia,
          '💡',
          'Energía',
        ),
        _buildActivityTypeCard(
          ActivityType.alimento,
          '🥗',
          'Alimento',
        ),
        _buildActivityTypeCard(
          ActivityType.producto,
          '🛒',
          'Producto',
        ),
      ],
    );
  }

  Widget _buildActivityTypeCard(ActivityType tipo, String icono, String titulo) {
    final isSelected = _tipoSeleccionado == tipo;
    return GestureDetector(
      onTap: () {
        setState(() {
          _tipoSeleccionado = tipo;
          if (tipo != ActivityType.transporte) {
            _transporteSeleccionado = null;
          }
        });
      },
      child: Container(
        width: 75,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2ECC71) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: isSelected 
              ? Border.all(color: const Color(0xFF2ECC71), width: 2)
              : null,
        ),
        child: Column(
          children: [
            Text(icono, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              titulo,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportTypes() {
    final transports = [
      {'tipo': TransportType.coche, 'icono': '🚗', 'nombre': 'Coche'},
      {'tipo': TransportType.autobus, 'icono': '🚌', 'nombre': 'Bus'},
      {'tipo': TransportType.tren, 'icono': '🚆', 'nombre': 'Tren'},
      {'tipo': TransportType.bicicleta, 'icono': '🚲', 'nombre': 'Bici'},
      {'tipo': TransportType.caminar, 'icono': '🚶', 'nombre': 'Caminar'},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: transports.map((t) {
        final isSelected = _transporteSeleccionado == t['tipo'];
        return GestureDetector(
          onTap: () {
            setState(() {
              _transporteSeleccionado = t['tipo'] as TransportType;
            });
          },
          child: Container(
            width: 70,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF3498DB) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: isSelected 
                  ? Border.all(color: const Color(0xFF3498DB), width: 2)
                  : null,
            ),
            child: Column(
              children: [
                Text(t['icono'] as String, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 4),
                Text(
                  t['nombre'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDistanceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Distancia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2ECC71).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_distancia.toStringAsFixed(1)} km',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2ECC71),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF2ECC71),
            inactiveTrackColor: Colors.grey[300],
            thumbColor: const Color(0xFF2ECC71),
            overlayColor: const Color(0xFF2ECC71).withOpacity(0.2),
          ),
          child: Slider(
            value: _distancia,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: (value) {
              setState(() {
                _distancia = value;
                _distanciaController.text = value.toStringAsFixed(1);
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0 km', style: TextStyle(color: Colors.grey[500])),
            Text('100 km', style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      ],
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _distancia > 0 ? _guardarActividad : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2ECC71),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'GUARDAR ACTIVIDAD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    final actividades = _activityController.getActividadesUsuario(widget.userId);
    final recientes = actividades.reversed.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actividades recientes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (recientes.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Column(
                children: [
                  Text('📝', style: TextStyle(fontSize: 40)),
                  SizedBox(height: 8),
                  Text(
                    'No hay actividades registradas',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        else
          ...recientes.map((a) => _buildActivityItem(a)),
      ],
    );
  }

  Widget _buildActivityItem(Activity actividad) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(actividad.icono, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  actividad.tipoActividad,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${actividad.distancia.toStringAsFixed(1)} km',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${actividad.emisionesCO2.toStringAsFixed(2)} kg',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE74C3C),
                ),
              ),
              Text(
                '+${actividad.puntosGanados} pts',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF2ECC71),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _guardarActividad() async {
    final actividad = Activity(
      userId: widget.userId,
      type: _tipoSeleccionado,
      transportType: _transporteSeleccionado,
      fecha: DateTime.now(),
      distancia: _distancia,
      emisionesCO2: 0, // Se calculará en el controller
    );

    await _activityController.agregarActividad(actividad);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Text('✅ '),
              Text('Actividad registrada correctamente!'),
            ],
          ),
          backgroundColor: const Color(0xFF2ECC71),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      setState(() {
        _distancia = 0;
        _distanciaController.clear();
      });
    }
  }
}
