# Moress - Gestor de Contraseñas Seguro

Moress es una aplicación móvil desarrollada en Flutter para gestionar de forma segura las contraseñas de diferentes servicios y aplicaciones.

## Características

- 🔐 **Autenticación segura**: Contraseña maestra para acceder a la aplicación
- 👆 **Autenticación biométrica**: Soporte para huella dactilar y Face ID
- 🔍 **Búsqueda rápida**: Busca servicios por nombre de servicio y nombre de usuario
- 🔒 **Encriptación avanzada**: Todas las contraseñas se almacenan encriptadas con algoritmos seguros
- 📱 **Interfaz intuitiva**: Diseño moderno y fácil de usar con Material Design
- 📋 **Copiar al portapapeles**: Copia contraseñas con un toque
- 🗑️ **Gestión completa**: Añadir, eliminar, editar y gestionar servicios
- 🔄 **Generador de contraseñas**: Genera contraseñas seguras automáticamente
- ⏱️ **Auto-bloqueo por inactividad**: Cierre automático de la app por seguridad (60s) (Deshabilitado en web para mayor comodidad)
- 🛡️ **Protección de ciclo de vida**: Logout automático al minimizar o cambiar de app (Solo en móviles)
- 🔄 **Pull-to-refresh**: Actualiza la lista de servicios deslizando hacia abajo
- 🎨 **Diseño responsive**: Interfaz adaptada para diferentes tamaños de pantalla
- 🔧 **Detección de interacciones**: Sistema inteligente que reinicia timers con cualquier actividad
- 💾 **Backup y Restore local**: Crea y restaura respaldos de forma segura en tu dispositivo
- 🔐 **Backup encriptado**: Los respaldos están protegidos con tu contraseña maestra
- � **Autenticación biométrica**: Soporte para huella dactilar y Face ID
- �🔍 **Búsqueda rápida**: Busca servicios por nombre de servicio y nombre de usuario
- 🔒 **Encriptación avanzada**: Todas las contraseñas se almacenan encriptadas con algoritmos seguros
- 📱 **Interfaz intuitiva**: Diseño moderno y fácil de usar con Material Design
- 📋 **Copiar al portapapeles**: Copia contraseñas con un toque
- 🗑️ **Gestión completa**: Añadir, eliminar, editar y gestionar servicios
- 🔄 **Generador de contraseñas**: Genera contraseñas seguras automáticamente
- ⏱️ **Auto-bloqueo por inactividad**: Cierre automático de la app por seguridad
- 🔄 **Pull-to-refresh**: Actualiza la lista de servicios deslizando hacia abajo
- 🎨 **Diseño responsive**: Interfaz adaptada para diferentes tamaños de pantalla

## Instalación

1. Asegúrate de tener Flutter instalado en tu sistema
2. Clona este repositorio
3. Ejecuta `flutter pub get` para instalar las dependencias
4. Ejecuta `flutter run` para iniciar la aplicación

## Uso

### Primera configuración
1. Al iniciar por primera vez, crea tu contraseña maestra
2. Configura la autenticación biométrica si tu dispositivo la soporta
3. La contraseña maestra se puede cambiar desde la pantalla principal

### Autenticación
- **Contraseña maestra**: Introduce tu contraseña para acceder
- **Biometría**: Usa huella dactilar o Face ID para acceso rápido y seguro
- **Auto-bloqueo por inactividad**: La app se cierra automáticamente tras 60 segundos sin actividad (Excepto en versión web)
- **Protección total**: Logout automático al minimizar o cambiar de app (Solo en dispositivos móviles)
- **Detección inteligente**: Cualquier toque, scroll o interacción reinicia el temporizador de seguridad

### Gestión de servicios
1. **Añadir servicio**: Toca el botón "+" flotante
   - Introduce el nombre del servicio
   - Añade el nombre de usuario
   - Introduce la contraseña o usa el generador automático
   - Guarda el servicio
2. **Ver contraseñas**: Toca cualquier tarjeta de servicio
   - La contraseña se mostrará temporalmente
   - Usa el icono de copiar para copiarla al portapapeles
3. **Editar servicios**: Mantén presionado un servicio para editarlo
4. **Eliminar servicios**: Desliza o usa el menú de opciones

### Backup y Restore (Nuevo)
1. **Crear respaldo**:
   - Ve a Configuración → "Crear respaldo"
   - Introduce tu contraseña maestra para autorizar
   - El archivo se guarda automáticamente en Documentos/Moress_Backups/
   - Formato: `moress_backup_YYYY-MM-DD_HH-mm-ss.mrbak`
   - Archivo completamente encriptado con tu contraseña maestra

2. **Restaurar respaldo**:
   - Ve a Configuración → "Restaurar respaldo"
   - Selecciona el archivo `.mrbak` desde tu dispositivo
   - Introduce tu contraseña maestra para desencriptar
   - Los servicios se importan automáticamente
   - La lista se actualiza inmediatamente con los datos restaurados

3. **Seguridad del backup**:
   - ✅ **Encriptación completa**: AES con tu contraseña maestra
   - ✅ **Almacenamiento local**: Solo en tu dispositivo
   - ✅ **Sin conexión**: Funciona completamente offline
   - ✅ **Verificación**: Requiere contraseña para crear y restaurar
   - ✅ **Formato propietario**: Archivos `.mrbak` seguros

### Búsqueda y filtrado
- Usa el campo de búsqueda en la parte superior
- Busca por nombre de servicio o usuario
- Los resultados se filtran automáticamente mientras escribes

### Configuración
- **Cambiar contraseña maestra**: Desde el menú de configuración
- **Ver estadísticas**: Número de contraseñas guardadas
- **Cerrar sesión**: Vuelve a la pantalla de login

## Seguridad

- **Encriptación robusta**: Todas las contraseñas se encriptan con algoritmos seguros antes de almacenarse
- **Almacenamiento local**: Los datos se guardan exclusivamente en tu dispositivo
- **Sin conexión a internet**: Funciona completamente offline para máxima privacidad
- **Contraseña maestra**: Protege el acceso a toda la aplicación
- **Autenticación biométrica**: Huella dactilar y Face ID para acceso seguro y conveniente
- **Auto-bloqueo inteligente**: 
  - Advertencia a los 55 segundos de inactividad real
  - Cierre automático a los 60 segundos sin interacción (Deshabilitado en versión web)
  - Detección avanzada de todas las interacciones del usuario
- **Protección del ciclo de vida de la aplicación**:
  - 🔒 Logout automático al **minimizar la app**
  - 🔒 Logout automático al **cambiar a otra aplicación**
  - 🔒 Logout automático al **abrir el selector de apps recientes**
  - 🔒 Logout automático durante **llamadas telefónicas**
  - 🔒 Logout automático con **notificaciones que toman el foco**
  - 🔒 Logout automático en **modo multitarea/split screen**
  - 🔒 **Reautenticación obligatoria** al volver a la app
- **Gestión segura de memoria**: Limpieza automática de datos sensibles
- **Validación de entrada**: Verificación de datos para prevenir ataques
- **Manejo robusto de errores**: Sistema de autenticación biométrica con múltiples validaciones

## Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada de la aplicación
├── models/
│   └── service.dart            # Modelo de datos para servicios
├── screens/
│   ├── login_screen.dart       # Pantalla de login con biometría
│   ├── home_screen.dart        # Pantalla principal con auto-bloqueo y backup
│   ├── add_service_screen.dart # Pantalla para añadir/editar servicios
│   ├── create_password_screen.dart # Pantalla de creación de contraseña
│   └── two_factor_setup_screen.dart # Configuración de autenticación 2FA
├── services/
│   ├── database_service.dart   # Servicio de base de datos SQLite
│   ├── encryption_service.dart # Servicio de encriptación segura
│   ├── backup_service.dart     # Servicio de backup y restore local
│   ├── password_analyzer.dart  # Análisis de fortaleza de contraseñas
│   ├── two_factor_service.dart # Servicio de autenticación 2FA
│   ├── reminder_service.dart   # Recordatorios de cambio de contraseña
│   ├── settings_service.dart   # Configuración de la aplicación
│   ├── theme_service.dart      # Gestión de temas
│   └── responsive_service.dart # Diseño responsivo
└── widgets/
    ├── service_card.dart       # Widget para mostrar servicios
    └── dialogs/                # Diálogos de la aplicación
        ├── settings_dialog.dart     # Diálogo de configuración
        ├── password_input_dialog.dart # Entrada de contraseña
        └── change_password_dialog.dart # Cambio de contraseña maestra
```

## Dependencias Principales

- `sqflite: ^2.3.0` - Base de datos SQLite local
- `crypto: ^3.0.3` - Encriptación y hash de datos
- `path: ^1.8.3` - Manejo de rutas de archivos
- `shared_preferences: ^2.2.2` - Almacenamiento de preferencias
- `local_auth: ^2.1.7` - Autenticación biométrica
- `file_picker: ^8.0.7` - Selección de archivos para backup/restore
- `path_provider: ^2.1.2` - Acceso a directorios del sistema
- `provider: ^6.1.1` - Gestión de estado y temas
- `intl: ^0.19.0` - Internacionalización y formato de fechas
- `otp: ^3.1.4` - Generación de códigos TOTP para 2FA
- `qr_flutter: ^4.1.0` - Generación de códigos QR para 2FA

## Requisitos del Sistema

### Android
- **Versión mínima**: Android 6.0 (API level 23)
- **Permisos necesarios**: 
  - `USE_BIOMETRIC` - Para autenticación biométrica
  - `USE_FINGERPRINT` - Para huella dactilar
- **Hardware opcional**: Sensor de huella dactilar o cámara para Face ID

### iOS
- **Versión mínima**: iOS 10.0
- **Frameworks**: LocalAuthentication.framework
- **Hardware opcional**: Touch ID o Face ID

## Personalización

### Cambiar colores del tema
Edita el archivo `lib/main.dart` y modifica los colores en el `ThemeData`:
```dart
primarySwatch: Colors.blue,
colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF667eea)),
```

### Configurar temporizador de auto-bloqueo
En `lib/screens/home_screen.dart`, modifica las duraciones:
```dart
// Timer de advertencia (por defecto: 55 segundos)
_warningTimer = Timer(const Duration(seconds: 55), () { ... });

// Timer de cierre (por defecto: 60 segundos)  
_inactivityTimer = Timer(const Duration(seconds: 60), () { ... });
```

### Configurar protección del ciclo de vida
La protección automática está habilitada por defecto. Para personalizarla, edita `didChangeAppLifecycleState` en `home_screen.dart`:
```dart
case AppLifecycleState.paused:
  // Personalizar comportamiento al minimizar
  _logout();
  break;
```

### Personalizar mensajes biométricos
En `lib/screens/login_screen.dart`, edita el texto de autenticación:
```dart
localizedReason: 'Tu mensaje personalizado aquí',
```

## Solución de Problemas

### Autenticación biométrica no funciona
1. Verifica que el dispositivo tenga biometría configurada
2. Revisa los permisos en `android/app/src/main/AndroidManifest.xml`
3. Asegúrate de que el sensor esté limpio y funcionando
4. Comprueba que la app tenga permisos de biometría en configuración del sistema

### La app pide autenticación constantemente
Esto es **comportamiento normal de seguridad**. La app requiere reautenticación:
- Al minimizar y volver a abrir
- Al cambiar de app y regresar
- Al recibir llamadas o notificaciones
- Después de 60 segundos de inactividad

### Error "Incorrect GestureDetector arguments"
Este error se solucionó completamente en la versión actual usando `Listener` en lugar de `GestureDetector`.

### La app se cierra inesperadamente
- Verifica que no haya errores en la configuración de la base de datos
- Revisa los logs para identificar el problema específico
- Asegúrate de que los permisos del AndroidManifest.xml estén correctos

### Problemas de rendimiento o lag
- La detección de interacciones es muy eficiente
- Si experimentas lag, verifica que no hay otras apps consumiendo recursos
- Reinicia el dispositivo si es necesario

## Notas de Desarrollo

⚠️ **Importante**: 
- Este proyecto ha sido desarrollado con asistencia de IA (Cursor)
- Si planeas usar este código en producción, revísalo cuidadosamente
- Realiza pruebas exhaustivas antes del despliegue

## Características Implementadas

- ✅ Autenticación con contraseña maestra
- ✅ Autenticación biométrica (huella dactilar, Face ID) con manejo robusto de errores
- ✅ Auto-bloqueo por inactividad con detección inteligente de interacciones
- ✅ **Protección completa del ciclo de vida de la aplicación**
- ✅ **Logout automático al minimizar o cambiar de app**
- ✅ **Detección de todos los estados de la aplicación**
- ✅ Encriptación segura de contraseñas
- ✅ Generador de contraseñas
- ✅ Búsqueda y filtrado en tiempo real
- ✅ Interfaz de usuario intuitiva
- ✅ Gestión completa de servicios (CRUD)
- ✅ Copia al portapapeles
- ✅ Pull-to-refresh
- ✅ Validación de formularios
- ✅ Manejo robusto de errores
- ✅ **Sistema de timers inteligentes**
- ✅ **Detección avanzada de gestos e interacciones**
- ✅ **Backup y restore local completamente funcional**
- ✅ **Encriptación de backups con contraseña maestra**
- ✅ **Diálogo de configuración avanzado**
- ✅ **Selección de archivos para restore**
- ✅ **Actualización automática de UI después de restore**
- ✅ **Análisis de fortaleza de contraseñas**
- ✅ **Base para autenticación 2FA**
- ✅ **Sistema de recordatorios de contraseñas**
- ✅ **Gestión de temas y configuración**
- ✅ **Diseño responsivo y adaptativo**

## Próximas Mejoras

- � Recordatorios activos de cambio de contraseña
- 🌙 Modo oscuro completo
- 📱 Optimización avanzada para tablets
- 🔐 Autenticación de dos factores (2FA) completa
- ⚙️ Configuración personalizable de timeouts
- 📈 Estadísticas de uso y seguridad
- 🎨 Temas personalizables múltiples
- 🔍 Búsqueda avanzada con filtros
- 📊 Dashboard de seguridad
- 🔄 Backup automático programado
- ☁️ Sincronización opcional entre dispositivos
- 📱 Versión para smartwatch
- 🗂️ Categorización de servicios
- 🔗 Detección automática de servicios duplicados
- 📧 Exportación a otros formatos (CSV, JSON)
- 🛡️ Auditoría de seguridad integrada

## Seguridad de Nivel Bancario

**Moress implementa medidas de seguridad comparables a aplicaciones bancarias:**

🔐 **Múltiples capas de protección**
🛡️ **Detección avanzada del ciclo de vida de la app**
⏱️ **Timeouts inteligentes basados en actividad real**
👆 **Biometría con validaciones robustas**
🔒 **Encriptación de grado militar**
📱 **Protección contra acceso no autorizado**

**No es posible acceder a las contraseñas sin autenticación válida**, incluso si:
- Se minimiza la aplicación momentáneamente
- Se cambia de app y se regresa inmediatamente
- Se recibe una notificación o llamada
- Se abre el selector de aplicaciones recientes
- Se usa multitarea o split screen

## Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## Autor

**Creado por Álvaro García Moreau**
- GitHub: [@AlvaroGarciaMoreau](https://github.com/AlvaroGarciaMoreau)

## Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-caracteristica`)
3. Commit tus cambios (`git commit -am 'Añade nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Crea un Pull Request

## Agradecimientos

- Desarrollado con asistencia de Cursor AI
- Inspirado en la necesidad de gestión segura de contraseñas
- Gracias a la comunidad de Flutter por los excelentes paquetes
