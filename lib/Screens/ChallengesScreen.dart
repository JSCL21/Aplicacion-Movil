import 'package:flutter/material.dart';
import '../Models/Challenge_model.dart';
import '../Models/Achievement_model.dart';
import '../Controllers/ChallengeController.dart';

class ChallengesScreen extends StatefulWidget {
  final int userId;
  
  const ChallengesScreen({super.key, required this.userId});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  late ChallengeController _challengeController;

  @override
  void initState() {
    super.initState();
    _challengeController = ChallengeController();
    _challengeController.inicializarRetos(widget.userId);
    _challengeController.inicializarLogros(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
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
              
              // Retos activos
              _buildActiveChallenges(),
              const SizedBox(height: 24),
              
              // Logros
              _buildAchievements(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final progresoTotal = _challengeController.getProgresoTotal();
    final puntosRecompensa = _challengeController.getPuntosRecompensa();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🌱 Retos Activos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2ECC71).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trending_up, color: Color(0xFF2ECC71), size: 18),
                  const SizedBox(width: 4),
                  Text(
                    'Progreso: ${progresoTotal.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Color(0xFF2ECC71),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1C40F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFF1C40F), size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '$puntosRecompensa pts',
                    style: const TextStyle(
                      color: Color(0xFFF1C40F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveChallenges() {
    final retosActivos = _challengeController.getRetosActivos();
    
    if (retosActivos.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            children: [
              Text('🎯', style: TextStyle(fontSize: 40)),
              SizedBox(height: 8),
              Text(
                'No hay retos activos',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: retosActivos.map((reto) => _buildChallengeCard(reto)).toList(),
    );
  }

  Widget _buildChallengeCard(Challenge reto) {
    Color colorTipo;
    switch (reto.tipo) {
      case 'transporte':
        colorTipo = const Color(0xFF3498DB);
        break;
      case 'energia':
        colorTipo = const Color(0xFFF1C40F);
        break;
      case 'alimentacion':
        colorTipo = const Color(0xFF2ECC71);
        break;
      default:
        colorTipo = const Color(0xFF9B59B6);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
            children: [
              Text(reto.icono, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reto.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      reto.descripcion,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorTipo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${reto.puntosRecompensa} pts',
                  style: TextStyle(
                    color: colorTipo,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Barra de progreso
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progreso: ${reto.progresoActual}/${reto.objetivo}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${reto.porcentajeProgreso.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: colorTipo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: reto.porcentajeProgreso / 100,
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(colorTipo),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Días restantes
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                reto.diasRestantes > 0 
                    ? '${reto.diasRestantes} días restantes' 
                    : '¡Último día!',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    final logrosDesbloqueados = _challengeController.getLogrosDesbloqueados();
    final logrosPendientes = _challengeController.getLogrosPendientes();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🏆 Logros Desbloqueados',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        if (logrosDesbloqueados.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                '¡Completa actividades para desbloquear logros!',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: logrosDesbloqueados
                .map((logro) => _buildAchievementChip(logro))
                .toList(),
          ),
        
        const SizedBox(height: 24),
        
        const Text(
          '🎯 Logros Pendientes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: logrosPendientes
              .map((logro) => _buildAchievementChipLocked(logro))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildAchievementChip(Achievement logro) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1C40F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF1C40F).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(logro.icono, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                logro.titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                logro.descripcion,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementChipLocked(Achievement logro) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🔒',
            style: TextStyle(fontSize: 20, color: Colors.grey[400]),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                logro.titulo,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              Text(
                logro.descripcion,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
