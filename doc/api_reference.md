# API Reference

Complete API reference for all public classes and methods in the DoomScroll Flutter package.

## Core Classes

### DoomScrollVideoPlayer<T>

Main widget that provides the complete TikTok-like video experience.

```dart
class DoomScrollVideoPlayer<T extends FeedItem> extends StatelessWidget
```

#### Constructor Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dataProvider` | `FeedDataProvider<T>` | required | Provides video data and manages loading states |
| `infoBuilder` | `FeedItemInfoBuilder<T>?` | null | Builds info overlay for each video |
| `actionsBuilder` | `FeedItemActionsBuilder<T>?` | null | Builds action buttons for each video |
| `itemBuilder` | `VideoFeedItemBuilder<T>?` | null | Custom builder for complete layout control |
| `autoPlay` | `bool` | true | Whether videos auto-play when visible |
| `loop` | `bool` | true | Whether videos loop when they end |
| `muted` | `bool` | true | Whether videos start muted |
| `showControls` | `bool` | true | Whether to show control overlays |
| `showInfo` | `bool` | true | Whether to show info overlay |
| `showActions` | `bool` | true | Whether to show action buttons |
| `onPageChanged` | `Function(int)?` | null | Callback when page/video changes |
| `fit` | `BoxFit?` | null | How video fits within container |
| `preserveAspectRatio` | `bool` | true | Whether to preserve video aspect ratio |
| `tapToMute` | `bool` | true | Whether tapping video toggles mute |
| `theme` | `DoomScrollThemeData?` | null | Custom theme for styling |

#### Example

```dart
DoomScrollVideoPlayer<MyVideoItem>(
  dataProvider: myDataProvider,
  
  // Aspect ratio and fitting
  preserveAspectRatio: true,
  fit: BoxFit.contain,
  
  // Tap controls
  tapToMute: true,
  
  // Theming
  theme: DoomScrollThemeData.dark(),
  
  // Content builders
  infoBuilder: (item) => VideoInfoData(title: item.title),
  actionsBuilder: (item) => [
    VideoActionData(icon: Icons.favorite, onTap: () => like(item)),
  ],
  
  // Events
  onPageChanged: (index) => print('Video $index'),
)
```

---

### BaseVideoPlayer

Core video player widget with lifecycle management.

```dart
class BaseVideoPlayer extends StatefulWidget
```

#### Constructor Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `videoUrl` | `String` | required | URL of the video to play |
| `httpHeaders` | `Map<String, String>?` | null | HTTP headers for video requests |
| `autoPlay` | `bool` | true | Whether video should auto-play |
| `loop` | `bool` | true | Whether video should loop |
| `muted` | `bool` | true | Whether video should start muted |
| `aspectRatio` | `double?` | null | Force specific aspect ratio |
| `loadingWidget` | `Widget?` | null | Custom loading widget |
| `errorWidget` | `Widget?` | null | Custom error widget |
| `onStateChanged` | `Function(VideoPlayerState)?` | null | State change callback |
| `onVisibilityChanged` | `Function(bool)?` | null | Visibility change callback |
| `visibilityThreshold` | `double` | 0.5 | Minimum visibility for auto-play |

---

### VideoFeedItem<T>

Individual video item with overlay support and custom dimensions.

```dart
class VideoFeedItem<T extends FeedItem> extends StatefulWidget
```

#### Constructor Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `item` | `T` | required | Video item data |
| `infoData` | `VideoInfoData?` | null | Info overlay data |
| `actions` | `List<VideoActionData>?` | null | Action buttons |
| `showControls` | `bool` | true | Show control overlays |
| `showInfo` | `bool` | true | Show info overlay |
| `showActions` | `bool` | true | Show action buttons |
| `autoPlay` | `bool` | true | Auto-play video |
| `loop` | `bool` | true | Loop video |
| `muted` | `bool` | true | Start muted |
| `customAspectRatio` | `double?` | null | Custom aspect ratio |
| `customWidth` | `double?` | null | Custom width in pixels |
| `customHeight` | `double?` | null | Custom height in pixels |
| `customPadding` | `EdgeInsets?` | null | Custom padding |
| `customBuilder` | `VideoFeedItemBuilder<T>?` | null | Complete custom builder |
| `loadingWidget` | `Widget?` | null | Custom loading widget |
| `errorWidget` | `Widget?` | null | Custom error widget |

---

## Data Models

### FeedItem

Interface that video items must implement.

```dart
abstract class FeedItem {
  String get id;                           // Unique identifier
  String get videoUrl;                     // Video URL
  Map<String, String>? get httpHeaders;    // Optional HTTP headers
}
```

### VideoInfoData

Data model for video information overlay.

```dart
class VideoInfoData {
  final String title;              // Video title
  final String? subtitle;          // Subtitle (e.g., creator name)
  final String? description;       // Video description
  final List<String>? tags;        // Video tags/hashtags
}
```

### VideoActionData

Data model for action buttons.

```dart
class VideoActionData {
  final IconData icon;             // Button icon
  final String? label;             // Button label
  final VoidCallback? onTap;       // Tap callback
  final Color? color;              // Button color
  final bool isActive;             // Whether button is in active state
}
```

### VideoPlayerState

Immutable state object for video player.

```dart
class VideoPlayerState {
  final VideoPlayerStatus status;          // Current status
  final VideoPlayerController? controller; // Video controller
  final String? errorMessage;              // Error message if any
  final bool isMuted;                      // Current mute state
  final bool isVisible;                    // Current visibility
  final double volume;                     // Current volume (0.0-1.0)
  final Duration position;                 // Current playback position
  final Duration duration;                 // Total video duration
  
  // Computed properties
  bool get isInitialized;                  // Whether controller is ready
  bool get isPlaying;                      // Whether video is playing
  bool get hasError;                       // Whether there's an error
  bool get isLoading;                      // Whether video is loading
  double get aspectRatio;                  // Video aspect ratio
}
```

#### VideoPlayerStatus Enum

```dart
enum VideoPlayerStatus {
  loading,    // Video is loading
  ready,      // Video is ready but not playing
  playing,    // Video is currently playing
  paused,     // Video is paused
  error,      // Video has an error
  disposed,   // Video controller is disposed
}
```

---

## Abstract Classes

### FeedDataProvider<T>

Abstract base class for managing video data.

```dart
abstract class FeedDataProvider<T extends FeedItem> extends ChangeNotifier {
  List<T> get items;           // Current video items
  bool get isLoading;          // Whether data is loading
  bool get hasError;           // Whether there's a loading error
  String? get errorMessage;    // Error message if any
  bool get hasMore;            // Whether more data is available
  
  Future<void> loadInitial();  // Load initial data
  Future<void> loadMore();     // Load more data (pagination)
  Future<void> refresh();      // Refresh all data
}
```

---

## Type Definitions

### Function Types

```dart
// Builder for video info overlay
typedef FeedItemInfoBuilder<T extends FeedItem> = VideoInfoData? Function(T item);

// Builder for action buttons
typedef FeedItemActionsBuilder<T extends FeedItem> = List<VideoActionData>? Function(T item);

// Custom video item builder
typedef VideoFeedItemBuilder<T extends FeedItem> = Widget Function(
  BuildContext context,
  T item,
  VideoPlayerState state,
);

// Error builder
typedef FeedErrorBuilder = Widget Function(
  BuildContext context,
  String? error,
  VoidCallback? onRetry,
);

// Loading builder
typedef FeedLoadingBuilder = Widget Function(BuildContext context);

// Empty state builder
typedef FeedEmptyBuilder = Widget Function(BuildContext context);
```

---

## Overlay Widgets

### VideoControlsOverlay

Displays mute/unmute indicator with animation.

```dart
VideoControlsOverlay({
  bool isMuted = true,               // Current mute state
  bool isPlaying = false,            // Current play state
  bool showMuteIndicator = false,    // Whether to show mute indicator
  Color? iconColor,                  // Icon color override
  double? iconSize = 32,             // Icon size override
  EdgeInsets? padding,               // Padding override
})
```

### VideoInfoOverlay

Displays video information (title, description, etc.).

```dart
VideoInfoOverlay({
  required VideoInfoData info,       // Info data
  EdgeInsets? padding,               // Overlay padding
  double? maxWidth,                  // Maximum width
  int? maxTitleLines = 3,            // Max title lines
  int? maxDescriptionLines = 2,      // Max description lines
  TextStyle? titleStyle,             // Title text style
  TextStyle? subtitleStyle,          // Subtitle text style
  TextStyle? descriptionStyle,       // Description text style
  Color? backgroundColor,            // Background color
  bool showGradient = true,          // Whether to show gradient
})
```

### VideoActionsOverlay

Displays action buttons (like, share, comment, etc.).

```dart
VideoActionsOverlay({
  required List<VideoActionData> actions,  // Action buttons
  EdgeInsets? padding,                     // Overlay padding
  double? iconSize = 28,                   // Icon size
  double spacing = 16,                     // Spacing between buttons
  Color? defaultIconColor,                 // Default icon color
  Color? activeIconColor,                  // Active icon color
  TextStyle? labelStyle,                   // Label text style
})
```

### VideoLoadingOverlay

Displays loading and error states.

```dart
VideoLoadingOverlay({
  Widget? loadingWidget,             // Custom loading widget
  Widget? errorWidget,               // Custom error widget
  String? errorMessage,              // Error message
  VoidCallback? onRetry,             // Retry callback
  bool showRetryButton = true,       // Whether to show retry button
  Color? backgroundColor,            // Background color
})
```

---

## Constants and Defaults

### Default Values

```dart
const double DEFAULT_VISIBILITY_THRESHOLD = 0.5;
const double DEFAULT_ICON_SIZE = 24.0;
const double DEFAULT_ACTION_ICON_SIZE = 28.0;
const double DEFAULT_SPACING = 16.0;
const Duration DEFAULT_ANIMATION_DURATION = Duration(milliseconds: 300);
const EdgeInsets DEFAULT_PADDING = EdgeInsets.all(16.0);
```

### Common Aspect Ratios

```dart
const double ASPECT_RATIO_TIKTOK = 9 / 16;      // 0.5625
const double ASPECT_RATIO_INSTAGRAM = 1.0;       // 1.0
const double ASPECT_RATIO_YOUTUBE = 16 / 9;      // 1.7778
const double ASPECT_RATIO_STORIES = 9 / 16;      // 0.5625
const double ASPECT_RATIO_SQUARE = 1.0;          // 1.0
```

---

## Theming System

### DoomScrollThemeData

Main theme configuration class.

```dart
class DoomScrollThemeData {
  const DoomScrollThemeData({
    required this.infoTheme,
    required this.actionsTheme,
    required this.controlsTheme,
    required this.colors,
  });
  
  // Factory constructors
  factory DoomScrollThemeData.light();
  factory DoomScrollThemeData.dark();
  
  // Copy with modifications
  DoomScrollThemeData copyWith({
    VideoInfoTheme? infoTheme,
    VideoActionsTheme? actionsTheme,
    VideoControlsTheme? controlsTheme,
    DoomScrollColors? colors,
  });
}
```

### VideoInfoTheme

Theme for video information overlay.

```dart
class VideoInfoTheme {
  const VideoInfoTheme({
    required this.titleStyle,          // Title text style
    required this.subtitleStyle,       // Subtitle text style
    required this.descriptionStyle,    // Description text style
    required this.tagStyle,            // Tag text style
    required this.gradientStartColor,  // Gradient start color
    required this.gradientEndColor,    // Gradient end color
    required this.tagBackgroundColor,  // Tag background color
    required this.padding,             // Content padding
    required this.showGradient,        // Whether to show gradient
  });
  
  factory VideoInfoTheme.light();
  factory VideoInfoTheme.dark();
  
  VideoInfoTheme copyWith({...});
}
```

### VideoActionsTheme

Theme for action buttons overlay.

```dart
class VideoActionsTheme {
  const VideoActionsTheme({
    required this.defaultIconColor,    // Default icon color
    required this.activeIconColor,     // Active icon color
    required this.backgroundColor,     // Button background color
    required this.labelStyle,          // Label text style
    required this.iconSize,            // Icon size
    required this.spacing,             // Spacing between buttons
    required this.padding,             // Overlay padding
    required this.buttonPadding,       // Individual button padding
  });
  
  factory VideoActionsTheme.light();
  factory VideoActionsTheme.dark();
  
  VideoActionsTheme copyWith({...});
}
```

### VideoControlsTheme

Theme for mute indicator.

```dart
class VideoControlsTheme {
  const VideoControlsTheme({
    required this.iconColor,          // Icon color
    required this.backgroundColor,    // Background color
    required this.textStyle,          // Text style
    required this.iconSize,           // Icon size
    required this.padding,            // Content padding
    required this.borderRadius,       // Border radius
    required this.shadows,            // Box shadows
  });
  
  factory VideoControlsTheme.light();
  factory VideoControlsTheme.dark();
  
  VideoControlsTheme copyWith({...});
}
```

### DoomScrollColors

General color scheme.

```dart
class DoomScrollColors {
  const DoomScrollColors({
    required this.surface,            // Surface color
    required this.onSurface,          // Text on surface
    required this.error,              // Error color
    required this.onError,            // Text on error
    required this.loading,            // Loading indicator color
  });
  
  factory DoomScrollColors.light();
  factory DoomScrollColors.dark();
  
  DoomScrollColors copyWith({...});
}
```

### DoomScrollTheme

Inherited widget for providing theme data.

```dart
class DoomScrollTheme extends InheritedWidget {
  const DoomScrollTheme({
    super.key,
    required this.data,
    required super.child,
  });
  
  // Get theme from context
  static DoomScrollThemeData of(BuildContext context);
  static DoomScrollThemeData? maybeOf(BuildContext context);
}

// Extension for easy access
extension DoomScrollThemeExtension on BuildContext {
  DoomScrollThemeData get doomScrollTheme;
}
```

### Usage Examples

```dart
// Built-in themes
DoomScrollVideoPlayer(
  theme: DoomScrollThemeData.dark(),
)

// Custom theme
DoomScrollVideoPlayer(
  theme: DoomScrollThemeData.dark().copyWith(
    infoTheme: VideoInfoTheme.dark().copyWith(
      titleStyle: TextStyle(fontSize: 20),
    ),
  ),
)

// Global theme
DoomScrollTheme(
  data: DoomScrollThemeData.dark(),
  child: MyApp(),
)

// Access theme in custom widgets
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.doomScrollTheme;
    return Container(
      color: theme.colors.surface,
      child: Text(
        'Hello',
        style: theme.infoTheme.titleStyle,
      ),
    );
  }
}
```