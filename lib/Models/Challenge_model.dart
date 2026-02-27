class Challenge {
  int? id;
  int userId;
  String titulo;
  String descripcion;
  String icono;
  String tipo; // 'semanal', 'energia', 'transporte', 'alimentacion'
  int objetivo;
  int progresoActual;
  DateTime fechaInicio;
  DateTime fechaFin;
  bool completado;
  int puntosRecompensa;

  Challenge({
    this.id,
    required this.userId,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.tipo,
    required this.objetivo,
    this.progresoActual = 0,
    required this.fechaInicio,
    required this.fechaFin,
    this.completado = false,
    required this.puntosRecompensa,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'userId': userId,
      'titulo': titulo,
      'descripcion': descripcion,
      'icono': icono,
      'tipo': tipo,
      'objetivo': objetivo,
      'progresoActual': progresoActual,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'completado': completado ? 1 : 0,
      'puntosRecompensa': puntosRecompensa,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      id: map['id'],
      userId: map['userId'],
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      icono: map['icono'],
      tipo: map['tipo'],
      objetivo: map['objetivo'],
      progresoActual: map['progresoActual'] ?? 0,
      fechaInicio: DateTime.parse(map['fechaInicio']),
      fechaFin: DateTime.parse(map['fechaFin']),
      completado: map['completado'] == 1,
      puntosRecompensa: map['puntosRecompensa'],
    );
  }

  double get porcentajeProgreso {
    if (objetivo == 0) return 0;
    return (progresoActual / objetivo * 100).clamp(0, 100);
  }

  int get diasRestantes {
    final ahora = DateTime.now();
    return fechaFin.difference(ahora).inDays;
  }

  // Retos predefinidos
  static List<Challenge> getDefaultChallenges(int userId) {
    final ahora = DateTime.now();
    return [
      Challenge(
        userId: userId,
        titulo: 'Sin Coche 3 Días',
        descripcion: 'No uses el coche durante 3 días consecutivos',
        icono: '🚗',
        tipo: 'transporte',
        objetivo: 3,
        fechaInicio: ahora,
        fechaFin: ahora.add(const Duration(days: 7)),
        puntosRecompensa: 100,
      ),
      Challenge(
        userId: userId,
        titulo: 'Ahorra Energía',
        descripcion: 'Reduce tu consumo de energía un 20%',
        icono: '⚡',
        tipo: 'energia',
        objetivo: 20,
        fechaInicio: ahora,
        fechaFin: ahora.add(const Duration(days: 7)),
        puntosRecompensa: 150,
      ),
      Challenge(
        userId: userId,
        titulo: 'Semana Vegetariana',
        descripcion: 'Come solo opciones vegetarianas toda la semana',
        icono: '🥗',
        tipo: 'alimentacion',
        objetivo: 7,
        fechaInicio: ahora,
        fechaFin: ahora.add(const Duration(days: 7)),
        puntosRecompensa: 200,
      ),
      Challenge(
        userId: userId,
        titulo: 'Transporte Verde',
        descripcion: 'Usa transporte sostenible 5 veces',
        icono: '🚲',
        tipo: 'transporte',
        objetivo: 5,
        fechaInicio: ahora,
        fechaFin: ahora.add(const Duration(days: 7)),
        puntosRecompensa: 120,
      ),
    ];
  }
}
