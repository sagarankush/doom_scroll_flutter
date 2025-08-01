import 'package:flutter/material.dart';
import 'doom_scroll_theme_data.dart';

/// Inherited widget that provides theme data to descendant widgets
class DoomScrollTheme extends InheritedWidget {
  final DoomScrollThemeData data;

  const DoomScrollTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Gets the theme data from the nearest DoomScrollTheme ancestor
  static DoomScrollThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<DoomScrollTheme>();
    return theme?.data ?? _getDefaultTheme(context);
  }

  /// Gets the theme data from the nearest DoomScrollTheme ancestor without creating a dependency
  static DoomScrollThemeData? maybeOf(BuildContext context) {
    final theme = context.getInheritedWidgetOfExactType<DoomScrollTheme>();
    return theme?.data;
  }

  /// Gets a default theme based on the current Flutter theme brightness
  static DoomScrollThemeData _getDefaultTheme(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark 
        ? DoomScrollThemeData.dark() 
        : DoomScrollThemeData.light();
  }

  @override
  bool updateShouldNotify(DoomScrollTheme oldWidget) {
    return data != oldWidget.data;
  }
}

/// Extension to make theme access more convenient
extension DoomScrollThemeExtension on BuildContext {
  /// Shorthand for DoomScrollTheme.of(context)
  DoomScrollThemeData get doomScrollTheme => DoomScrollTheme.of(this);
}