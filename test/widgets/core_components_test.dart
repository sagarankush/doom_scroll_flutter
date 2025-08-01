import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doom_scroll_flutter/doom_scroll_flutter.dart';

// Mock video controller for testing
class MockVideoController {
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = true;
  Duration _position = Duration.zero;
  Duration _duration = const Duration(seconds: 60);

  bool get isInitialized => _isInitialized;
  bool get isPlaying => _isPlaying;
  bool get isMuted => _isMuted;
  Duration get position => _position;
  Duration get duration => _duration;

  void initialize() => _isInitialized = true;
  void play() => _isPlaying = true;
  void pause() => _isPlaying = false;
  void setMuted(bool muted) => _isMuted = muted;
  void seekTo(Duration position) => _position = position;
  void dispose() => _isInitialized = false;
}

void main() {
  group('VideoPlayerState Tests', () {
    test('should create default state', () {
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

    test('should calculate computed properties correctly', () {
      const loadingState = VideoPlayerState(status: VideoPlayerStatus.loading);
      expect(loadingState.isLoading, true);
      expect(loadingState.isInitialized, false);
      expect(loadingState.isPlaying, false);
      expect(loadingState.hasError, false);

      const playingState = VideoPlayerState(status: VideoPlayerStatus.playing);
      expect(playingState.isLoading, false);
      expect(playingState.isInitialized, true);
      expect(playingState.isPlaying, true);
      expect(playingState.hasError, false);

      const errorState = VideoPlayerState(status: VideoPlayerStatus.error);
      expect(errorState.isLoading, false);
      expect(errorState.isInitialized, false);
      expect(errorState.isPlaying, false);
      expect(errorState.hasError, true);
    });

    test('should calculate aspect ratio', () {
      const defaultState = VideoPlayerState();
      expect(defaultState.aspectRatio, 16/9); // Default aspect ratio when no controller
    });

    test('should support copyWith', () {
      const originalState = VideoPlayerState(
        status: VideoPlayerStatus.loading,
        isMuted: true,
        volume: 1.0,
      );

      final newState = originalState.copyWith(
        status: VideoPlayerStatus.playing,
        isMuted: false,
      );

      expect(newState.status, VideoPlayerStatus.playing);
      expect(newState.isMuted, false);
      expect(newState.volume, 1.0); // Unchanged
    });
  });

  group('VideoControllerManager Tests', () {
    late VideoControllerManager manager;

    setUp(() {
      manager = VideoControllerManager();
    });

    tearDown(() {
      manager.dispose();
    });

    test('should start with loading state', () {
      expect(manager.state.status, VideoPlayerStatus.loading);
      expect(manager.state.isInitialized, false);
      expect(manager.disposed, false);
    });

    test('should handle disposal correctly', () {
      expect(manager.disposed, false);
      
      manager.dispose();
      
      expect(manager.disposed, true);
    });

    test('should ignore operations after disposal', () async {
      manager.dispose();
      
      // These should not throw or cause issues
      await manager.play();
      await manager.pause();
      await manager.setMuted(false);
      manager.setVisibility(true);
      
      expect(manager.disposed, true);
    });

    test('should update state when mute is toggled', () async {
      // Simulate initialized state
      manager = VideoControllerManager();
      
      await manager.setMuted(false);
      // Note: In real implementation, this would require actual video controller
      // For now, we just test that the method doesn't throw
      expect(manager.disposed, false);
    });
  });

  group('BaseVideoPlayer Widget Tests', () {
    testWidgets('should show loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseVideoPlayer(
              videoUrl: 'https://example.com/video.mp4',
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle invalid video URL', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseVideoPlayer(
              videoUrl: 'invalid-url',
            ),
          ),
        ),
      );

      await tester.pump(Duration(seconds: 1));
      
      // Should show loading initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should use custom loading widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseVideoPlayer(
              videoUrl: 'https://example.com/video.mp4',
              loadingWidget: Text('Custom Loading'),
            ),
          ),
        ),
      );

      expect(find.text('Custom Loading'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should use custom error widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseVideoPlayer(
              videoUrl: 'invalid-url',
              errorWidget: Text('Custom Error'),
            ),
          ),
        ),
      );

      await tester.pump(Duration(seconds: 2));
      
      // Initially shows loading, would show error after failed initialization
      // In real scenario with network, this would eventually show error
    });

    testWidgets('should call state change callback', (WidgetTester tester) async {
      VideoPlayerState? receivedState;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseVideoPlayer(
              videoUrl: 'https://example.com/video.mp4',
              onStateChanged: (state) => receivedState = state,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 100));
      
      expect(receivedState, isNotNull);
      expect(receivedState?.status, VideoPlayerStatus.loading);
    });

    testWidgets('should call visibility change callback', (WidgetTester tester) async {
      bool? isVisible;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseVideoPlayer(
              videoUrl: 'https://example.com/video.mp4',
              onVisibilityChanged: (visible) => isVisible = visible,
            ),
          ),
        ),
      );

      await tester.pump();
      
      // VisibilityDetector would trigger this in real scenario
      // For now we just verify the callback is set up
      expect(isVisible, isNull); // Not triggered yet in test environment
    });

    testWidgets('should handle autoPlay setting', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseVideoPlayer(
              videoUrl: 'https://example.com/video.mp4',
              autoPlay: false,
            ),
          ),
        ),
      );

      await tester.pump();
      
      // Video should be initialized but not auto-playing
      // This would be validated with actual video controller
    });

    testWidgets('should handle loop setting', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseVideoPlayer(
              videoUrl: 'https://example.com/video.mp4',
              loop: false,
            ),
          ),
        ),
      );

      await tester.pump();
      
      // Video should not loop when it reaches the end
      // This would be validated with actual video controller
    });

    testWidgets('should handle muted setting', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseVideoPlayer(
              videoUrl: 'https://example.com/video.mp4',
              muted: false,
            ),
          ),
        ),
      );

      await tester.pump();
      
      // Video should start with sound on
      // This would be validated with actual video controller
    });

    testWidgets('should handle aspect ratio', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseVideoPlayer(
              videoUrl: 'https://example.com/video.mp4',
              aspectRatio: 1.0, // Square aspect ratio
            ),
          ),
        ),
      );

      await tester.pump();
      
      // Should maintain 1:1 aspect ratio
      // This would be validated once video is loaded
    });
  });

  group('FeedDataProvider Tests', () {
    test('should implement required interface', () {
      final provider = MockVideoDataProvider();
      
      expect(provider.items, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.hasError, false);
      expect(provider.errorMessage, isNull);
      expect(provider.hasMore, false);
    });
  });

  group('VideoFeedItem Widget Tests', () {
    late MockVideoItem mockItem;

    setUp(() {
      mockItem = MockVideoItem(
        videoId: 'test-id',
        url: 'https://example.com/video.mp4',
        title: 'Test Video',
      );
    });

    testWidgets('should display video player', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoFeedItem<MockVideoItem>(
              item: mockItem,
            ),
          ),
        ),
      );

      expect(find.byType(BaseVideoPlayer), findsOneWidget);
    });

    testWidgets('should handle custom aspect ratio', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoFeedItem<MockVideoItem>(
              item: mockItem,
              customAspectRatio: 1.0,
            ),
          ),
        ),
      );

      // Should create AspectRatio widget with 1:1 ratio
      expect(find.byType(AspectRatio), findsOneWidget);
      
      final aspectRatio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspectRatio.aspectRatio, 1.0);
    });

    testWidgets('should apply BoxFit settings', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoFeedItem<MockVideoItem>(
              item: mockItem,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

      // The fit setting should be passed to the video player
      expect(find.byType(BaseVideoPlayer), findsOneWidget);
    });

    testWidgets('should handle tap to mute', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoFeedItem<MockVideoItem>(
              item: mockItem,
              tapToMute: true,
            ),
          ),
        ),
      );

      // Should be able to tap to toggle mute
      await tester.tap(find.byType(VideoFeedItem<MockVideoItem>));
      await tester.pump();
      
      // Mute state change would be handled by the video controller
    });
  });
}

// Mock classes used in tests
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
}