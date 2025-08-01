# DoomScroll Flutter

A highly modular, customizable TikTok-like video player for Flutter applications. Features vertical scrolling, auto-play, mute controls, customizable overlays, and flexible video dimensions.

![Demo](doc/demo.gif)

## ✨ Features

- 🎥 **Vertical scrolling video feed** (TikTok/Instagram Reels style)
- ⚡ **Auto-play with visibility detection**
- 🔇 **Mute/unmute controls**
- 📱 **Fully responsive and customizable dimensions**
- 🎨 **Rich overlay system** (info, controls, actions)
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

### 2. Custom Dimensions

```dart
DoomScrollVideoPlayer<MyVideoItem>(
  dataProvider: dataProvider,
  
  // Square videos (Instagram-like)
  itemBuilder: (context, item, state) => VideoFeedItem(
    item: item,
    customAspectRatio: 1.0,
    customPadding: EdgeInsets.all(16),
  ),
  
  // Or use specific dimensions
  itemBuilder: (context, item, state) => VideoFeedItem(
    item: item,
    customWidth: 300,
    customHeight: 400,
    customPadding: EdgeInsets.symmetric(horizontal: 20),
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
- **[Data Providers](doc/data_providers.md)** - Managing video data
- **[Customization](doc/customization.md)** - Theming and styling
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
│   └── feed/                 # Feed management
│       ├── feed_data_provider.dart
│       ├── video_feed_item.dart
│       └── video_feed_container.dart
└── tiktok_video_player.dart  # Main export file
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

### Video Dimensions
```dart
// Aspect ratio based
VideoFeedItem(customAspectRatio: 16/9)

// Fixed dimensions  
VideoFeedItem(customWidth: 300, customHeight: 400)

// Responsive
VideoFeedItem(
  customWidth: MediaQuery.of(context).size.width * 0.8,
  customHeight: MediaQuery.of(context).size.height * 0.6,
)
```

### Overlays
```dart
// Info overlay
VideoInfoData(
  title: "Video Title",
  subtitle: "Creator Name", 
  description: "Video description",
  tags: ["tag1", "tag2"],
)

// Action buttons
[
  VideoActionData(icon: Icons.favorite, onTap: () => like()),
  VideoActionData(icon: Icons.share, onTap: () => share()),
  VideoActionData(icon: Icons.comment, onTap: () => comment()),
]
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