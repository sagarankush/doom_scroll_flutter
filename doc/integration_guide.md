# Integration Guide

This guide helps you integrate the DoomScroll Flutter package into your existing applications.

## Quick Integration

### 1. Install the Package

Add to your `pubspec.yaml`:

```yaml
dependencies:
  doom_scroll_flutter: ^1.0.0
```

### 2. Replace Your Existing Video Feed

If you have an existing video feed, you can replace it with our package:

**Before:**
```dart
// Your existing video feed
PageView.builder(
  scrollDirection: Axis.vertical,
  itemCount: videos.length,
  itemBuilder: (context, index) {
    return YourVideoWidget(video: videos[index]);
  },
)
```

**After:**
```dart
import 'package:doom_scroll_flutter/doom_scroll_flutter.dart';

// Modular, feature-rich video feed
DoomScrollVideoPlayer<YourVideoModel>(
  dataProvider: YourVideoDataProvider(),
  infoBuilder: (video) => VideoInfoData(title: video.title),
  actionsBuilder: (video) => [
    VideoActionData(icon: Icons.favorite, onTap: () => like(video)),
  ],
)
```

## Migration from Custom Implementation

### Step 1: Adapt Your Video Model

Make your existing video model implement `FeedItem`:

```dart
// Your existing model
class Video {
  final String id;
  final String url;
  final String title;
  // ... other properties
}

// Updated to work with the package
class Video implements FeedItem {
  final String id;
  final String url;
  final String title;
  // ... other properties

  // Required FeedItem implementations
  @override
  String get id => this.id;
  
  @override
  String get videoUrl => url;
  
  @override
  Map<String, String>? get httpHeaders => {
    'Authorization': 'Bearer $yourToken',
    // Add any headers your API requires
  };
}
```

### Step 2: Convert Your Data Loading Logic

Transform your existing data loading into a `FeedDataProvider`:

```dart
// Your existing API service
class VideoApiService {
  Future<List<Video>> getVideos({int page = 0}) async {
    // Your existing API logic
  }
}

// New data provider using your existing service
class VideoDataProvider extends FeedDataProvider<Video> {
  final VideoApiService _apiService = VideoApiService();
  List<Video> _items = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  int _currentPage = 0;
  
  @override
  List<Video> get items => _items;
  @override
  bool get isLoading => _isLoading;
  @override
  bool get hasError => _hasError;
  @override
  String? get errorMessage => _errorMessage;
  @override
  bool get hasMore => true; // Implement your pagination logic

  @override
  Future<void> loadInitial() async {
    if (_isLoading) return;
    
    _setLoading(true);
    _setError(false, null);
    _currentPage = 0;
    
    try {
      final videos = await _apiService.getVideos(page: _currentPage);
      _items = videos;
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
      _currentPage++;
      final newVideos = await _apiService.getVideos(page: _currentPage);
      _items.addAll(newVideos);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _currentPage--; // Revert page on error
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

### Step 3: Migrate Your UI Components

Replace your custom video UI with the package components:

```dart
// Your existing video page
class VideoFeedPage extends StatefulWidget {
  @override
  State<VideoFeedPage> createState() => _VideoFeedPageState();
}

class _VideoFeedPageState extends State<VideoFeedPage> {
  late VideoDataProvider _dataProvider;

  @override
  void initState() {
    super.initState();
    _dataProvider = VideoDataProvider();
  }

  @override
  void dispose() {
    _dataProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoomScrollVideoPlayer<Video>(
        dataProvider: _dataProvider,
        
        // Map your existing video info display
        infoBuilder: (video) => VideoInfoData(
          title: video.title,
          subtitle: video.creatorName,
          description: video.description,
          tags: video.hashtags,
        ),
        
        // Map your existing action buttons
        actionsBuilder: (video) => [
          VideoActionData(
            icon: Icons.favorite_border,
            label: '${video.likesCount}',
            isActive: video.isLiked,
            onTap: () => _toggleLike(video),
          ),
          VideoActionData(
            icon: Icons.share,
            label: 'Share',
            onTap: () => _shareVideo(video),
          ),
          VideoActionData(
            icon: Icons.comment,
            label: '${video.commentsCount}',
            onTap: () => _openComments(video),
          ),
        ],
        
        // Keep your existing event handling
        onPageChanged: (index) => _trackVideoView(_dataProvider.items[index]),
      ),
    );
  }

  // Your existing methods
  void _toggleLike(Video video) {
    // Your existing like logic
  }

  void _shareVideo(Video video) {
    // Your existing share logic
  }

  void _openComments(Video video) {
    // Your existing comments logic
  }

  void _trackVideoView(Video video) {
    // Your existing analytics
  }
}
```

## Advanced Integration Patterns

### Custom Dimensions for Different Screens

```dart
class ResponsiveVideoFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          // Desktop: Side-by-side videos
          return _buildDesktopLayout();
        } else if (constraints.maxWidth > 600) {
          // Tablet: Centered videos
          return _buildTabletLayout();
        } else {
          // Mobile: Full screen
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    return DoomScrollVideoPlayer<Video>(
      dataProvider: dataProvider,
      // Full screen mobile experience
    );
  }

  Widget _buildTabletLayout() {
    return DoomScrollVideoPlayer<Video>(
      dataProvider: dataProvider,
      itemBuilder: (context, video, state) => VideoFeedItem(
        item: video,
        customAspectRatio: 9/16,
        customPadding: EdgeInsets.symmetric(horizontal: 60),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return DoomScrollVideoPlayer<Video>(
      dataProvider: dataProvider,
      itemBuilder: (context, video, state) => VideoFeedItem(
        item: video,
        customWidth: 400,
        customHeight: 700,
        customPadding: EdgeInsets.all(40),
      ),
    );
  }
}
```

### Integration with State Management

#### Using Provider

```dart
class VideoFeedWithProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VideoDataProvider(),
      child: Consumer<VideoDataProvider>(
        builder: (context, dataProvider, child) {
          return DoomScrollVideoPlayer<Video>(
            dataProvider: dataProvider,
            actionsBuilder: (video) => [
              VideoActionData(
                icon: context.watch<LikesProvider>().isLiked(video.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
                onTap: () => context.read<LikesProvider>().toggleLike(video),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

#### Using Riverpod

```dart
final videoDataProvider = ChangeNotifierProvider<VideoDataProvider>((ref) {
  return VideoDataProvider();
});

class VideoFeedWithRiverpod extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataProvider = ref.watch(videoDataProvider);
    
    return DoomScrollVideoPlayer<Video>(
      dataProvider: dataProvider,
      actionsBuilder: (video) => [
        VideoActionData(
          icon: ref.watch(likesProvider).isLiked(video.id)
            ? Icons.favorite
            : Icons.favorite_border,
          onTap: () => ref.read(likesProvider.notifier).toggleLike(video),
        ),
      ],
    );
  }
}
```

### Integration with Navigation

```dart
class VideoFeedWithNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DoomScrollVideoPlayer<Video>(
      dataProvider: dataProvider,
      actionsBuilder: (video) => [
        VideoActionData(
          icon: Icons.person,
          label: 'Profile',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfilePage(userId: video.creatorId),
            ),
          ),
        ),
        VideoActionData(
          icon: Icons.info,
          label: 'Details',
          onTap: () => _showVideoDetails(context, video),
        ),
      ],
    );
  }

  void _showVideoDetails(BuildContext context, Video video) {
    showModalBottomSheet(
      context: context,
      builder: (_) => VideoDetailsSheet(video: video),
    );
  }
}
```

## Testing Integration

### Unit Tests

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:doom_scroll_flutter/doom_scroll_flutter.dart';

void main() {
  group('VideoDataProvider', () {
    late VideoDataProvider dataProvider;

    setUp(() {
      dataProvider = VideoDataProvider();
    });

    tearDown(() {
      dataProvider.dispose();
    });

    test('should load initial data', () async {
      expect(dataProvider.items, isEmpty);
      expect(dataProvider.isLoading, false);

      await dataProvider.loadInitial();

      expect(dataProvider.items, isNotEmpty);
      expect(dataProvider.isLoading, false);
      expect(dataProvider.hasError, false);
    });

    test('should handle errors gracefully', () async {
      // Test error handling
      dataProvider.setMockError('Network error');
      
      await dataProvider.loadInitial();
      
      expect(dataProvider.hasError, true);
      expect(dataProvider.errorMessage, 'Network error');
    });
  });
}
```

### Widget Tests

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doom_scroll_flutter/doom_scroll_flutter.dart';

void main() {
  testWidgets('DoomScrollVideoPlayer displays videos', (WidgetTester tester) async {
    final mockDataProvider = MockVideoDataProvider();
    
    await tester.pumpWidget(
      MaterialApp(
        home: DoomScrollVideoPlayer<Video>(
          dataProvider: mockDataProvider,
        ),
      ),
    );

    expect(find.byType(DoomScrollVideoPlayer), findsOneWidget);
    expect(find.byType(BaseVideoPlayer), findsOneWidget);
  });
}
```

## Performance Optimization

### Memory Management

```dart
class OptimizedVideoDataProvider extends FeedDataProvider<Video> {
  static const int MAX_CACHED_VIDEOS = 50;
  
  @override
  Future<void> loadMore() async {
    // Limit cached videos to prevent memory issues
    if (_items.length > MAX_CACHED_VIDEOS) {
      _items = _items.skip(_items.length - MAX_CACHED_VIDEOS).toList();
    }
    
    // Continue with normal loading
    await super.loadMore();
  }
}
```

### Preloading Optimization

```dart
DoomScrollVideoPlayer<Video>(
  dataProvider: dataProvider,
  // Preload videos when 80% through the list
  preloadThreshold: 0.8,
  
  // Optimize for smooth scrolling
  physics: const BouncingScrollPhysics(),
)
```

## Troubleshooting Common Issues

### Videos Not Playing
- Check video URLs are accessible
- Verify HTTP headers for authenticated content
- Test with sample videos first

### Memory Leaks
- Ensure data providers are disposed
- Limit cached video count
- Monitor memory usage during development

### Performance Issues
- Implement pagination in data provider
- Use appropriate preload thresholds
- Consider video resolution and format

### UI Overlaps
- Check overlay positioning
- Verify custom dimensions don't conflict
- Test on different screen sizes