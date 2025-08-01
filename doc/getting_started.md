# Getting Started

This guide will help you set up and use the DoomScroll Flutter package in your application.

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  doom_scroll_flutter: ^1.0.0
  # Required peer dependencies
  video_player: ^2.8.2
  visibility_detector: ^0.4.0+2
```

Run:
```bash
flutter pub get
```

## Basic Setup

### 1. Define Your Video Item

First, create a class that implements the `FeedItem` interface:

```dart
import 'package:doom_scroll_flutter/doom_scroll_flutter.dart';

class MyVideoItem implements FeedItem {
  final String videoId;
  final String url;
  final String title;
  final String? description;
  final String? creatorName;

  MyVideoItem({
    required this.videoId,
    required this.url,
    required this.title,
    this.description,
    this.creatorName,
  });

  @override
  String get id => videoId;

  @override
  String get videoUrl => url;

  @override
  Map<String, String>? get httpHeaders => null; // Add auth headers if needed
}
```

### 2. Create a Data Provider

Implement the `FeedDataProvider` to manage your video data:

```dart
class MyVideoDataProvider extends FeedDataProvider<MyVideoItem> {
  List<MyVideoItem> _items = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  
  @override
  List<MyVideoItem> get items => _items;
  
  @override
  bool get isLoading => _isLoading;
  
  @override
  bool get hasError => _hasError;
  
  @override
  String? get errorMessage => _errorMessage;
  
  @override
  bool get hasMore => true; // Set based on your pagination logic

  @override
  Future<void> loadInitial() async {
    if (_isLoading) return;
    
    _setLoading(true);
    _setError(false, null);
    
    try {
      // Load your video data from API
      final response = await ApiService.getVideos();
      _items = response.videos.map((v) => MyVideoItem.fromJson(v)).toList();
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(true, e.toString());
      _setLoading(false);
    }
  }

  @override
  Future<void> loadMore() async {
    if (_isLoading || !hasMore) return;
    
    _setLoading(true);
    try {
      // Load next page
      final response = await ApiService.getVideos(page: _items.length ~/ 10 + 1);
      _items.addAll(response.videos.map((v) => MyVideoItem.fromJson(v)));
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(true, e.toString());
      _setLoading(false);
    }
  }

  @override
  Future<void> refresh() async {
    _items.clear();
    await loadInitial();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(bool error, String? message) {
    _hasError = error;
    _errorMessage = message;
    notifyListeners();
  }
}
```

### 3. Create Your Video Feed Page

```dart
class VideoFeedPage extends StatefulWidget {
  @override
  State<VideoFeedPage> createState() => _VideoFeedPageState();
}

class _VideoFeedPageState extends State<VideoFeedPage> {
  late MyVideoDataProvider _dataProvider;

  @override
  void initState() {
    super.initState();
    _dataProvider = MyVideoDataProvider();
  }

  @override
  void dispose() {
    _dataProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoomScrollVideoPlayer<MyVideoItem>(
        dataProvider: _dataProvider,
        
        // Build info overlay
        infoBuilder: (item) => VideoInfoData(
          title: item.title,
          subtitle: item.creatorName,
          description: item.description,
        ),
        
        // Build action buttons
        actionsBuilder: (item) => [
          VideoActionData(
            icon: Icons.favorite_border,
            label: 'Like',
            onTap: () => _likeVideo(item),
          ),
          VideoActionData(
            icon: Icons.share,
            label: 'Share',
            onTap: () => _shareVideo(item),
          ),
          VideoActionData(
            icon: Icons.comment,
            label: 'Comment',
            onTap: () => _openComments(item),
          ),
        ],
        
        // Handle page changes
        onPageChanged: (index) {
          print('Viewing video ${index + 1} of ${_dataProvider.items.length}');
        },
      ),
    );
  }

  void _likeVideo(MyVideoItem item) {
    // Implement like functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Liked ${item.title}')),
    );
  }

  void _shareVideo(MyVideoItem item) {
    // Implement share functionality
    Share.share('Check out this video: ${item.title}', subject: item.title);
  }

  void _openComments(MyVideoItem item) {
    // Navigate to comments page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommentsPage(videoId: item.id),
      ),
    );
  }
}
```

## Configuration Options

### Auto-play and Controls

```dart
DoomScrollVideoPlayer<MyVideoItem>(
  dataProvider: dataProvider,
  autoPlay: true,        // Videos start playing automatically
  loop: true,            // Videos loop when they end
  muted: true,           // Videos start muted
  showControls: true,    // Show mute/unmute button
  showInfo: true,        // Show title/description overlay
  showActions: true,     // Show action buttons
)
```

### Custom Error and Loading States

```dart
DoomScrollVideoPlayer<MyVideoItem>(
  dataProvider: dataProvider,
  errorBuilder: (context, error, retry) => CustomErrorWidget(
    error: error,
    onRetry: retry,
  ),
  loadingBuilder: (context) => const CustomLoadingWidget(),
  emptyBuilder: (context) => const CustomEmptyWidget(),
)
```

## Next Steps

- [Custom Dimensions](custom_dimensions.md) - Learn how to control video sizes
- [Advanced Customization](customization.md) - Theme and style your video player
- [Data Providers](data_providers.md) - Advanced data management patterns
- [Performance Tips](performance.md) - Optimize your video feed

## Common Issues

### Videos not loading
- Check that your video URLs are accessible
- Verify HTTP headers if authentication is required
- Test with sample videos first

### Performance issues
- Implement proper pagination in your data provider
- Use `preloadThreshold` to control when new data loads
- Consider video resolution and format

### Memory issues
- Ensure you dispose of data providers properly
- The package handles video controller disposal automatically
- Monitor memory usage with large video lists