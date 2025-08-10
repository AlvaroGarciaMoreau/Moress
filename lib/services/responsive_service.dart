import 'package:flutter/material.dart';
import 'dart:io';

class ResponsiveService {
  // Breakpoints para diferentes tamaños de pantalla
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  // Determinar el tipo de dispositivo basado en el ancho de pantalla
  static DeviceType getDeviceType(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (screenWidth < tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }
  
  // Verificar si es tablet
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }
  
  // Verificar si es desktop
  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }
  
  // Verificar si es mobile
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }
  
  // Determinar si el dispositivo está en orientación horizontal
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
  
  // Determinar si es una tablet física (no solo por tamaño)
  static bool isPhysicalTablet() {
    // En un entorno real, esto podría usar device_info_plus
    // Por ahora, asumimos que es tablet si la plataforma lo sugiere
    return Platform.isAndroid || Platform.isIOS;
  }
  
  // Obtener el número de columnas para la grilla según el dispositivo
  static int getGridColumns(BuildContext context) {
    final deviceType = getDeviceType(context);
    final isLandscapeMode = isLandscape(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return isLandscapeMode ? 2 : 1;
      case DeviceType.tablet:
        return isLandscapeMode ? 3 : 2;
      case DeviceType.desktop:
        return isLandscapeMode ? 4 : 3;
    }
  }
  
  // Obtener padding adaptativo
  static EdgeInsets getAdaptivePadding(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return const EdgeInsets.all(16.0);
      case DeviceType.tablet:
        return const EdgeInsets.all(24.0);
      case DeviceType.desktop:
        return const EdgeInsets.all(32.0);
    }
  }
  
  // Obtener tamaño de fuente adaptativo
  static TextStyle getAdaptiveTextStyle(BuildContext context, TextStyle baseStyle) {
    final deviceType = getDeviceType(context);
    final scaleFactor = _getTextScaleFactor(deviceType);
    
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 14) * scaleFactor,
    );
  }
  
  static double _getTextScaleFactor(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 1.0;
      case DeviceType.tablet:
        return 1.1;
      case DeviceType.desktop:
        return 1.2;
    }
  }
  
  // Obtener espaciado adaptativo
  static double getAdaptiveSpacing(BuildContext context, double baseSpacing) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return baseSpacing;
      case DeviceType.tablet:
        return baseSpacing * 1.2;
      case DeviceType.desktop:
        return baseSpacing * 1.4;
    }
  }
  
  // Determinar si usar layout de panel dividido
  static bool shouldUseSplitView(BuildContext context) {
    final deviceType = getDeviceType(context);
    final isLandscapeMode = isLandscape(context);
    
    return (deviceType == DeviceType.tablet || deviceType == DeviceType.desktop) && 
           isLandscapeMode;
  }
  
  // Obtener ancho máximo para el contenido en pantallas grandes
  static double getMaxContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return screenWidth;
      case DeviceType.tablet:
        return screenWidth * 0.9;
      case DeviceType.desktop:
        return 1200; // Máximo para desktop
    }
  }
  
  // Obtener configuración de diálogo adaptativo
  static double getDialogWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return screenWidth * 0.9;
      case DeviceType.tablet:
        return screenWidth * 0.7;
      case DeviceType.desktop:
        return 600;
    }
  }
  
  // Verificar si se debe mostrar el drawer automáticamente
  static bool shouldShowDrawer(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }
  
  // Obtener el tipo de navegación apropiado
  static NavigationType getNavigationType(BuildContext context) {
    final deviceType = getDeviceType(context);
    final isLandscapeMode = isLandscape(context);
    
    if (deviceType == DeviceType.desktop) {
      return NavigationType.drawer;
    } else if (deviceType == DeviceType.tablet && isLandscapeMode) {
      return NavigationType.rail;
    } else {
      return NavigationType.bottomBar;
    }
  }
}

enum DeviceType {
  mobile,
  tablet,
  desktop,
}

enum NavigationType {
  bottomBar,  // Barra inferior para móviles
  rail,       // Rail lateral para tablets en horizontal
  drawer,     // Drawer para desktop
}

// Widget adaptativo para manejar diferentes layouts
class AdaptiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget? tabletLayout;
  final Widget? desktopLayout;
  
  const AdaptiveLayout({
    super.key,
    required this.mobileLayout,
    this.tabletLayout,
    this.desktopLayout,
  });
  
  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveService.getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return mobileLayout;
      case DeviceType.tablet:
        return tabletLayout ?? mobileLayout;
      case DeviceType.desktop:
        return desktopLayout ?? tabletLayout ?? mobileLayout;
    }
  }
}

// Widget para contenedores con ancho máximo
class MaxWidthContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  
  const MaxWidthContainer({
    super.key,
    required this.child,
    this.maxWidth,
  });
  
  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = maxWidth ?? ResponsiveService.getMaxContentWidth(context);
    
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: child,
      ),
    );
  }
}

// Widget para padding adaptativo
class AdaptivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? customPadding;
  
  const AdaptivePadding({
    super.key,
    required this.child,
    this.customPadding,
  });
  
  @override
  Widget build(BuildContext context) {
    final padding = customPadding ?? ResponsiveService.getAdaptivePadding(context);
    
    return Padding(
      padding: padding,
      child: child,
    );
  }
}

// Extension para MediaQuery más fácil
extension ResponsiveExtension on BuildContext {
  DeviceType get deviceType => ResponsiveService.getDeviceType(this);
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;
  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isLandscape => ResponsiveService.isLandscape(this);
  bool get shouldUseSplitView => ResponsiveService.shouldUseSplitView(this);
  int get gridColumns => ResponsiveService.getGridColumns(this);
}
