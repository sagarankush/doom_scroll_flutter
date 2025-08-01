import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doom_scroll_flutter/doom_scroll_flutter.dart';

void main() {
  group('Video Playback Integration Tests', () {
    late TestVideoDataProvider dataProvider;

    setUp(() {
      dataProvider = TestVideoDataProvider();
    });

    tearDown(() {
      dataProvider.dispose();
    });

    testWidgets('should display video feed with multiple items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<TestVideoItem>(
              dataProvider: dataProvider,
            ),
          ),
        ),
      );

      // Initially shows loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for data to load
      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Should show video feed container
      expect(find.byType(VideoFeedContainer), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should handle video scrolling', (WidgetTester tester) async {
      // Add multiple videos to test scrolling
      dataProvider.addTestVideos([
        TestVideoItem(id: '1', url: 'https://example.com/video1.mp4', title: 'Video 1'),
        TestVideoItem(id: '2', url: 'https://example.com/video2.mp4', title: 'Video 2'),
        TestVideoItem(id: '3', url: 'https://example.com/video3.mp4', title: 'Video 3'),
      ]);

      int currentPage = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<TestVideoItem>(
              dataProvider: dataProvider,
              onPageChanged: (index) => currentPage = index,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(currentPage, 0); // Should start at first video

      // Scroll to next video
      await tester.drag(find.byType(PageView), Offset(0, -400));
      await tester.pumpAndSettle();

      expect(currentPage, 1); // Should move to second video
    });

    testWidgets('should display video info overlay', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<TestVideoItem>(
              dataProvider: dataProvider,
              infoBuilder: (item) => VideoInfoData(
                title: item.title,
                subtitle: 'Test Creator',
                description: 'Test Description',
              ),
              showInfo: true,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text('Test Video 1'), findsOneWidget);
      expect(find.text('Test Creator'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('should display video actions overlay', (WidgetTester tester) async {
      bool likeTapped = false;
      bool shareTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<TestVideoItem>(
              dataProvider: dataProvider,
              actionsBuilder: (item) => [
                VideoActionData(
                  icon: Icons.favorite,
                  label: '100',
                  onTap: () => likeTapped = true,
                ),
                VideoActionData(
                  icon: Icons.share,
                  onTap: () => shareTapped = true,
                ),
              ],
              showActions: true,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
      expect(find.text('100'), findsOneWidget);

      // Test action taps
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.tap(find.byIcon(Icons.share));

      expect(likeTapped, true);
      expect(shareTapped, true);
    });

    testWidgets('should handle tap to mute', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<TestVideoItem>(
              dataProvider: dataProvider,
              tapToMute: true,
              showControls: true,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Tap on video to toggle mute
      await tester.tap(find.byType(VideoFeedItem<TestVideoItem>));
      await tester.pump(Duration(milliseconds: 100));

      // Should show mute indicator briefly
      expect(find.byType(VideoControlsOverlay), findsOneWidget);
    });

    testWidgets('should handle error state', (WidgetTester tester) async {
      dataProvider.simulateError('Network error');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<TestVideoItem>(
              dataProvider: dataProvider,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Failed to load videos'), findsOneWidget);
    });

    testWidgets('should handle empty state', (WidgetTester tester) async {
      // Create empty data provider
      final emptyProvider = TestVideoDataProvider();
      emptyProvider.setEmpty();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<TestVideoItem>(
              dataProvider: emptyProvider,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Should show empty state
      expect(find.text('No videos available'), findsOneWidget);

      emptyProvider.dispose();
    });

    testWidgets('should handle refresh', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<TestVideoItem>(
              dataProvider: dataProvider,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Trigger refresh (this would typically be done via pull-to-refresh)
      await dataProvider.refresh();
      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Should still show content after refresh
      expect(find.byType(VideoFeedContainer), findsOneWidget);
    });

    testWidgets('should handle load more', (WidgetTester tester) async {
      dataProvider.enablePagination(hasMore: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<TestVideoItem>(
              dataProvider: dataProvider,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      final initialCount = dataProvider.items.length;

      // Scroll near the end to trigger load more
      await tester.drag(find.byType(PageView), Offset(0, -800));
      await tester.pumpAndSettle();

      // Should have loaded more items
      expect(dataProvider.items.length, greaterThan(initialCount));
    });

    testWidgets('should preserve aspect ratio', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<TestVideoItem>(
              dataProvider: dataProvider,
              preserveAspectRatio: true,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Should use aspect ratio widget
      expect(find.byType(AspectRatio), findsOneWidget);
    });

    testWidgets('should apply custom theme', (WidgetTester tester) async {
      final customTheme = DoomScrollThemeData.dark().copyWith(
        infoTheme: VideoInfoTheme.dark().copyWith(
          titleStyle: TextStyle(fontSize: 24, color: Colors.red),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<TestVideoItem>(
              dataProvider: dataProvider,
              theme: customTheme,
              infoBuilder: (item) => VideoInfoData(title: item.title),
              showInfo: true,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Should apply custom theme styling
      final titleText = tester.widget<Text>(find.text('Test Video 1'));
      expect(titleText.style?.fontSize, 24);
      expect(titleText.style?.color, Colors.red);
    });

    testWidgets('should handle accessibility features', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<TestVideoItem>(
              dataProvider: dataProvider,
              accessibilityConfig: DoomScrollAccessibilityConfig.highAccessibility,
              infoBuilder: (item) => VideoInfoData(title: item.title),
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Should have semantic labels
      expect(find.byType(Semantics), findsWidgets);
    });
  });

  group('Video Player State Management', () {
    testWidgets('should manage video state across page changes', (WidgetTester tester) async {
      final dataProvider = TestVideoDataProvider();
      dataProvider.addTestVideos([
        TestVideoItem(id: '1', url: 'https://example.com/video1.mp4', title: 'Video 1'),
        TestVideoItem(id: '2', url: 'https://example.com/video2.mp4', title: 'Video 2'),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<TestVideoItem>(
              dataProvider: dataProvider,
              autoPlay: true,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Scroll to next video
      await tester.drag(find.byType(PageView), Offset(0, -400));
      await tester.pumpAndSettle();

      // Previous video should pause, new video should play
      // This would be validated with actual video controllers

      dataProvider.dispose();
    });

    testWidgets('should handle visibility changes', (WidgetTester tester) async {
      final dataProvider = TestVideoDataProvider();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<TestVideoItem>(
              dataProvider: dataProvider,
              autoPlay: true,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Simulate app going to background
      // In real scenario, VisibilityDetector would handle this
      
      dataProvider.dispose();
    });
  });
}

// Test data provider for integration tests
class TestVideoDataProvider extends FeedDataProvider<TestVideoItem> {
  List<TestVideoItem> _items = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _hasMore = false;
  bool _isEmpty = false;

  @override
  List<TestVideoItem> get items => _items;

  @override
  bool get isLoading => _isLoading;

  @override
  bool get hasError => _hasError;

  @override
  String? get errorMessage => _errorMessage;

  @override
  bool get hasMore => _hasMore;

  @override
  Future<void> loadInitial() async {
    if (_isEmpty) return;
    
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 100));

    if (_hasError) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (_items.isEmpty) {
      _items = [
        TestVideoItem(
          id: '1',
          url: 'https://example.com/video1.mp4',
          title: 'Test Video 1',
        ),
        TestVideoItem(
          id: '2',
          url: 'https://example.com/video2.mp4',
          title: 'Test Video 2',
        ),
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  Future<void> loadMore() async {
    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 100));

    final newItems = [
      TestVideoItem(
        id: '${_items.length + 1}',
        url: 'https://example.com/video${_items.length + 1}.mp4',
        title: 'Test Video ${_items.length + 1}',
      ),
      TestVideoItem(
        id: '${_items.length + 2}',
        url: 'https://example.com/video${_items.length + 2}.mp4',
        title: 'Test Video ${_items.length + 2}',
      ),
    ];

    _items.addAll(newItems);
    
    // Simulate no more items after loading a few batches
    if (_items.length >= 10) {
      _hasMore = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  Future<void> refresh() async {
    _items.clear();
    await loadInitial();
  }

  // Test helper methods
  void addTestVideos(List<TestVideoItem> videos) {
    _items = videos;
    notifyListeners();
  }

  void simulateError(String error) {
    _hasError = true;
    _errorMessage = error;
    notifyListeners();
  }

  void enablePagination({bool hasMore = true}) {
    _hasMore = hasMore;
  }

  void setEmpty() {
    _isEmpty = true;
    _items.clear();
    notifyListeners();
  }
}

// Test video item
class TestVideoItem implements FeedItem {
  final String videoId;
  final String url;
  final String title;

  TestVideoItem({
    required String id,
    required this.url,
    required this.title,
  }) : videoId = id;

  @override
  String get id => videoId;

  @override
  String get videoUrl => url;

  @override
  Map<String, String>? get httpHeaders => null;
}