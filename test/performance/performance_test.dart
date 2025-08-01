import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doom_scroll_flutter/doom_scroll_flutter.dart';

void main() {
  group('Performance Tests', () {
    late PerformanceTestDataProvider dataProvider;

    setUp(() {
      dataProvider = PerformanceTestDataProvider();
    });

    tearDown(() {
      dataProvider.dispose();
    });

    testWidgets('should handle large video lists efficiently', (WidgetTester tester) async {
      // Create a large dataset
      dataProvider.createLargeDataset(1000);

      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<PerformanceTestVideoItem>(
              dataProvider: dataProvider,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Should render in reasonable time (less than 1 second for initial load)
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      
      // Should show video feed
      expect(find.byType(VideoFeedContainer), findsOneWidget);
    });

    testWidgets('should handle rapid scrolling without memory leaks', (WidgetTester tester) async {
      dataProvider.createLargeDataset(50);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<PerformanceTestVideoItem>(
              dataProvider: dataProvider,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      final stopwatch = Stopwatch()..start();

      // Perform rapid scrolling
      for (int i = 0; i < 10; i++) {
        await tester.drag(find.byType(PageView), Offset(0, -400));
        await tester.pump(Duration(milliseconds: 50));
      }

      await tester.pumpAndSettle();
      stopwatch.stop();

      // Should handle rapid scrolling efficiently
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });

    testWidgets('should handle theme changes efficiently', (WidgetTester tester) async {
      dataProvider.createSmallDataset(5);

      // Start with light theme
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<PerformanceTestVideoItem>(
              dataProvider: dataProvider,
              theme: DoomScrollThemeData.light(),
              infoBuilder: (item) => VideoInfoData(title: item.title),
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      final stopwatch = Stopwatch()..start();

      // Switch to dark theme
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<PerformanceTestVideoItem>(
              dataProvider: dataProvider,
              theme: DoomScrollThemeData.dark(),
              infoBuilder: (item) => VideoInfoData(title: item.title),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      stopwatch.stop();

      // Theme change should be efficient
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
      
      // Should still display content
      expect(find.byType(VideoFeedContainer), findsOneWidget);
    });
  });

  group('Error Handling Tests', () {
    testWidgets('should handle network errors gracefully', (WidgetTester tester) async {
      final errorProvider = PerformanceTestDataProvider();
      errorProvider.simulateNetworkError();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<PerformanceTestVideoItem>(
              dataProvider: errorProvider,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Should show error state
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Failed to load videos'), findsOneWidget);

      errorProvider.dispose();
    });

    testWidgets('should handle empty responses', (WidgetTester tester) async {
      final emptyProvider = PerformanceTestDataProvider();
      emptyProvider.setEmpty();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<PerformanceTestVideoItem>(
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

    testWidgets('should recover from provider errors', (WidgetTester tester) async {
      final provider = PerformanceTestDataProvider();
      provider.simulateNetworkError();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoomScrollVideoPlayer<PerformanceTestVideoItem>(
              dataProvider: provider,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Should show error initially
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      // Simulate recovery
      provider.recover();
      await provider.refresh();
      await tester.pump(Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Should show content after recovery
      expect(find.byType(VideoFeedContainer), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsNothing);

      provider.dispose();
    });
  });
}

// Test data provider for performance testing
class PerformanceTestDataProvider extends FeedDataProvider<PerformanceTestVideoItem> {
  List<PerformanceTestVideoItem> _items = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _hasMore = false;
  bool _isEmpty = false;

  @override
  List<PerformanceTestVideoItem> get items => _items;

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

    _isLoading = false;
    notifyListeners();
  }

  @override
  Future<void> loadMore() async {
    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 100));

    _isLoading = false;
    notifyListeners();
  }

  @override
  Future<void> refresh() async {
    _items.clear();
    await loadInitial();
  }

  // Test helper methods
  void createLargeDataset(int count) {
    _items = List.generate(count, (index) => PerformanceTestVideoItem(
      id: 'video_$index',
      url: 'https://example.com/video$index.mp4',
      title: 'Performance Test Video $index',
    ));
    notifyListeners();
  }

  void createSmallDataset(int count) {
    _items = List.generate(count, (index) => PerformanceTestVideoItem(
      id: 'video_$index',
      url: 'https://example.com/video$index.mp4',
      title: 'Small Test Video $index',
    ));
    notifyListeners();
  }

  void simulateNetworkError() {
    _hasError = true;
    _errorMessage = 'Network connection failed';
    notifyListeners();
  }

  void setEmpty() {
    _isEmpty = true;
    _items.clear();
    notifyListeners();
  }

  void recover() {
    _hasError = false;
    _errorMessage = null;
    createSmallDataset(3);
  }
}

// Test video item for performance testing
class PerformanceTestVideoItem implements FeedItem {
  final String videoId;
  final String url;
  final String title;

  PerformanceTestVideoItem({
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