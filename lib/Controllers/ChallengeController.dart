import '../Models/Challenge_model.dart';
import '../Models/Achievement_model.dart';
import '../Services/ChallengeService.dart';

class ChallengeController {
  final List<Challenge> _retos = [];
  final List<Achievement> _logros = [];

  List<Challenge> get retos => _retos;
  List<Achievement> get logros => _logros;

  /// Inicializa los retos semanales
  void inicializarRetos(int userId) {
    _retos.clear();
    _retos.addAll(Challenge.getDefaultChallenges(userId));
  }

  /// Inicializa los logros
  void inicializarLogros(int userId) {
    _logros.clear();
    _logros.addAll(Achievement.getDefaultAchievements(userId));
  }

  /// Obtiene los retos activos
  List<Challenge> getRetosActivos() {
    return ChallengeService.getActivos(_retos);
  }

  /// Obtiene los retos completados
  List<Challenge> getRetosCompletados() {
    return ChallengeService.getCompletados(_retos);
  }

  /// Actualiza el progreso de un reto
  void actualizarProgreso(String tipoActividad, double valor) {
    for (int i = 0; i < _retos.length; i++) {
      if (!_retos[i].completado) {
        _retos[i] = ChallengeService.actualizarProgreso(
          _retos[i],
          tipoActividad,
          valor,
        );
      }
    }
  }

  /// Obtiene el progreso total
  double getProgresoTotal() {
    return ChallengeService.getProgresoTotal(_retos);
  }

  /// Desbloquea un logro
  void desbloquearLogro(String tituloLogro) {
    for (int i = 0; i < _logros.length; i++) {
      if (_logros[i].titulo == tituloLogro && !_logros[i].unlocked) {
        _logros[i] = Achievement(
          id: _logros[i].id,
          userId: _logros[i].userId,
          titulo: _logros[i].titulo,
          descripcion: _logros[i].descripcion,
          icono: _logros[i].icono,
          fechaDesbloqueado: DateTime.now(),
          unlocked: true,
        );
        break;
      }
    }
  }

  /// Obtiene los logros desbloqueados
  List<Achievement> getLogrosDesbloqueados() {
    return _logros.where((l) => l.unlocked).toList();
  }

  /// Obtiene los logros pendientes
  List<Achievement> getLogrosPendientes() {
    return _logros.where((l) => !l.unlocked).toList();
  }

  /// Calcula los puntos totales de recompensas
  int getPuntosRecompensa() {
    return ChallengeService.getPuntosDisponibles(_retos);
  }

  /// Reinicia los retos semanalmente
  void reiniciarRetosSemanales(int userId) {
    _retos.clear();
    _retos.addAll(Challenge.getDefaultChallenges(userId));
  }
}
