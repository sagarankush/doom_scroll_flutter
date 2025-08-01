# Theming System

Comprehensive theming support for customizing the appearance of all video player components.

## Overview

DoomScroll Flutter provides a complete theming system that allows you to:

- **Use built-in themes**: Light and dark themes out of the box
- **Create custom themes**: Full control over colors, typography, and styling
- **Theme individual components**: Granular control over each overlay
- **Responsive theming**: Automatic adaptation to Flutter's brightness settings

## Quick Start

### Built-in Themes

```dart
// Dark theme (recommended for video content)
DoomScrollVideoPlayer<MyVideoItem>(
  theme: DoomScrollThemeData.dark(),
  dataProvider: dataProvider,
)

// Light theme
DoomScrollVideoPlayer<MyVideoItem>(
  theme: DoomScrollThemeData.light(),
  dataProvider: dataProvider,
)

// Auto theme (follows system)
DoomScrollVideoPlayer<MyVideoItem>(
  // No theme specified - auto-detects from Flutter theme
  dataProvider: dataProvider,
)
```

### Custom Theme

```dart
DoomScrollVideoPlayer<MyVideoItem>(
  theme: DoomScrollThemeData.dark().copyWith(
    infoTheme: VideoInfoTheme.dark().copyWith(
      titleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  ),
  dataProvider: dataProvider,
)
```

## Theme Components

### 1. Video Info Theme

Controls the appearance of video information overlay (title, description, etc.).

```dart
VideoInfoTheme(
  // Text styles
  titleStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
  subtitleStyle: TextStyle(
    fontSize: 14,
    color: Colors.white70,
  ),
  descriptionStyle: TextStyle(
    fontSize: 13,
    color: Colors.white70,
  ),
  tagStyle: TextStyle(
    fontSize: 12,
    color: Colors.white,
  ),
  
  // Background gradient
  showGradient: true,
  gradientStartColor: Colors.black.withOpacity(0.7),
  gradientEndColor: Colors.transparent,
  
  // Tag styling
  tagBackgroundColor: Colors.white.withOpacity(0.2),
  
  // Layout
  padding: EdgeInsets.all(16),
)
```

### 2. Video Actions Theme

Controls the appearance of action buttons (like, share, comment, etc.).

```dart
VideoActionsTheme(
  // Icon colors
  defaultIconColor: Colors.white,
  activeIconColor: Colors.red,
  
  // Button styling
  backgroundColor: Colors.transparent,
  buttonPadding: EdgeInsets.all(8),
  
  // Text styling
  labelStyle: TextStyle(
    fontSize: 12,
    color: Colors.white70,
  ),
  
  // Layout
  iconSize: 28,
  spacing: 16,
  padding: EdgeInsets.all(16),
)
```

### 3. Video Controls Theme

Controls the appearance of the mute/unmute indicator.

```dart
VideoControlsTheme(
  // Colors
  iconColor: Colors.white,
  backgroundColor: Colors.black.withOpacity(0.7),
  
  // Text styling
  textStyle: TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  ),
  
  // Layout
  iconSize: 32,
  padding: EdgeInsets.all(12),
  borderRadius: BorderRadius.circular(8),
  
  // Effects
  shadows: [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ],
)
```

### 4. General Colors

Controls overall component colors.

```dart
DoomScrollColors(
  surface: Colors.black,        // Video background
  onSurface: Colors.white,      // Text on surface
  error: Colors.red,            // Error states
  onError: Colors.white,        // Text on error
  loading: Colors.blue,         // Loading indicators
)
```

## Complete Theme Examples

### Dark Theme (TikTok Style)
```dart
final darkTheme = DoomScrollThemeData(
  infoTheme: VideoInfoTheme(
    titleStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    subtitleStyle: TextStyle(
      fontSize: 14,
      color: Colors.white70,
    ),
    descriptionStyle: TextStyle(
      fontSize: 13,
      color: Colors.white.withOpacity(0.9),
    ),
    tagStyle: TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    showGradient: true,
    gradientStartColor: Colors.black.withOpacity(0.8),
    gradientEndColor: Colors.transparent,
    tagBackgroundColor: Colors.white.withOpacity(0.2),
    padding: EdgeInsets.all(16),
  ),
  
  actionsTheme: VideoActionsTheme(
    defaultIconColor: Colors.white,
    activeIconColor: Colors.red,
    backgroundColor: Colors.transparent,
    labelStyle: TextStyle(
      fontSize: 12,
      color: Colors.white.withOpacity(0.8),
      fontWeight: FontWeight.w500,
    ),
    iconSize: 32,
    spacing: 20,
    buttonPadding: EdgeInsets.all(12),
    padding: EdgeInsets.only(right: 16, bottom: 100),
  ),
  
  controlsTheme: VideoControlsTheme(
    iconColor: Colors.white,
    backgroundColor: Colors.black.withOpacity(0.75),
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    iconSize: 28,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    borderRadius: BorderRadius.circular(25),
    shadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 12,
        offset: Offset(0, 4),
      ),
    ],
  ),
  
  colors: DoomScrollColors(
    surface: Colors.black,
    onSurface: Colors.white,
    error: Colors.red.shade400,
    onError: Colors.white,
    loading: Colors.white.withOpacity(0.8),
  ),
);

// Usage
DoomScrollVideoPlayer<MyVideoItem>(
  theme: darkTheme,
  dataProvider: dataProvider,
)
```

### Light Theme (Instagram Style)
```dart
final lightTheme = DoomScrollThemeData(
  infoTheme: VideoInfoTheme(
    titleStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    subtitleStyle: TextStyle(
      fontSize: 14,
      color: Colors.black54,
    ),
    descriptionStyle: TextStyle(
      fontSize: 13,
      color: Colors.black54,
    ),
    tagStyle: TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    showGradient: true,
    gradientStartColor: Colors.white.withOpacity(0.9),
    gradientEndColor: Colors.transparent,
    tagBackgroundColor: Colors.black.withOpacity(0.7),
    padding: EdgeInsets.all(16),
  ),
  
  actionsTheme: VideoActionsTheme(
    defaultIconColor: Colors.black87,
    activeIconColor: Colors.red,
    backgroundColor: Colors.white.withOpacity(0.9),
    labelStyle: TextStyle(
      fontSize: 12,
      color: Colors.black54,
      fontWeight: FontWeight.w500,
    ),
    iconSize: 28,
    spacing: 16,
    buttonPadding: EdgeInsets.all(10),
    padding: EdgeInsets.all(16),
  ),
  
  controlsTheme: VideoControlsTheme(
    iconColor: Colors.black87,
    backgroundColor: Colors.white.withOpacity(0.95),
    textStyle: TextStyle(
      color: Colors.black87,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    iconSize: 26,
    padding: EdgeInsets.all(12),
    borderRadius: BorderRadius.circular(20),
    shadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  ),
  
  colors: DoomScrollColors(
    surface: Colors.white,
    onSurface: Colors.black87,
    error: Colors.red,
    onError: Colors.white,
    loading: Colors.blue,
  ),
);
```

### Brand Theme (Custom Colors)
```dart
final brandTheme = DoomScrollThemeData.dark().copyWith(
  infoTheme: VideoInfoTheme.dark().copyWith(
    titleStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    gradientStartColor: Color(0xFF6C5CE7).withOpacity(0.8),
    tagBackgroundColor: Color(0xFF6C5CE7).withOpacity(0.9),
  ),
  
  actionsTheme: VideoActionsTheme.dark().copyWith(
    activeIconColor: Color(0xFF6C5CE7),
    backgroundColor: Colors.black.withOpacity(0.3),
  ),
  
  controlsTheme: VideoControlsTheme.dark().copyWith(
    backgroundColor: Color(0xFF6C5CE7).withOpacity(0.9),
    borderRadius: BorderRadius.circular(30),
  ),
);
```

## Global vs Local Theming

### Global Theme (Recommended)
Apply theme to the entire video player:

```dart
DoomScrollVideoPlayer<MyVideoItem>(
  theme: DoomScrollThemeData.dark(),
  // All components use this theme
  dataProvider: dataProvider,
)
```

### Wrap with Theme Widget
For multiple video players in your app:

```dart
MaterialApp(
  home: DoomScrollTheme(
    data: DoomScrollThemeData.dark(),
    child: Scaffold(
      body: Column(
        children: [
          Expanded(
            child: DoomScrollVideoPlayer<MyVideoItem>(
              // Inherits theme from ancestor
              dataProvider: dataProvider1,
            ),
          ),
          Expanded(
            child: DoomScrollVideoPlayer<MyVideoItem>(
              // Also inherits same theme
              dataProvider: dataProvider2,
            ),
          ),
        ],
      ),
    ),
  ),
)
```

### Override Individual Components
```dart
// Individual overlay customization still works
DoomScrollVideoPlayer<MyVideoItem>(
  theme: DoomScrollThemeData.dark(),
  infoBuilder: (item) => VideoInfoData(
    title: item.title,
    // Individual style overrides theme
    titleStyle: TextStyle(fontSize: 24, color: Colors.yellow),
  ),
  dataProvider: dataProvider,
)
```

## Responsive Theming

### System Theme Detection
```dart
class VideoFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Automatically use appropriate theme
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return DoomScrollVideoPlayer<MyVideoItem>(
      theme: isDark 
        ? DoomScrollThemeData.dark() 
        : DoomScrollThemeData.light(),
      dataProvider: dataProvider,
    );
  }
}
```

### Theme Switching
```dart
class ThemedVideoFeed extends StatefulWidget {
  @override
  _ThemedVideoFeedState createState() => _ThemedVideoFeedState();
}

class _ThemedVideoFeedState extends State<ThemedVideoFeed> {
  bool isDarkMode = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => setState(() => isDarkMode = !isDarkMode),
          ),
        ],
      ),
      body: DoomScrollVideoPlayer<MyVideoItem>(
        theme: isDarkMode 
          ? DoomScrollThemeData.dark() 
          : DoomScrollThemeData.light(),
        dataProvider: dataProvider,
      ),
    );
  }
}
```

## Migration Guide

### From Manual Styling
```dart
// Before - manual styling
VideoInfoOverlay(
  info: VideoInfoData(title: "Title"),
  titleStyle: TextStyle(color: Colors.white),
  backgroundColor: Colors.black.withOpacity(0.7),
)

// After - theme-based
DoomScrollVideoPlayer(
  theme: DoomScrollThemeData.dark(),
  infoBuilder: (item) => VideoInfoData(title: item.title),
)
```

### Migrating Existing Themes
```dart
// Convert your existing styles to theme
final myTheme = DoomScrollThemeData.dark().copyWith(
  infoTheme: VideoInfoTheme.dark().copyWith(
    titleStyle: myExistingTitleStyle,
    gradientStartColor: myExistingBackgroundColor,
  ),
  actionsTheme: VideoActionsTheme.dark().copyWith(
    defaultIconColor: myExistingIconColor,
  ),
);
```

## Best Practices

### 1. Use Dark Themes for Video Content
```dart
// ✅ Good - dark themes work better with video content
DoomScrollVideoPlayer(
  theme: DoomScrollThemeData.dark(),
)

// ⚠️ Consider carefully - light themes may compete with video
DoomScrollVideoPlayer(
  theme: DoomScrollThemeData.light(),
)
```

### 2. Maintain Contrast
```dart
// ✅ Good - high contrast for readability
VideoInfoTheme(
  titleStyle: TextStyle(color: Colors.white),
  gradientStartColor: Colors.black.withOpacity(0.8),
)

// ❌ Avoid - poor contrast
VideoInfoTheme(
  titleStyle: TextStyle(color: Colors.grey),
  gradientStartColor: Colors.grey.withOpacity(0.3),
)
```

### 3. Keep Animations Smooth
```dart
// ✅ Good - subtle shadows and effects
VideoControlsTheme(
  shadows: [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 8,
    ),
  ],
)

// ❌ Avoid - heavy effects that may impact performance
VideoControlsTheme(
  shadows: [
    BoxShadow(
      color: Colors.black.withOpacity(0.8),
      blurRadius: 50,
      spreadRadius: 10,
    ),
  ],
)
```

### 4. Test on Different Screen Sizes
```dart
// Use responsive sizing
VideoInfoTheme(
  titleStyle: TextStyle(
    fontSize: MediaQuery.of(context).size.width > 400 ? 18 : 16,
  ),
  padding: EdgeInsets.all(
    MediaQuery.of(context).size.width > 400 ? 16 : 12,
  ),
)
```

## Troubleshooting

### Theme Not Applied
**Problem**: Custom theme not showing
**Solution**: Ensure theme is passed correctly
```dart
// ✅ Correct
DoomScrollVideoPlayer(
  theme: DoomScrollThemeData.dark(),  // Pass theme here
)

// ❌ Won't work
DoomScrollTheme(
  data: DoomScrollThemeData.dark(),
  child: DoomScrollVideoPlayer(
    // No theme parameter - won't inherit automatically
  ),
)
```

### Components Not Themed
**Problem**: Some components still use default styling
**Solution**: Check theme completeness
```dart
// Ensure all theme components are configured
final completeTheme = DoomScrollThemeData(
  infoTheme: VideoInfoTheme(...),      // Required
  actionsTheme: VideoActionsTheme(...), // Required
  controlsTheme: VideoControlsTheme(...), // Required
  colors: DoomScrollColors(...),        // Required
);
```

### Performance Issues
**Problem**: Theme changes cause lag
**Solution**: Create themes once, reuse instances
```dart
// ✅ Good - create once
final _darkTheme = DoomScrollThemeData.dark();

Widget build(BuildContext context) {
  return DoomScrollVideoPlayer(
    theme: _darkTheme,  // Reuse instance
  );
}

// ❌ Avoid - creates new theme every build
Widget build(BuildContext context) {
  return DoomScrollVideoPlayer(
    theme: DoomScrollThemeData.dark(),  // New instance each time
  );
}
```