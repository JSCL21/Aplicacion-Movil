class Achievement {
  int? id;
  int userId;
  String titulo;
  String descripcion;
  String icono;
  DateTime fechaDesbloqueado;
  bool unlocked;

  Achievement({
    this.id,
    required this.userId,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.fechaDesbloqueado,
    this.unlocked = false,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'userId': userId,
      'titulo': titulo,
      'descripcion': descripcion,
      'icono': icono,
      'fechaDesbloqueado': fechaDesbloqueado.toIso8601String(),
      'unlocked': unlocked ? 1 : 0,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'],
      userId: map['userId'],
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      icono: map['icono'],
      fechaDesbloqueado: DateTime.parse(map['fechaDesbloqueado']),
      unlocked: map['unlocked'] == 1,
    );
  }

  // Lista de logros predefinidos
  static List<Achievement> getDefaultAchievements(int userId) {
    return [
      Achievement(
        userId: userId,
        titulo: 'Primer Paso',
        descripcion: 'Registra tu primera actividad',
        icono: '🌿',
        fechaDesbloqueado: DateTime.now(),
      ),
      Achievement(
        userId: userId,
        titulo: 'Caminante',
        descripcion: 'Camina 10 km registrados',
        icono: '🚶',
        fechaDesbloqueado: DateTime.now(),
      ),
      Achievement(
        userId: userId,
        titulo: 'Ciclista',
        descripcion: 'Usa la bicicleta 5 veces',
        icono: '🚲',
        fechaDesbloqueado: DateTime.now(),
      ),
      Achievement(
        userId: userId,
        titulo: 'Energy Saver',
        descripcion: 'Ahorra 50 kWh de energía',
        icono: '⚡',
        fechaDesbloqueado: DateTime.now(),
      ),
      Achievement(
        userId: userId,
        titulo: 'Eco Héroe',
        descripcion: 'Reduce tu huella de carbono un 30%',
        icono: '🌱',
        fechaDesbloqueado: DateTime.now(),
      ),
      Achievement(
        userId: userId,
        titulo: 'Semana Verde',
        descripcion: 'Completa 7 días de actividades sostenibles',
        icono: '🌳',
        fechaDesbloqueado: DateTime.now(),
      ),
    ];
  }
}
