# 🌱 EcoTrack - Instrucciones de Ejecución

## 📱 Descripción de la Aplicación

EcoTrack es una aplicación móvil de sostenibilidad ambiental que permite:
- Registrar actividades ecológicas (transporte, energía, alimentación)
- Calcular huella de carbono
- Ver estadísticas y progreso
- Participar en retos semanales
- Desbloquear logros
- Usar cámara para evidencias
- Ver mapa de actividades

## 🚀 Pasos para Ejecutar

### 1. Instalar Dependencias

```bash
flutter pub get
```

### 2. Configurar Google Maps (Opcional para pruebas básicas)

Para usar el mapa, necesitas una API Key de Google Maps:

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita la API de **Maps SDK for Android**
4. Ve a **Credenciales** → **Crear credenciales** → **Clave de API**
5. Copia tu API Key

6. Edita el archivo `android/app/src/main/AndroidManifest.xml`:
   - Reemplaza `YOUR_API_KEY_HERE` con tu API Key real

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="TU_API_KEY_AQUI" />
```

> **Nota:** Si no configuras la API Key, el mapa mostrará una pantalla en blanco pero el resto de la app funcionará correctamente.

### 3. Ejecutar la Aplicación

```bash
# Para ejecutar en modo debug
flutter run

# O especifica el dispositivo
flutter run -d <device_id>
```

## ✅ Funcionalidades Implementadas

### 🎨 Pantallas Desarrolladas
- ✅ **SplashScreen** - Animación de inicio
- ✅ **LoginScreen** - Inicio de sesión con validación
- ✅ **RegisterScreen** - Registro de usuarios
- ✅ **HomeScreen** - Navegación principal con 4 pestañas
- ✅ **DashboardScreen** - Panel principal con clima y estadísticas
- ✅ **ActivityScreen** - Registro de actividades
- ✅ **ChallengesScreen** - Retos y logros
- ✅ **ProfileScreen** - Perfil y configuración
- ✅ **CameraScreen** - Captura de fotos
- ✅ **MapScreen** - Mapa con ubicación

### 🔄 Navegación
- ✅ Navegación entre Login → Home
- ✅ BottomNavigationBar con 4 pestañas
- ✅ Navegación a pantallas secundarias (Cámara, Mapa)

### 📝 Formularios Funcionales
- ✅ Login con email y contraseña
- ✅ Registro con nombre, email, contraseña, confirmación
- ✅ Validación de campos
- ✅ Checkbox de términos y condiciones

### 🎛️ Botones con Acciones
- ✅ Iniciar sesión
- ✅ Crear cuenta
- ✅ Guardar actividades
- ✅ Capturar fotos
- ✅ Ver mapa
- ✅ Navegación entre pantallas

### 📊 Listas, Tarjetas y Componentes Dinámicos
- ✅ Lista de actividades recientes
- ✅ Tarjetas de estadísticas
- ✅ Tarjetas de retos con progreso
- ✅ Grid de tipos de actividad
- ✅ Chips de logros
- ✅ Sliders interactivos

### 📷 Integraciones
- ✅ **Cámara**: Captura de fotos y selección de galería
- ✅ **Mapas**: Google Maps con ubicación actual y marcadores
- ✅ **APIs**: Open-Meteo para datos del clima (gratuita, no requiere key)

## 🔧 Solución de Problemas Comunes

### Error: "Google Maps no se muestra"
- Verifica que hayas configurado la API Key correctamente
- Asegúrate de que la API de Maps SDK for Android esté habilitada

### Error: "Permisos de cámara/ubicación"
- Asegúrate de aceptar los permisos cuando la app los solicite
- Los permisos ya están configurados en AndroidManifest.xml

### Error: "No se pueden cargar dependencias"
```bash
flutter clean
flutter pub get
```

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  sqflite: ^2.3.2
  fl_chart: ^0.66.2
  geolocator: ^11.0.0
  sensors_plus: ^4.0.2
  shared_preferences: ^2.2.2
  intl: ^0.19.0
  http: ^1.2.0
  google_fonts: ^6.1.0
  camera: ^0.10.5+9
  image_picker: ^1.0.7
  google_maps_flutter: ^2.6.0
```

## 🎯 Flujo de Uso

1. **Inicio**: La app muestra una animación de splash
2. **Login**: Ingresa con cualquier email y contraseña (mínimo 6 caracteres)
3. **Home**: Navega entre las 4 pestañas:
   - **Inicio**: Dashboard con clima y estadísticas
   - **Actividad**: Registra nuevas actividades ecológicas
   - **Retos**: Ve tus retos semanales y logros
   - **Perfil**: Tu información y configuración
4. **Registrar Actividad**: Selecciona tipo, transporte, distancia y opcionalmente toma una foto
5. **Ver Mapa**: Desde el dashboard, toca "Ver Mapa" para ver tu ubicación
6. **Ver Progreso**: En el perfil puedes ver tus puntos y nivel

## 🌟 Características Destacadas

- 🎨 **Diseño Moderno**: UI limpia con Material Design 3
- 📊 **Estadísticas**: Gráficos y métricas de huella de carbono
- 🏆 **Gamificación**: Sistema de puntos, niveles y logros
- 🌤️ **Clima Inteligente**: Recomendaciones basadas en el clima actual
- 📷 **Evidencias**: Captura fotos de tus actividades
- 🗺️ **Mapa**: Visualiza tus actividades en el mapa

---

¡Listo para usar! 🚀
