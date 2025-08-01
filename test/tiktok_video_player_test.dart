import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doom_scroll_flutter/doom_scroll_flutter.dart';

// Mock video item for testing
class MockVideoItem implements FeedItem {
  final String videoId;
  final String url;
  final String title;

  MockVideoItem({
    required this.videoId,
    required this.url,
    required this.title,
  });

  @override
  String get id => videoId;

  @override
  String get videoUrl => url;

  @override
  Map<String, String>? get httpHeaders => null;
}

// Mock data provider for testing
class MockVideoDataProvider extends FeedDataProvider<MockVideoItem> {
  List<MockVideoItem> _items = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  List<MockVideoItem> get items => _items;

  @override
  bool get isLoading => _isLoading;

  @override
  bool get hasError => _hasError;

  @override
  String? get errorMessage => _errorMessage;

  @override
  bool get hasMore => false;

  @override
  Future<void> loadInitial() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 100));

    _items = [
      MockVideoItem(
        videoId: '1',
        url: 'https://example.com/video1.mp4',
        title: 'Test Video 1',
      ),
      MockVideoItem(
        videoId: '2',
        url: 'https://example.com/video2.mp4',
        title: 'Test Video 2',
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  @override
  Future<void> loadMore() async {}

  @override
  Future<void> refresh() async {
    _items.clear();
    await loadInitial();
  }

  // Test helper methods
  void setError(String error) {
    _hasError = true;
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
  }
}

void main() {
  group('DoomScrollVideoPlayer', () {
    late MockVideoDataProvider mockDataProvider;

    setUp(() {
      mockDataProvider = MockVideoDataProvider();
    });

    tearDown(() {
      mockDataProvider.dispose();
    });

    testWidgets('should display loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DoomScrollVideoPlayer<MockVideoItem>(
            dataProvider: mockDataProvider,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display videos after loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DoomScrollVideoPlayer<MockVideoItem>(
            dataProvider: mockDataProvider,
          ),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(VideoFeedContainer), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('VideoInfoData', () {
    test('should create VideoInfoData with title', () {
      const info = VideoInfoData(title: 'Test Title');
      
      expect(info.title, 'Test Title');
      expect(info.subtitle, isNull);
      expect(info.description, isNull);
      expect(info.tags, isNull);
    });

    test('should create VideoInfoData with all fields', () {
      const info = VideoInfoData(
        title: 'Test Title',
        subtitle: 'Test Subtitle',
        description: 'Test Description',
        tags: ['tag1', 'tag2'],
      );
      
      expect(info.title, 'Test Title');
      expect(info.subtitle, 'Test Subtitle');
      expect(info.description, 'Test Description');
      expect(info.tags, ['tag1', 'tag2']);
    });
  });

  group('VideoActionData', () {
    test('should create VideoActionData with required fields', () {
      final action = VideoActionData(
        icon: Icons.favorite,
        onTap: () {},
      );
      
      expect(action.icon, Icons.favorite);
      expect(action.label, isNull);
      expect(action.color, isNull);
      expect(action.isActive, false);
      expect(action.onTap, isNotNull);
    });

    test('should create VideoActionData with all fields', () {
      final action = VideoActionData(
        icon: Icons.favorite,
        label: 'Like',
        color: Colors.red,
        isActive: true,
        onTap: () {},
      );
      
      expect(action.icon, Icons.favorite);
      expect(action.label, 'Like');
      expect(action.color, Colors.red);
      expect(action.isActive, true);
      expect(action.onTap, isNotNull);
    });
  });

  group('VideoPlayerState', () {
    test('should create VideoPlayerState with default values', () {
      const state = VideoPlayerState();
      
      expect(state.status, VideoPlayerStatus.loading);
      expect(state.controller, isNull);
      expect(state.errorMessage, isNull);
      expect(state.isMuted, true);
      expect(state.isVisible, false);
      expect(state.volume, 1.0);
      expect(state.position, Duration.zero);
      expect(state.duration, Duration.zero);
    });

    test('should create VideoPlayerState with custom values', () {
      const state = VideoPlayerState(
        status: VideoPlayerStatus.playing,
        isMuted: false,
        isVisible: true,
        volume: 0.5,
        position: Duration(seconds: 30),
        duration: Duration(minutes: 2),
      );
      
      expect(state.status, VideoPlayerStatus.playing);
      expect(state.isMuted, false);
      expect(state.isVisible, true);
      expect(state.volume, 0.5);
      expect(state.position, const Duration(seconds: 30));
      expect(state.duration, const Duration(minutes: 2));
    });

    test('should have correct computed properties', () {
      const state = VideoPlayerState(
        status: VideoPlayerStatus.error,
      );
      
      expect(state.isInitialized, false);
      expect(state.isPlaying, false);
      expect(state.hasError, true);
      expect(state.isLoading, false);
      expect(state.aspectRatio, 16 / 9); // Default aspect ratio
    });
  });

  group('MockVideoDataProvider', () {
    test('should start with empty state', () {
      final provider = MockVideoDataProvider();
      
      expect(provider.items, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.hasError, false);
      expect(provider.errorMessage, isNull);
      expect(provider.hasMore, false);
    });

    test('should load initial data', () async {
      final provider = MockVideoDataProvider();
      
      await provider.loadInitial();
      
      expect(provider.items, hasLength(2));
      expect(provider.items.first.title, 'Test Video 1');
      expect(provider.items.last.title, 'Test Video 2');
      expect(provider.isLoading, false);
    });

    test('should handle errors', () {
      final provider = MockVideoDataProvider();
      
      provider.setError('Network error');
      
      expect(provider.hasError, true);
      expect(provider.errorMessage, 'Network error');
      
      provider.clearError();
      
      expect(provider.hasError, false);
      expect(provider.errorMessage, isNull);
    });
  });
}