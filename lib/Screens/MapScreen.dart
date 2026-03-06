import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  bool _isLoading = true;
  String? _errorMessage;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(19.4326, -99.1332), // Ciudad de México por defecto
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Verificar si los servicios de ubicación están habilitados
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Los servicios de ubicación están deshabilitados. Por favor, habilítalos.';
        });
        return;
      }

      // Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Permiso de ubicación denegado.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Permisos de ubicación denegados permanentemente. Por favor, habilítalos en configuración.';
        });
        return;
      }

      // Obtener posición actual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
        _errorMessage = null;
        
        // Agregar marcador en la ubicación actual
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(
              title: 'Tu ubicación',
              snippet: 'Aquí estás ahora',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        );
      });

      // Mover cámara a la ubicación actual
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          15,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al obtener ubicación: $e';
      });
    }
  }

  void _openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  void _addActivityMarker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar actividad'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.directions_bike, color: Color(0xFF2ECC71)),
              title: const Text('Ciclismo'),
              onTap: () {
                _addMarker('Ciclismo', '🚴', BitmapDescriptor.hueGreen);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_walk, color: Color(0xFF3498DB)),
              title: const Text('Caminata'),
              onTap: () {
                _addMarker('Caminata', '🚶', BitmapDescriptor.hueAzure);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.recycling, color: Color(0xFFF1C40F)),
              title: const Text('Reciclaje'),
              onTap: () {
                _addMarker('Reciclaje', '♻️', BitmapDescriptor.hueYellow);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.nature, color: Color(0xFF27AE60)),
              title: const Text('Reforestación'),
              onTap: () {
                _addMarker('Reforestación', '🌳', BitmapDescriptor.hueGreen);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addMarker(String title, String emoji, double hue) {
    // Usar la ubicación actual si está disponible, o usar una ubicación por defecto
    final lat = _currentPosition?.latitude ?? 19.4326;
    final lng = _currentPosition?.longitude ?? -99.1332;
    
    final markerId = MarkerId('activity_${_markers.length}');
    
    setState(() {
      _markers.add(
        Marker(
          markerId: markerId,
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: '$emoji $title',
            snippet: 'Actividad ecológica registrada',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$emoji $title registrada en el mapa'),
        backgroundColor: const Color(0xFF2ECC71),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Actividades'),
        backgroundColor: const Color(0xFF2ECC71),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
            tooltip: 'Mi ubicación',
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialPosition,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2ECC71)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Obteniendo ubicación...',
                      style: TextStyle(
                        color: Color(0xFF2C3E50),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_errorMessage != null && !_isLoading)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_off, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: _openAppSettings,
                          icon: const Icon(Icons.settings),
                          label: const Text('Configuración'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _getCurrentLocation,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2ECC71),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          // Leyenda
          Positioned(
            bottom: 100,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Leyenda',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  _LegendItem(color: Colors.green, label: 'Ciclismo'),
                  _LegendItem(color: Colors.blue, label: 'Caminata'),
                  _LegendItem(color: Colors.yellow, label: 'Reciclaje'),
                  _LegendItem(color: Colors.green, label: 'Reforestación'),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add_activity',
            onPressed: _addActivityMarker,
            backgroundColor: const Color(0xFF2ECC71),
            child: const Icon(Icons.add_location),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'center_location',
            onPressed: () {
              if (_currentPosition != null) {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    15,
                  ),
                );
              } else {
                _getCurrentLocation();
              }
            },
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF2ECC71),
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
