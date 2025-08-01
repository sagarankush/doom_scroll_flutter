import 'package:flutter/material.dart';

/// Theme configuration for DoomScroll video player components
class DoomScrollThemeData {
  /// Colors for video info overlay
  final VideoInfoTheme infoTheme;
  
  /// Colors for video actions overlay
  final VideoActionsTheme actionsTheme;
  
  /// Colors for video controls overlay (mute indicator)
  final VideoControlsTheme controlsTheme;
  
  /// General UI colors
  final DoomScrollColors colors;

  const DoomScrollThemeData({
    required this.infoTheme,
    required this.actionsTheme,
    required this.controlsTheme,
    required this.colors,
  });

  /// Creates a default light theme
  factory DoomScrollThemeData.light() {
    return DoomScrollThemeData(
      infoTheme: VideoInfoTheme.light(),
      actionsTheme: VideoActionsTheme.light(),
      controlsTheme: VideoControlsTheme.light(),
      colors: DoomScrollColors.light(),
    );
  }

  /// Creates a default dark theme
  factory DoomScrollThemeData.dark() {
    return DoomScrollThemeData(
      infoTheme: VideoInfoTheme.dark(),
      actionsTheme: VideoActionsTheme.dark(),
      controlsTheme: VideoControlsTheme.dark(),
      colors: DoomScrollColors.dark(),
    );
  }

  /// Creates a copy with modified properties
  DoomScrollThemeData copyWith({
    VideoInfoTheme? infoTheme,
    VideoActionsTheme? actionsTheme,
    VideoControlsTheme? controlsTheme,
    DoomScrollColors? colors,
  }) {
    return DoomScrollThemeData(
      infoTheme: infoTheme ?? this.infoTheme,
      actionsTheme: actionsTheme ?? this.actionsTheme,
      controlsTheme: controlsTheme ?? this.controlsTheme,
      colors: colors ?? this.colors,
    );
  }
}

/// Theme for video info overlay
class VideoInfoTheme {
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final TextStyle descriptionStyle;
  final TextStyle tagStyle;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final Color tagBackgroundColor;
  final EdgeInsets padding;
  final bool showGradient;

  const VideoInfoTheme({
    required this.titleStyle,
    required this.subtitleStyle,
    required this.descriptionStyle,
    required this.tagStyle,
    required this.gradientStartColor,
    required this.gradientEndColor,
    required this.tagBackgroundColor,
    required this.padding,
    required this.showGradient,
  });

  factory VideoInfoTheme.light() {
    return VideoInfoTheme(
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      subtitleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
      descriptionStyle: const TextStyle(
        fontSize: 13,
        color: Colors.black54,
      ),
      tagStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
      gradientStartColor: Colors.white.withValues(alpha: 0.9),
      gradientEndColor: Colors.transparent,
      tagBackgroundColor: Colors.black.withValues(alpha: 0.7),
      padding: const EdgeInsets.all(16),
      showGradient: true,
    );
  }

  factory VideoInfoTheme.dark() {
    return VideoInfoTheme(
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      subtitleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),
      descriptionStyle: const TextStyle(
        fontSize: 13,
        color: Colors.white70,
      ),
      tagStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
      gradientStartColor: Colors.black.withValues(alpha: 0.7),
      gradientEndColor: Colors.transparent,
      tagBackgroundColor: Colors.white.withValues(alpha: 0.2),
      padding: const EdgeInsets.all(16),
      showGradient: true,
    );
  }

  VideoInfoTheme copyWith({
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? descriptionStyle,
    TextStyle? tagStyle,
    Color? gradientStartColor,
    Color? gradientEndColor,
    Color? tagBackgroundColor,
    EdgeInsets? padding,
    bool? showGradient,
  }) {
    return VideoInfoTheme(
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      tagStyle: tagStyle ?? this.tagStyle,
      gradientStartColor: gradientStartColor ?? this.gradientStartColor,
      gradientEndColor: gradientEndColor ?? this.gradientEndColor,
      tagBackgroundColor: tagBackgroundColor ?? this.tagBackgroundColor,
      padding: padding ?? this.padding,
      showGradient: showGradient ?? this.showGradient,
    );
  }
}

/// Theme for video actions overlay
class VideoActionsTheme {
  final Color defaultIconColor;
  final Color activeIconColor;
  final Color backgroundColor;
  final TextStyle labelStyle;
  final double iconSize;
  final double spacing;
  final EdgeInsets padding;
  final EdgeInsets buttonPadding;

  const VideoActionsTheme({
    required this.defaultIconColor,
    required this.activeIconColor,
    required this.backgroundColor,
    required this.labelStyle,
    required this.iconSize,
    required this.spacing,
    required this.padding,
    required this.buttonPadding,
  });

  factory VideoActionsTheme.light() {
    return VideoActionsTheme(
      defaultIconColor: Colors.black87,
      activeIconColor: Colors.blue,
      backgroundColor: Colors.white.withValues(alpha: 0.9),
      labelStyle: const TextStyle(
        fontSize: 12,
        color: Colors.black54,
      ),
      iconSize: 28,
      spacing: 16,
      padding: const EdgeInsets.all(16),
      buttonPadding: const EdgeInsets.all(8),
    );
  }

  factory VideoActionsTheme.dark() {
    return VideoActionsTheme(
      defaultIconColor: Colors.white,
      activeIconColor: Colors.blue,
      backgroundColor: Colors.transparent,
      labelStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white70,
      ),
      iconSize: 28,
      spacing: 16,
      padding: const EdgeInsets.all(16),
      buttonPadding: const EdgeInsets.all(8),
    );
  }

  VideoActionsTheme copyWith({
    Color? defaultIconColor,
    Color? activeIconColor,
    Color? backgroundColor,
    TextStyle? labelStyle,
    double? iconSize,
    double? spacing,
    EdgeInsets? padding,
    EdgeInsets? buttonPadding,
  }) {
    return VideoActionsTheme(
      defaultIconColor: defaultIconColor ?? this.defaultIconColor,
      activeIconColor: activeIconColor ?? this.activeIconColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      labelStyle: labelStyle ?? this.labelStyle,
      iconSize: iconSize ?? this.iconSize,
      spacing: spacing ?? this.spacing,
      padding: padding ?? this.padding,
      buttonPadding: buttonPadding ?? this.buttonPadding,
    );
  }
}

/// Theme for video controls overlay (mute indicator)
class VideoControlsTheme {
  final Color iconColor;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double iconSize;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final List<BoxShadow> shadows;

  const VideoControlsTheme({
    required this.iconColor,
    required this.backgroundColor,
    required this.textStyle,
    required this.iconSize,
    required this.padding,
    required this.borderRadius,
    required this.shadows,
  });

  factory VideoControlsTheme.light() {
    return VideoControlsTheme(
      iconColor: Colors.black87,
      backgroundColor: Colors.white.withValues(alpha: 0.9),
      textStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      iconSize: 32,
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(8),
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  factory VideoControlsTheme.dark() {
    return VideoControlsTheme(
      iconColor: Colors.white,
      backgroundColor: Colors.black.withValues(alpha: 0.7),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      iconSize: 32,
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(8),
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  VideoControlsTheme copyWith({
    Color? iconColor,
    Color? backgroundColor,
    TextStyle? textStyle,
    double? iconSize,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
  }) {
    return VideoControlsTheme(
      iconColor: iconColor ?? this.iconColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      iconSize: iconSize ?? this.iconSize,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      shadows: shadows ?? this.shadows,
    );
  }
}

/// General colors for DoomScroll components
class DoomScrollColors {
  final Color surface;
  final Color onSurface;
  final Color error;
  final Color onError;
  final Color loading;

  const DoomScrollColors({
    required this.surface,
    required this.onSurface,
    required this.error,
    required this.onError,
    required this.loading,
  });

  factory DoomScrollColors.light() {
    return const DoomScrollColors(
      surface: Colors.white,
      onSurface: Colors.black87,
      error: Colors.red,
      onError: Colors.white,
      loading: Colors.blue,
    );
  }

  factory DoomScrollColors.dark() {
    return const DoomScrollColors(
      surface: Colors.black,
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      loading: Colors.blue,
    );
  }

  DoomScrollColors copyWith({
    Color? surface,
    Color? onSurface,
    Color? error,
    Color? onError,
    Color? loading,
  }) {
    return DoomScrollColors(
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      loading: loading ?? this.loading,
    );
  }
}