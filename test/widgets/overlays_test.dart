import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doom_scroll_flutter/doom_scroll_flutter.dart';

void main() {
  group('VideoInfoOverlay Widget Tests', () {
    testWidgets('should display video title', (WidgetTester tester) async {
      const info = VideoInfoData(title: 'Test Video Title');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoInfoOverlay(info: info),
          ),
        ),
      );

      expect(find.text('Test Video Title'), findsOneWidget);
    });

    testWidgets('should display subtitle when provided', (WidgetTester tester) async {
      const info = VideoInfoData(
        title: 'Test Video',
        subtitle: 'Test Creator',
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoInfoOverlay(info: info),
          ),
        ),
      );

      expect(find.text('Test Video'), findsOneWidget);
      expect(find.text('Test Creator'), findsOneWidget);
    });

    testWidgets('should display description when provided', (WidgetTester tester) async {
      const info = VideoInfoData(
        title: 'Test Video',
        description: 'This is a test video description',
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoInfoOverlay(info: info),
          ),
        ),
      );

      expect(find.text('Test Video'), findsOneWidget);
      expect(find.text('This is a test video description'), findsOneWidget);
    });

    testWidgets('should display tags when provided', (WidgetTester tester) async {
      const info = VideoInfoData(
        title: 'Test Video',
        tags: ['flutter', 'video', 'test'],
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoInfoOverlay(info: info),
          ),
        ),
      );

      expect(find.text('Test Video'), findsOneWidget);
      expect(find.text('#flutter'), findsOneWidget);
      expect(find.text('#video'), findsOneWidget);
      expect(find.text('#test'), findsOneWidget);
    });

    testWidgets('should limit tags to 3 items', (WidgetTester tester) async {
      const info = VideoInfoData(
        title: 'Test Video',
        tags: ['tag1', 'tag2', 'tag3', 'tag4', 'tag5'],
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoInfoOverlay(info: info),
          ),
        ),
      );

      expect(find.text('#tag1'), findsOneWidget);
      expect(find.text('#tag2'), findsOneWidget);
      expect(find.text('#tag3'), findsOneWidget);
      expect(find.text('#tag4'), findsNothing);
      expect(find.text('#tag5'), findsNothing);
    });

    testWidgets('should apply custom styles', (WidgetTester tester) async {
      const info = VideoInfoData(title: 'Test Video');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoInfoOverlay(
              info: info,
              titleStyle: const TextStyle(fontSize: 24, color: Colors.red),
              maxTitleLines: 2,
            ),
          ),
        ),
      );

      final titleWidget = tester.widget<Text>(find.text('Test Video'));
      expect(titleWidget.style?.fontSize, 24);
      expect(titleWidget.style?.color, Colors.red);
      expect(titleWidget.maxLines, 2);
    });

    testWidgets('should position correctly with padding', (WidgetTester tester) async {
      const info = VideoInfoData(title: 'Test Video');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: VideoInfoOverlay(
                info: info,
                padding: const EdgeInsets.all(20),
              ),
            ),
          ),
        ),
      );

      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.left, 20);
      expect(positioned.bottom, 20);
      expect(positioned.right, 20);
    });
  });

  group('VideoActionsOverlay Widget Tests', () {
    testWidgets('should display action buttons', (WidgetTester tester) async {
      final actions = [
        VideoActionData(
          icon: Icons.favorite,
          label: '100',
          onTap: () {},
        ),
        VideoActionData(
          icon: Icons.share,
          label: 'Share',
          onTap: () {},
        ),
      ];
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoActionsOverlay(actions: actions),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
    });

    testWidgets('should handle tap events', (WidgetTester tester) async {
      bool favoriteTapped = false;
      bool shareTapped = false;
      
      final actions = [
        VideoActionData(
          icon: Icons.favorite,
          onTap: () => favoriteTapped = true,
        ),
        VideoActionData(
          icon: Icons.share,
          onTap: () => shareTapped = true,
        ),
      ];
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoActionsOverlay(actions: actions),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.favorite));
      await tester.tap(find.byIcon(Icons.share));

      expect(favoriteTapped, true);
      expect(shareTapped, true);
    });

    testWidgets('should show active state', (WidgetTester tester) async {
      final actions = [
        VideoActionData(
          icon: Icons.favorite,
          isActive: true,
          color: Colors.red,
          onTap: () {},
        ),
      ];
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoActionsOverlay(actions: actions),
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.favorite));
      expect(iconWidget.color, Colors.red);
    });

    testWidgets('should handle empty actions list', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoActionsOverlay(actions: []),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(IconButton), findsNothing);
    });
  });

  group('VideoControlsOverlay Widget Tests', () {
    testWidgets('should not show mute indicator by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoControlsOverlay(),
          ),
        ),
      );

      expect(find.byIcon(Icons.volume_off), findsNothing);
      expect(find.byIcon(Icons.volume_up), findsNothing);
    });

    testWidgets('should show mute indicator when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoControlsOverlay(
              isMuted: true,
              showMuteIndicator: true,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 100)); // Allow animation to start

      expect(find.byIcon(Icons.volume_off), findsOneWidget);
      expect(find.text('Muted'), findsOneWidget);
    });

    testWidgets('should show unmute indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoControlsOverlay(
              isMuted: false,
              showMuteIndicator: true,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 100));

      expect(find.byIcon(Icons.volume_up), findsOneWidget);
      expect(find.text('Unmuted'), findsOneWidget);
    });

    testWidgets('should animate mute indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoControlsOverlay(
              isMuted: true,
              showMuteIndicator: false,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Update to show indicator
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoControlsOverlay(
              isMuted: true,
              showMuteIndicator: true,
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 150));
      
      final fadeTransition = tester.widget<FadeTransition>(find.byType(FadeTransition));
      expect(fadeTransition.opacity.value, greaterThan(0.0));
    });

    testWidgets('should apply custom styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoControlsOverlay(
              isMuted: true,
              showMuteIndicator: true,
              iconColor: Colors.blue,
              iconSize: 48,
              padding: EdgeInsets.all(16),
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 100));

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.volume_off));
      expect(iconWidget.color, Colors.blue);
      expect(iconWidget.size, 48);
    });
  });

  group('VideoLoadingOverlay Widget Tests', () {
    testWidgets('should display loading indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoLoadingOverlay(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display custom loading widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoLoadingOverlay(
              loadingWidget: Text('Custom Loading'),
            ),
          ),
        ),
      );

      expect(find.text('Custom Loading'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should display error state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoLoadingOverlay(
              errorMessage: 'Network error',
            ),
          ),
        ),
      );

      expect(find.text('Video failed to load'), findsOneWidget);
      expect(find.text('Network error'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should show retry button when error occurs', (WidgetTester tester) async {
      bool retryTapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoLoadingOverlay(
              errorMessage: 'Network error',
              onRetry: () => retryTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);
      
      await tester.tap(find.text('Retry'));
      expect(retryTapped, true);
    });

    testWidgets('should center content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: VideoLoadingOverlay(),
            ),
          ),
        ),
      );

      final center = tester.widget<Center>(find.byType(Center));
      expect(center, isNotNull);
    });
  });
}