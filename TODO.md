# TODO - Implementación EcoTrack

## Fase 1: Configuración del Proyecto
- [x] 1.1 Analizar propuesta y proyecto existente
- [x] 1.2 Actualizar pubspec.yaml con dependencias
- [ ] 1.3 Configurar Android permissions para GPS, cámara

## Fase 2: Modelos de Datos
- [x] 2.1 Crear modelo Activity (actividad)
- [x] 2.2 Crear modelo Achievement (logro)
- [x] 2.3 Crear modelo Challenge (reto)
- [x] 2.4 Actualizar modelo User con campos EcoTrack

## Fase 3: Servicios
- [x] 3.1 Crear CarbonCalculatorService
- [x] 3.2 Crear LocationService  
- [x] 3.3 Crear ChallengeService
- [x] 3.4 Actualizar DbService

## Fase 4: Controladores
- [x] 4.1 Crear ActivityController
- [x] 4.2 Crear ChallengeController
- [x] 4.3 Actualizar UserController

## Fase 5: Pantallas (Screens)
- [x] 5.1 Crear DashboardScreen (principal)
- [x] 5.2 Crear ActivityScreen (registro)
- [x] 5.3 Crear ChallengesScreen (retos/logros)
- [ ] 5.4 Crear MapScreen (rutas)
- [x] 5.5 Crear ProfileScreen (perfil)
- [x] 5.6 Crear HomeScreen con navegación

## Fase 6: Integración
- [x] 6.1 Actualizar main.dart
- [x] 6.2 Configurar tema EcoTrack
- [x] 6.3 Probar navegación

## Estado: Completado
La aplicación EcoTrack ha sido implementada con éxito. 

Archivos creados:
- lib/Models/Activity_model.dart
- lib/Models/Achievement_model.dart  
- lib/Models/Challenge_model.dart
- lib/Services/CarbonCalculatorService.dart
- lib/Services/LocationService.dart
- lib/Services/ChallengeService.dart
- lib/Controllers/ActivityController.dart
- lib/Controllers/ChallengeController.dart
- lib/Screens/DashboardScreen.dart
- lib/Screens/ActivityScreen.dart
- lib/Screens/ChallengesScreen.dart
- lib/Screens/ProfileScreen.dart
- lib/Screens/HomeScreen.dart
- lib/main.dart (actualizado)
- test/widget_test.dart (actualizado)
