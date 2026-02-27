# PROPUESTA DE APLICACIÓN MÓVIL INNOVADORA

---

## 1. NOMBRE DE LA APLICACIÓN

### **"EcoTrack"** 
*Tu asistente personal de sostenibilidad ambiental*

---

## 2. DESCRIPCIÓN GENERAL DE LA IDEA

**EcoTrack** es una aplicación móvil innovadora que permite a los usuarios rastrear, gestionar y reducir su huella de carbono personal y familiar mediante el monitoreo en tiempo real de sus actividades diarias, consumo de recursos y hábitos de transporte.

La aplicación gamifica el proceso de adopción de hábitos sostenibles, convirtiendo la protección del medio ambiente en una experiencia interactiva y gratificante. Los usuarios podrán establecer metas de sostenibilidad, earn puntos verdes, competir con amigos y contribuir a proyectos ambientales globales.

### Características principales:
- **Seguimiento de Huella de Carbono**: Monitoreo automático del consumo energético, transporte y alimentación
- **Retos Ambientales**: Desafíos diarios y semanales para adoptar hábitos sostenibles
- **Comunidad Verde**: Red social para compartir logros y motivación mutua
- **Impacto Visual**: Dashboard interactivo con gráficos y estadísticas en tiempo real
- **Logros y Recompensas**: Sistema de badges y recompensas virtuales

---

## 3. PROBLEMA QUE BUSCA RESOLVER

### Problema identificado:
La mayoría de las personas desean contribuir a la protección del medio ambiente, pero **no tienen forma concreta de medir su impacto ambiental** ni conocen qué acciones generan mayor diferencia.

### Dificultades actuales:
| Problema | Impacto |
|----------|---------|
| Falta de información sobre huella de carbono personal | Las personas no saben cuánto contaminan |
| Dificultad para adoptar hábitos sostenibles | Abandono rápido de buenas intenciones |
| Ausencia de motivación continua | Pérdida de interés en poco tiempo |
| Desconexión entre acciones y resultados | No se ve el impacto de los esfuerzos |
| Falta de comunidad con mismos objetivos | Aislamiento en el camino sostenible |

### Solución que ofrece EcoTrack:
EcoTrack resuelve estos problemas proporcionando **herramientas concretas de medición**, **gamificación motivacional**, **seguimiento de progreso** y una **comunidad de apoyo** que hace que la sustentabilidad sea accesible, medible y gratificante.

---

## 4. TECNOLOGÍAS A UTILIZAR

### Framework y Lenguaje:
- **Flutter 3.x** - Framework multiplataforma (iOS/Android)
- **Dart 3.x** - Lenguaje de programación

### Sensores del dispositivo:
- 📍 **GPS/Location** - Para tracking de rutas de transporte y calcular emisiones
- 📷 **Cámara** - Para escanear productos y leer códigos de barras
- 📱 **Acelerómetro** - Detección de actividad física y modos de transporte
- 🔋 **Batería** - Optimización de energía

### APIs y Servicios:
- 🌤️ **OpenWeatherMap API** - Datos climáticos para cálculos de impacto
- 🗺️ **Google Maps API** - Mapas y rutas de transporte
- 📊 **API de cálculo de carbono** - Carbon Interface API
- 🔐 **Firebase Auth** - Autenticación de usuarios
- ☁️ **Firebase Cloud Firestore** - Base de datos en tiempo real
- 📈 **Firebase Analytics** - Análisis de uso

### Paquetes/Dependencies de Flutter:
```
yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  # Base de datos
  sqflite: ^2.3.2
  firebase_core: ^2.24.2
  cloud_firestore: ^4.14.0
  
  # Autenticación
  firebase_auth: ^4.16.0
  
  # Sensores y ubicación
  geolocator: ^11.0.0
  google_maps_flutter: ^2.5.3
  camera: ^0.10.5+9
  sensors_plus: ^4.0.2
  barcode_scan: ^3.0.1
  
  # UI y visualización
  fl_chart: ^0.66.2
  syncfusion_flutter_gauges: ^24.1.41
  
  # Utils
  shared_preferences: ^2.2.2
  intl: ^0.19.0
  http: ^1.2.0
```

### Arquitectura del proyecto:
- **Patrón BLoC** (Business Logic Component) para gestión de estado
- **Arquitectura limpia** (Clean Architecture) con capas:
  - Presentación (UI/Widgets)
  - Dominio (Use Cases/Entities)
  - Datos (Repositories/Data Sources)

---

## 5. MOCKUPS Y DISEÑOS PRELIMINARES

### 5.1 PANTALLA PRINCIPAL (Dashboard)

```
┌─────────────────────────────────┐
│  ☀️ Buenos días, Usuario!     │
│  📅 15 de Marzo, 2024          │
├─────────────────────────────────┤
│                                 │
│    ╭───────────────────────╮    │
│    │   HUELLA DE HOY      │    │
│    │                      │    │
│    │      12.5 kg        │    │
│    │      CO₂            │    │
│    │  ↗️ -15% vs ayer    │    │
│    ╰───────────────────────╯    │
│                                 │
│  ┌─────────┐  ┌─────────┐      │
│  │   🚗    │  │   💡    │      │
│  │ Trans-  │  │ Energia │      │
│  │ porte   │  │         │      │
│  │ 8.2 kg  │  │ 2.1 kg  │      │
│  └─────────┘  └─────────┘      │
│                                 │
│  ┌─────────┐  ┌─────────┐      │
│  │  🥗    │  │   🛒    │      │
│  │  Ali-   │  │ Productos│     │
│  │ mento   │  │         │      │
│  │ 1.5 kg  │  │ 0.7 kg  │      │
│  └─────────┘  └─────────┘      │
│                                 │
├─────────────────────────────────┤
│  🌱 Meta semanal: 65/100 kg    │
│  ████████░░░░░░░░░░░░░░░░░░  │
└─────────────────────────────────┘
         │                    │
    [🏠]  [🎯]  [📊]  [👤]
```

### 5.2 PANTALLA DE REGISTRO DE ACTIVIDAD

```
┌─────────────────────────────────┐
│  ← Añadir Actividad            │
├─────────────────────────────────┤
│                                 │
│  ¿Qué tipo de actividad?       │
│                                 │
│  ┌─────┐ ┌─────┐ ┌─────┐       │
│  │ 🚗  │ │ ✈️  │ │ 🚌  │       │
│  │Auto │ │Vuelo│ │Bus  │       │
│  └─────┘ └─────┘ └─────┘       │
│                                 │
│  ┌─────┐ ┌─────┐ ┌─────┐       │
│  │ 🚶  │ │ 🚲  │ │ 🎮  │       │
│  │Cami-│ │Bici │ │Elec-│       │
│  │ nar │ │     │ │trón.│       │
│  └─────┘ └─────┘ └─────┘       │
│                                 │
│  ─────────────────────────────  │
│                                 │
│  Distancia: 15.5 km             │
│  ════════════●═══════ 0-50km    │
│                                 │
│  Tipo de vehículo:              │
│  [ Sedán    ▼ ]                 │
│                                 │
│  Fecha: [ Hoy          📅 ]    │
│                                 │
│  ┌─────────────────────────┐    │
│  │    ✅ CALCULAR          │    │
│  │      IMPACTO            │    │
│  └─────────────────────────┘    │
│                                 │
└─────────────────────────────────┘
```

### 5.3 PANTALLA DE RETOS Y LOGROS

```
┌─────────────────────────────────┐
│  🌱 Retos Activos              │
├─────────────────────────────────┤
│                                 │
│  ╭───────────────────────────╮  │
│  │ 🚀 Reto Semanal            │  │
│  │ "Sin coche 3 días"        │  │
│  │                           │  │
│  │ Progreso: 2/3 días        │  │
│  │ ██████████░░░░ 66%        │  │
│  │ ⏰ 2 días restantes        │  │
│  ╰───────────────────────────╯  │
│                                 │
│  ╭───────────────────────────╮  │
│  │ ⚡ Reto de Energía        │  │
│  │ "Ahorra 20% energía"      │  │
│  │                           │  │
│  │ Progreso: 15%             │  │
│  │ ████████░░░░░░░░ 75%      │  │
│  │ ⏰ 5 días restantes        │  │
│  ╰───────────────────────────╯  │
│                                 │
│  Logros Desbloqueados:         │
│  🌿 Primer paso    🚶 Caminante │
│  ⚡ Energy Saver  🌱 Eco Hero   │
│                                 │
└─────────────────────────────────┘
```

### 5.4 PANTALLA DE MAPA DE RUTAS

```
┌─────────────────────────────────┐
│  🗺️ Mis Rutas                 │
├─────────────────────────────────┤
│                                 │
│  ┌───────────────────────────┐  │
│  │       [MAPA]             │  │
│  │                           │  │
│  │    📍 Inicio             │  │
│  │        ●─────────►       │  │
│  │                      📍  │  │
│  │                     Dest │  │
│  │                           │  │
│  │  ───🚗 Carro   ───🚌 Bus  │  │
│  │  ───🚲 Bicicleta          │  │
│  │                           │  │
│  └───────────────────────────┘  │
│                                 │
│  Resumen del viaje:            │
│  ┌───────────────────────────┐  │
│  │ Distancia: 8.2 km         │  │
│  │ Tiempo: 25 min            │  │
│  │ Emisiones: 1.8 kg CO₂     │  │
│  │                           │  │
│  │ ¿Mejor opción?            │  │
│  │ 🚲 Bicicleta: 0 kg CO₂    │  │
│  │ ⬆️ Ahorrarías: 1.8 kg     │  │
│  └───────────────────────────┘  │
│                                 │
└─────────────────────────────────┘
```

### 5.5 PANTALLA DE ESCÁNER DE PRODUCTOS

```
┌─────────────────────────────────┐
│  📷 Escanear Producto          │
├─────────────────────────────────┤
│                                 │
│  ┌───────────────────────────┐  │
│  │                           │  │
│  │      ┌─────────┐         │  │
│  │      │ █ █ █ █ │         │  │
│  │      │ █ █ █ █ │  📷     │  │
│  │      │ █ █ █ █ │         │  │
│  │      │ █ █ █ █ │         │  │
│  │      └─────────┘         │  │
│  │                           │  │
│  │   Apunta al código de    │  │
│  │   barras del producto    │  │
│  │                           │  │
│  └───────────────────────────┘  │
│                                 │
│  Última búsqueda:               │
│  ┌───────────────────────────┐  │
│  │ 🥤 Botella de plástico    │  │
│  │ Impacto: 🔴 Alto          │  │
│  │ CO₂: 0.82 kg             │  │
│  │                           │  │
│  │ Alternativa:              │  │
│  │ 💧 Botella reutilizable   │  │
│  │ Impacto: 🟢 Bajo          │  │
│  │ CO₂: 0.05 kg (-94%)      │  │
│  └───────────────────────────┘  │
│                                 │
└─────────────────────────────────┘
```

---

## 6. COLORES Y ESTILO VISUAL

### Paleta de colores:

| Color | Hex | Uso |
|-------|-----|-----|
| 🌿 Verde Esperanza | #2ECC71 | Primary color, botones principales |
| 🌊 Azul Océano | #3498DB | Acentos, información |
| ☀️ Amarillo Sol | #F1C40F | Logros, alertas positivas |
| 🔥 Rojo Alerta | #E74C3C | Warnings, alto impacto |
| ⚪ Blanco Puro | #FFFFFF | Fondos |
| 🌑 Gris Oscuro | #2C3E50 | Texto principal |

### Tipografía:
- **Títulos**: Roboto Bold
- **Cuerpo**: Roboto Regular
- **Números**: Roboto Mono

### Estilo UI:
- Diseño Material Design 3
- Bordes redondeados (16px radius)
- Sombras suaves
- Iconos Material Icons
- Animaciones fluidas

---

## 7. ESTRUCTURA DE DATOS (MODELO)

### Usuario:
```
User {
  id: String
  nombre: String
  email: String
  huellaCarbonoTotal: double
  puntosVerdes: int
  nivel: int
  fechaRegistro: DateTime
  logros: List<String>
}
```

### Actividad:
```
Actividad {
  id: String
  usuarioId: String
  tipo: Enum (transporte, energia, alimento, producto)
  fecha: DateTime
  distancia: double
  emisionesCO2: double
  puntosGanados: int
}
```

---

## 8. IMPACTO ESPERADO

### Beneficios ambientales:
- **Reducción de emisiones**: Los usuarios que usen la app consistentemente pueden reducir su huella de carbono entre 20-40%
- **Conciencia global**: Cada kilogramo de CO₂ ahorrado contribuye al objetivo global

### Beneficios para el usuario:
- 💰 Ahorro económico (menor consumo = menor gasto)
- ❤️ Mejora en hábitos de salud
- 🌟 Sentido de comunidad y propósito
- 🏆 Satisfacción por logros

---

## 9. CRONOGRAMA DE DESARROLLO

| Fase | Duración | Descripción |
|------|----------|-------------|
| Fase 1 | 2 semanas | Setup, autenticación, base de datos |
| Fase 2 | 3 semanas | Dashboard, tracking de actividades |
| Fase 3 | 2 semanas | Integración de mapas y ubicación |
| Fase 4 | 2 semanas | Cámara y escáner de productos |
| Fase 5 | 2 semanas | Sistema de retos y logros |
| Fase 6 | 1 semana | Testing y polish |
| **Total** | **12 semanas** | **Aplicación completa** |

---

## 10. CONCLUSIÓN

**EcoTrack** representa una oportunidad única de crear una aplicación que no solo resuelve un problema real, sino que también inspira a las personas a ser parte de la solución climática. Con el poder de Flutter, sensores del dispositivo y APIs de terceros, podemos crear una experiencia atractiva que haga de la sostenibilidad algo accesible, medible y, sobre todo, satisfactorio.

---

*Propuesta elaborada para Flutter Application 1*
*Desarrollado con ❤️ para un futuro más verde*
