import 'dart:io';
import 'package:flutter/material.dart';
import '../Models/Activity_model.dart';
import '../Controllers/ActivityController.dart';
import 'CameraScreen.dart';


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
  EnergyType? _energiaSeleccionada;
  FoodType? _alimentoSeleccionado;
  ProductType? _productoSeleccionado;
  double _cantidad = 0;
  final TextEditingController _cantidadController = TextEditingController();
  File? _capturedImage;


  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }

  String get _unidadMedida {
    switch (_tipoSeleccionado) {
      case ActivityType.transporte:
        return 'km';
      case ActivityType.energia:
        switch (_energiaSeleccionada) {
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

  String get _labelCantidad {
    switch (_tipoSeleccionado) {
      case ActivityType.transporte:
        return 'Distancia';
      case ActivityType.energia:
        return 'Cantidad';
      case ActivityType.alimento:
        return 'Peso';
      case ActivityType.producto:
        return 'Peso';
    }
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
            
            // Selector específico según el tipo de actividad
            _buildSpecificSelector(),
            const SizedBox(height: 24),
            
            // Slider de cantidad
            _buildCantidadSlider(),
            const SizedBox(height: 24),
            
            // Captura de foto
            _buildPhotoCapture(),
            const SizedBox(height: 24),
            
            // Botón guardar
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
          _cantidad = 0;
          _cantidadController.clear();
          // Resetear selecciones específicas
          if (tipo != ActivityType.transporte) {
            _transporteSeleccionado = null;
          }
          if (tipo != ActivityType.energia) {
            _energiaSeleccionada = null;
          }
          if (tipo != ActivityType.alimento) {
            _alimentoSeleccionado = null;
          }
          if (tipo != ActivityType.producto) {
            _productoSeleccionado = null;
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

  Widget _buildSpecificSelector() {
    switch (_tipoSeleccionado) {
      case ActivityType.transporte:
        return _buildTransportTypes();
      case ActivityType.energia:
        return _buildEnergyTypes();
      case ActivityType.alimento:
        return _buildFoodTypes();
      case ActivityType.producto:
        return _buildProductTypes();
    }
  }

  Widget _buildTransportTypes() {
    final transports = [
      {'tipo': TransportType.coche, 'icono': '🚗', 'nombre': 'Coche'},
      {'tipo': TransportType.autobus, 'icono': '🚌', 'nombre': 'Bus'},
      {'tipo': TransportType.tren, 'icono': '🚆', 'nombre': 'Tren'},
      {'tipo': TransportType.bicicleta, 'icono': '🚲', 'nombre': 'Bici'},
      {'tipo': TransportType.caminar, 'icono': '🚶', 'nombre': 'Caminar'},
      {'tipo': TransportType.avion, 'icono': '✈️', 'nombre': 'Avión'},
      {'tipo': TransportType.scooter, 'icono': '🛴', 'nombre': 'Scooter'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medio de transporte',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
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
        ),
      ],
    );
  }

  Widget _buildEnergyTypes() {
    final energies = [
      {'tipo': EnergyType.electricidad, 'icono': '⚡', 'nombre': 'Electricidad', 'unidad': 'kWh'},
      {'tipo': EnergyType.gas_natural, 'icono': '🔥', 'nombre': 'Gas Natural', 'unidad': 'm³'},
      {'tipo': EnergyType.gasolina, 'icono': '⛽', 'nombre': 'Gasolina', 'unidad': 'Litros'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de energía',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: energies.map((e) {
            final isSelected = _energiaSeleccionada == e['tipo'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _energiaSeleccionada = e['tipo'] as EnergyType;
                });
              },
              child: Container(
                width: 100,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF1C40F) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected 
                      ? Border.all(color: const Color(0xFFF1C40F), width: 2)
                      : null,
                ),
                child: Column(
                  children: [
                    Text(e['icono'] as String, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(
                      e['nombre'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFoodTypes() {
    final foods = [
      {'tipo': FoodType.carne_res, 'icono': '🥩', 'nombre': 'Carne Res'},
      {'tipo': FoodType.carne_pollo, 'icono': '🍗', 'nombre': 'Pollo'},
      {'tipo': FoodType.pescado, 'icono': '🐟', 'nombre': 'Pescado'},
      {'tipo': FoodType.huevos, 'icono': '🥚', 'nombre': 'Huevos'},
      {'tipo': FoodType.leche, 'icono': '🥛', 'nombre': 'Leche'},
      {'tipo': FoodType.arroz, 'icono': '🍚', 'nombre': 'Arroz'},
      {'tipo': FoodType.vegetales, 'icono': '🥬', 'nombre': 'Vegetales'},
      {'tipo': FoodType.frutas, 'icono': '🍎', 'nombre': 'Frutas'},
      {'tipo': FoodType.legumbres, 'icono': '🫘', 'nombre': 'Legumbres'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de alimento',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: foods.map((f) {
            final isSelected = _alimentoSeleccionado == f['tipo'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _alimentoSeleccionado = f['tipo'] as FoodType;
                });
              },
              child: Container(
                width: 70,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE67E22) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected 
                      ? Border.all(color: const Color(0xFFE67E22), width: 2)
                      : null,
                ),
                child: Column(
                  children: [
                    Text(f['icono'] as String, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(
                      f['nombre'] as String,
                      style: TextStyle(
                        fontSize: 9,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProductTypes() {
    final products = [
      {'tipo': ProductType.electronicos, 'icono': '📱', 'nombre': 'Electrónicos'},
      {'tipo': ProductType.ropa, 'icono': '👕', 'nombre': 'Ropa'},
      {'tipo': ProductType.plastico, 'icono': '🧴', 'nombre': 'Plástico'},
      {'tipo': ProductType.papel, 'icono': '📄', 'nombre': 'Papel'},
      {'tipo': ProductType.vidrio, 'icono': '🫙', 'nombre': 'Vidrio'},
      {'tipo': ProductType.metal, 'icono': '🔧', 'nombre': 'Metal'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de producto',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: products.map((p) {
            final isSelected = _productoSeleccionado == p['tipo'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _productoSeleccionado = p['tipo'] as ProductType;
                });
              },
              child: Container(
                width: 70,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF9B59B6) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected 
                      ? Border.all(color: const Color(0xFF9B59B6), width: 2)
                      : null,
                ),
                child: Column(
                  children: [
                    Text(p['icono'] as String, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(
                      p['nombre'] as String,
                      style: TextStyle(
                        fontSize: 9,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCantidadSlider() {
    double maxValue;
    String unidad;
    
    switch (_tipoSeleccionado) {
      case ActivityType.transporte:
        maxValue = 100;
        unidad = 'km';
        break;
      case ActivityType.energia:
        maxValue = 50;
        switch (_energiaSeleccionada) {
          case EnergyType.electricidad:
            unidad = 'kWh';
            break;
          case EnergyType.gas_natural:
            unidad = 'm³';
            break;
          case EnergyType.gasolina:
            unidad = 'litros';
            break;
          default:
            unidad = 'kWh';
        }
        break;
      case ActivityType.alimento:
        maxValue = 10;
        unidad = 'kg';
        break;
      case ActivityType.producto:
        maxValue = 20;
        unidad = 'kg';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _labelCantidad,
              style: const TextStyle(
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
                '${_cantidad.toStringAsFixed(1)} $unidad',
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
            value: _cantidad,
            min: 0,
            max: maxValue,
            divisions: (maxValue * 10).toInt(),
            onChanged: (value) {
              setState(() {
                _cantidad = value;
                _cantidadController.text = value.toStringAsFixed(1);
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0 $unidad', style: TextStyle(color: Colors.grey[500])),
            Text('$maxValue $unidad', style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      ],
    );
  }

  Widget _buildCalculateButton() {
    bool isValid = _validarActividad();
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isValid ? _guardarActividad : null,
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

  bool _validarActividad() {
    if (_cantidad <= 0) return false;
    
    switch (_tipoSeleccionado) {
      case ActivityType.transporte:
        return _transporteSeleccionado != null;
      case ActivityType.energia:
        return _energiaSeleccionada != null;
      case ActivityType.alimento:
        return _alimentoSeleccionado != null;
      case ActivityType.producto:
        return _productoSeleccionado != null;
    }
  }

  Widget _buildPhotoCapture() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Evidencia fotográfica',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_capturedImage != null)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _capturedImage = null;
                  });
                },
                icon: const Icon(Icons.delete, size: 18),
                label: const Text('Eliminar'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: EdgeInsets.zero,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _openCamera,
          child: Container(
            width: double.infinity,
            height: _capturedImage != null ? 200 : 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _capturedImage != null 
                    ? const Color(0xFF2ECC71) 
                    : Colors.grey[300]!,
                width: _capturedImage != null ? 2 : 1,
              ),
            ),
            child: _capturedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      _capturedImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toca para capturar evidencia',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Foto de tu actividad ecológica',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _openCamera() async {
    final result = await Navigator.push<File?>(
      context,
      MaterialPageRoute(
        builder: (context) => const CameraScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        _capturedImage = result;
      });
    }
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
                  '${actividad.cantidad.toStringAsFixed(1)} ${actividad.unidadMedida}',
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
      energyType: _energiaSeleccionada,
      foodType: _alimentoSeleccionado,
      productType: _productoSeleccionado,
      fecha: DateTime.now(),
      cantidad: _cantidad,
      emisionesCO2: 0, // Se calculará en el controller
    );

    await _activityController.agregarActividad(actividad);

    if (mounted) {
      String message = '✅ Actividad registrada correctamente!';
      if (_capturedImage != null) {
        message += ' (Con foto)';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
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
        _cantidad = 0;
        _cantidadController.clear();
        _capturedImage = null;
      });
    }
  }

}

