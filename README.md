# DoomScroll Flutter

A highly modular, customizable TikTok-like video player for Flutter applications. Features vertical scrolling, auto-play, mute controls, customizable overlays, and flexible video dimensions.

![Demo](doc/demo.gif)

## ✨ Features

- 🎥 **Vertical scrolling video feed** (TikTok/Instagram Reels style)
- ⚡ **Auto-play with visibility detection**
- 🔇 **Tap-to-mute with visual feedback** (configurable)
- 📱 **Aspect ratio preservation** (prevents video stretching)
- 🎨 **Comprehensive theming system** (light/dark themes + full customization)
- 🎯 **Flexible video fitting** (contain, cover, fill options)
- 🏗️ **Highly modular architecture**
- 🔧 **Comprehensive error handling**
- 📊 **Built-in loading and error states**
- 🎯 **Type-safe with generic support**
- 🚀 **Performance optimized**

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  doom_scroll_flutter: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### 1. Basic Implementation

```dart
import 'package:flutter/material.dart';
import 'package:doom_scroll_flutter/doom_scroll_flutter.dart';

// Define your video item
class MyVideoItem implements FeedItem {
  final String videoId;
  final String url;
  final String title;

  MyVideoItem({required this.videoId, required this.url, required this.title});

  @override
  String get id => videoId;
  @override
  String get videoUrl => url;
  @override
  Map<String, String>? get httpHeaders => null;
}

// Create data provider
class MyVideoDataProvider extends FeedDataProvider<MyVideoItem> {
  // Implementation details in full example
}

// Use in your app
class VideoFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoomScrollVideoPlayer<MyVideoItem>(
        dataProvider: MyVideoDataProvider(),
        infoBuilder: (item) => VideoInfoData(title: item.title),
        actionsBuilder: (item) => [
          VideoActionData(
            icon: Icons.favorite_border,
            onTap: () => print('Liked ${item.title}'),
          ),
        ],
      ),
    );
  }
}
```

### 2. Aspect Ratio & Tap Controls

```dart
DoomScrollVideoPlayer<MyVideoItem>(
  dataProvider: dataProvider,
  
  // Preserve aspect ratio (prevents stretching)
  preserveAspectRatio: true,
  fit: BoxFit.contain, // or BoxFit.cover, BoxFit.fill
  
  // Tap to mute/unmute (with visual indicator)
  tapToMute: true,
  
  // Custom aspect ratio
  itemBuilder: (context, item, state) => VideoFeedItem(
    item: item,
    customAspectRatio: 16/9, // Force specific aspect ratio
  ),
)
```

### 3. Theming

```dart
DoomScrollVideoPlayer<MyVideoItem>(
  dataProvider: dataProvider,
  
  // Use built-in themes
  theme: DoomScrollThemeData.dark(),
  
  // Or customize
  theme: DoomScrollThemeData.light().copyWith(
    infoTheme: VideoInfoTheme.light().copyWith(
      titleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      showGradient: false,
    ),
    actionsTheme: VideoActionsTheme.light().copyWith(
      defaultIconColor: Colors.blue,
      activeIconColor: Colors.red,
    ),
  ),
)
```

## 📖 Documentation

### Core Components

- **[DoomScrollVideoPlayer](doc/components/tiktok_video_player.md)** - Main widget
- **[BaseVideoPlayer](doc/components/base_video_player.md)** - Core video functionality
- **[VideoFeedContainer](doc/components/video_feed_container.md)** - Feed management
- **[Overlay System](doc/components/overlays.md)** - Info, controls, actions

### Guides

- **[Getting Started](doc/getting_started.md)** - Complete setup guide
- **[Custom Dimensions](doc/custom_dimensions.md)** - Video sizing options
- **[Aspect Ratio Control](doc/aspect_ratio_control.md)** - Preventing video stretching
- **[Tap-to-Mute](doc/tap_to_mute.md)** - Configurable mute controls
- **[Theming System](doc/theming_system.md)** - Complete theming guide
- **[Data Providers](doc/data_providers.md)** - Managing video data
- **[Advanced Usage](doc/advanced_usage.md)** - Complex implementations

### Examples

- **[Basic Feed](example/lib/basic_feed.dart)** - Simple video feed
- **[Custom Layout](example/lib/custom_layout.dart)** - Custom video layouts
- **[Network Videos](example/lib/network_videos.dart)** - Loading from API
- **[Multi-Size Feed](example/lib/multi_size_feed.dart)** - Different video sizes

## 🏗️ Architecture

The package follows a modular architecture:

```
doom_scroll_flutter/
├── src/
│   ├── core/                 # Core video functionality
│   │   ├── base_video_player.dart
│   │   ├── video_controller_manager.dart
│   │   └── video_player_state.dart
│   ├── overlays/             # UI overlay components
│   │   ├── video_controls_overlay.dart
│   │   ├── video_info_overlay.dart
│   │   ├── video_actions_overlay.dart
│   │   └── video_loading_overlay.dart
│   ├── feed/                 # Feed management
│   │   ├── feed_data_provider.dart
│   │   ├── video_feed_item.dart
│   │   └── video_feed_container.dart
│   └── theme/                # Theming system
│       ├── doom_scroll_theme.dart
│       └── doom_scroll_theme_data.dart
└── doom_scroll_video_player.dart  # Main export file
```

## 🎯 Key Features

### Modular Design
Each component is independent and reusable:
- Mix and match components
- Replace any component with custom implementation
- Extend functionality easily

### Type Safety
Full generic support for your data types:
```dart
DoomScrollVideoPlayer<YourVideoModel>(...)
```

### Performance Optimized
- Efficient video lifecycle management
- Memory leak prevention
- Smooth scrolling performance
- Visibility-based auto-play

### Error Resilient
- Comprehensive error handling
- Graceful fallbacks
- User-friendly error states
- Retry mechanisms

## 🔧 Configuration Options

### Aspect Ratio & Video Fitting
```dart
DoomScrollVideoPlayer(
  // Preserve original aspect ratio (prevents stretching)
  preserveAspectRatio: true,
  
  // Control how video fits in container
  fit: BoxFit.contain,    // Show full video with letterboxing
  fit: BoxFit.cover,      // Fill container, crop if needed
  fit: BoxFit.fill,       // Stretch to fill (may distort)
  
  // Force specific aspect ratio
  itemBuilder: (context, item, state) => VideoFeedItem(
    customAspectRatio: 16/9,     // Widescreen
    customAspectRatio: 9/16,     // Portrait (TikTok style)
    customAspectRatio: 1,        // Square (Instagram style)
  ),
)
```

### Tap-to-Mute Controls
```dart
DoomScrollVideoPlayer(
  tapToMute: true,         // Enable tap-to-mute (default: true)
  tapToMute: false,        // Disable tap-to-mute
  
  // Mute indicator shows automatically on tap
  // - Displays "Muted" or "Unmuted" with icon
  // - Auto-hides after 1.2 seconds
  // - Fully themed and customizable
)
```

### Theming System
```dart
// Built-in themes
DoomScrollVideoPlayer(
  theme: DoomScrollThemeData.light(),
  theme: DoomScrollThemeData.dark(),
)

// Custom themes
DoomScrollVideoPlayer(
  theme: DoomScrollThemeData.dark().copyWith(
    infoTheme: VideoInfoTheme(
      titleStyle: TextStyle(fontSize: 18, color: Colors.white),
      showGradient: true,
      gradientStartColor: Colors.black.withOpacity(0.7),
    ),
    actionsTheme: VideoActionsTheme(
      defaultIconColor: Colors.white,
      activeIconColor: Colors.red,
      backgroundColor: Colors.transparent,
    ),
    controlsTheme: VideoControlsTheme(
      backgroundColor: Colors.black87,
      iconColor: Colors.white,
    ),
  ),
)
```

### Feed Behavior
```dart
DoomScrollVideoPlayer(
  autoPlay: true,           // Auto-play videos
  loop: true,               // Loop videos
  muted: true,              // Start muted
  showControls: true,       // Show control overlays
  showInfo: true,           // Show info overlay
  showActions: true,        // Show action buttons
  preloadThreshold: 0.8,    // When to load more data
)
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the excellent video_player package
- TikTok for inspiration on the user experience
- Contributors who helped improve this package

---

**Made with ❤️ for the Flutter community**