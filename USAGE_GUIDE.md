# DoomScroll Flutter - Usage Guide

## 🚀 Quick Start with Renamed Package

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  doom_scroll_flutter:
    path: ./path/to/doom_scroll_flutter
    # or
    # git:
    #   url: https://github.com/your-username/doom_scroll_flutter.git
```

### Import

```dart
import 'package:doom_scroll_flutter/doom_scroll_flutter.dart';
```

### Basic Usage

```dart
// Your video item model
class MyVideoItem implements FeedItem {
  final String id;
  final String url;
  final String title;

  MyVideoItem({required this.id, required this.url, required this.title});

  @override
  String get videoUrl => url;
  @override
  Map<String, String>? get httpHeaders => null;
}

// Your data provider
class MyVideoDataProvider extends FeedDataProvider<MyVideoItem> {
  // Implementation here...
}

// Use the renamed widget
class VideoFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoomScrollVideoPlayer<MyVideoItem>(  // ← New widget name
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

## 📦 Package Structure

```
doom_scroll_flutter/                    # ← Renamed package
├── lib/
│   ├── doom_scroll_flutter.dart        # ← Main export file
│   └── src/
│       ├── doom_scroll_video_player.dart  # ← Main widget
│       ├── core/
│       ├── overlays/
│       └── feed/
├── example/
└── doc/
```

## 🎯 Key Changes Made

### Package Name
- **Old:** `tiktok_video_player_flutter`
- **New:** `doom_scroll_flutter`

### Main Widget Class
- **Old:** `TikTokVideoPlayer<T>`
- **New:** `DoomScrollVideoPlayer<T>`

### Import Statement
- **Old:** `import 'package:tiktok_video_player_flutter/tiktok_video_player_flutter.dart';`
- **New:** `import 'package:doom_scroll_flutter/doom_scroll_flutter.dart';`

## 🔄 Migration from Old Name

If you were using the old package name, here's how to migrate:

### 1. Update pubspec.yaml
```yaml
dependencies:
  # OLD
  # tiktok_video_player_flutter:
  #   path: ./packages/tiktok_video_player_flutter
  
  # NEW
  doom_scroll_flutter:
    path: ./packages/doom_scroll_flutter
```

### 2. Update imports
```dart
// OLD
// import 'package:tiktok_video_player_flutter/tiktok_video_player_flutter.dart';

// NEW
import 'package:doom_scroll_flutter/doom_scroll_flutter.dart';
```

### 3. Update widget usage
```dart
// OLD
// TikTokVideoPlayer<MyVideoItem>(
//   dataProvider: dataProvider,
// )

// NEW
DoomScrollVideoPlayer<MyVideoItem>(
  dataProvider: dataProvider,
)
```

## 📍 Package Location

Your renamed package is now located at:
```
/home/batmanwa/Work/FlutterProjects/doomscroll/doom_scroll_flutter/
```

## ✅ All Features Preserved

The rename only changed the package name and main widget class. All functionality remains identical:

- ✅ Modular architecture
- ✅ Custom video dimensions
- ✅ Rich overlay system
- ✅ Performance optimizations
- ✅ Error handling
- ✅ Documentation
- ✅ Example app
- ✅ Unit tests

## 🎮 Ready to Use!

Your `doom_scroll_flutter` package is now ready to use in any Flutter project with the new name while maintaining all the powerful video player functionality you built!