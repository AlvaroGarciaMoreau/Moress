# Moress - Gestor de Contraseñas

Moress es una aplicación móvil desarrollada en Flutter para gestionar de forma segura las contraseñas de diferentes servicios y aplicaciones.

## Características

- 🔐 **Autenticación segura**: Contraseña maestra para acceder a la aplicación
- 🔍 **Búsqueda rápida**: Busca servicios por nombre de servicio y nombre de usuario
- 🔒 **Encriptación**: Todas las contraseñas se almacenan encriptadas
- 📱 **Interfaz intuitiva**: Diseño moderno y fácil de usar
- 📋 **Copiar al portapapeles**: Copia contraseñas con un toque
- 🗑️ **Gestión completa**: Añadir, eliminar, editar y gestionar servicios
- 🔄 **Generador de contraseñas**: Genera contraseñas seguras automáticamente

## Instalación

1. Asegúrate de tener Flutter instalado en tu sistema
2. Clona este repositorio
3. Ejecuta `flutter pub get` para instalar las dependencias
4. Ejecuta `flutter run` para iniciar la aplicación

## Uso

### Primera vez
- La contraseña maestra es introducida en el primer login
- Se puede cambiar la contraseña una vez realizado el login desde la screen del home

### Añadir un servicio
1. Inicia sesión con la contraseña maestra
2. Toca el botón "+" flotante
3. Introduce el nombre del servicio
4. Introduce usuario
5. Introduce la contraseña o usa el generador automático
6. Toca "Guardar"

### Ver contraseñas
1. En la lista de servicios, toca cualquier tarjeta
2. La contraseña se mostrará
3. Toca el icono de copiar para copiarla al portapapeles
4. Toca de nuevo para ocultarla

### Buscar servicios y usuarios
- Usa el campo de búsqueda en la parte superior
- Los resultados se filtran automáticamente

## Seguridad

- **Encriptación local**: Todas las contraseñas se encriptan antes de guardarse
- **Almacenamiento local**: Los datos se guardan solo en tu dispositivo
- **Sin conexión**: No requiere internet para funcionar
- **Contraseña maestra**: Protege el acceso a toda la aplicación

## Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/
│   └── service.dart         # Modelo de datos para servicios
├── screens/
│   ├── login_screen.dart    # Pantalla de login
│   ├── home_screen.dart     # Pantalla principal
│   └── add_service_screen.dart # Pantalla para añadir servicios
├── services/
│   ├── database_service.dart # Servicio de base de datos
│   └── encryption_service.dart # Servicio de encriptación
└── widgets/
    └── service_card.dart    # Widget para mostrar servicios
```

## Dependencias

- `sqflite`: Base de datos SQLite local
- `crypto`: Encriptación de datos
- `path`: Manejo de rutas de archivos
- `shared_preferences`: para el guardado encriptada de la contraseña maestra
- `local_auth`: para el uso de huella dactilar

## Personalización

### Cambiar el tema de colores
Edita el archivo `lib/main.dart` y modifica los colores en el `ThemeData`.

## Notas de Seguridad

⚠️ **Importante**: 
- Esta aplicación es para uso personal
Este proyecto a sido creado con Cursor, siendo utilizado IA para su desarrollo, si vas a hacer uso profesional del codigo, revisalo antes, puede contener errores.

- se ha implementado:
  - Biometría (huella dactilar, Face ID)
  - Auto-bloqueo por inactividad

## Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

Creado por Alvaro Garcia Moreau.
