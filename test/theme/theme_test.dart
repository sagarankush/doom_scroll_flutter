import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doom_scroll_flutter/doom_scroll_flutter.dart';

void main() {
  group('DoomScrollThemeData Tests', () {
    test('should create light theme', () {
      final lightTheme = DoomScrollThemeData.light();
      
      expect(lightTheme.infoTheme, isA<VideoInfoTheme>());
      expect(lightTheme.actionsTheme, isA<VideoActionsTheme>());
      expect(lightTheme.controlsTheme, isA<VideoControlsTheme>());
      expect(lightTheme.colors, isA<DoomScrollColors>());
    });

    test('should create dark theme', () {
      final darkTheme = DoomScrollThemeData.dark();
      
      expect(darkTheme.infoTheme, isA<VideoInfoTheme>());
      expect(darkTheme.actionsTheme, isA<VideoActionsTheme>());
      expect(darkTheme.controlsTheme, isA<VideoControlsTheme>());
      expect(darkTheme.colors, isA<DoomScrollColors>());
    });

    test('should support copyWith', () {
      final originalTheme = DoomScrollThemeData.light();
      final customInfoTheme = VideoInfoTheme.dark();
      
      final modifiedTheme = originalTheme.copyWith(
        infoTheme: customInfoTheme,
      );
      
      expect(modifiedTheme.infoTheme, customInfoTheme);
      expect(modifiedTheme.actionsTheme, originalTheme.actionsTheme);
      expect(modifiedTheme.controlsTheme, originalTheme.controlsTheme);
      expect(modifiedTheme.colors, originalTheme.colors);
    });
  });

  group('VideoInfoTheme Tests', () {
    test('should create light info theme', () {
      final lightTheme = VideoInfoTheme.light();
      
      expect(lightTheme.titleStyle, isA<TextStyle>());
      expect(lightTheme.subtitleStyle, isA<TextStyle>());
      expect(lightTheme.descriptionStyle, isA<TextStyle>());
      expect(lightTheme.tagStyle, isA<TextStyle>());
      expect(lightTheme.showGradient, isA<bool>());
      expect(lightTheme.gradientStartColor, isA<Color>());
      expect(lightTheme.gradientEndColor, isA<Color>());
      expect(lightTheme.tagBackgroundColor, isA<Color>());
      expect(lightTheme.padding, isA<EdgeInsets>());
    });

    test('should create dark info theme', () {
      final darkTheme = VideoInfoTheme.dark();
      
      expect(darkTheme.titleStyle, isA<TextStyle>());
      expect(darkTheme.subtitleStyle, isA<TextStyle>());
      expect(darkTheme.descriptionStyle, isA<TextStyle>());
      expect(darkTheme.tagStyle, isA<TextStyle>());
      expect(darkTheme.showGradient, isA<bool>());
      expect(darkTheme.gradientStartColor, isA<Color>());
      expect(darkTheme.gradientEndColor, isA<Color>());
      expect(darkTheme.tagBackgroundColor, isA<Color>());
      expect(darkTheme.padding, isA<EdgeInsets>());
    });

    test('should support copyWith', () {
      final originalTheme = VideoInfoTheme.light();
      const customTitleStyle = TextStyle(fontSize: 24, color: Colors.red);
      
      final modifiedTheme = originalTheme.copyWith(
        titleStyle: customTitleStyle,
        showGradient: false,
      );
      
      expect(modifiedTheme.titleStyle, customTitleStyle);
      expect(modifiedTheme.showGradient, false);
      expect(modifiedTheme.subtitleStyle, originalTheme.subtitleStyle);
    });

    test('should have different colors for light and dark themes', () {
      final lightTheme = VideoInfoTheme.light();
      final darkTheme = VideoInfoTheme.dark();
      
      expect(lightTheme.titleStyle.color, isNot(equals(darkTheme.titleStyle.color)));
      expect(lightTheme.gradientStartColor, isNot(equals(darkTheme.gradientStartColor)));
    });
  });

  group('VideoActionsTheme Tests', () {
    test('should create light actions theme', () {
      final lightTheme = VideoActionsTheme.light();
      
      expect(lightTheme.defaultIconColor, isA<Color>());
      expect(lightTheme.activeIconColor, isA<Color>());
      expect(lightTheme.backgroundColor, isA<Color>());
      expect(lightTheme.iconSize, isA<double>());
      expect(lightTheme.spacing, isA<double>());
      expect(lightTheme.padding, isA<EdgeInsets>());
      expect(lightTheme.padding, isA<EdgeInsets>());
    });

    test('should create dark actions theme', () {
      final darkTheme = VideoActionsTheme.dark();
      
      expect(darkTheme.defaultIconColor, isA<Color>());
      expect(darkTheme.activeIconColor, isA<Color>());
      expect(darkTheme.backgroundColor, isA<Color>());
      expect(darkTheme.iconSize, isA<double>());
      expect(darkTheme.spacing, isA<double>());
      expect(darkTheme.padding, isA<EdgeInsets>());
      expect(darkTheme.padding, isA<EdgeInsets>());
    });

    test('should support copyWith', () {
      final originalTheme = VideoActionsTheme.light();
      const customIconColor = Colors.blue;
      const customIconSize = 32.0;
      
      final modifiedTheme = originalTheme.copyWith(
        defaultIconColor: customIconColor,
        iconSize: customIconSize,
      );
      
      expect(modifiedTheme.defaultIconColor, customIconColor);
      expect(modifiedTheme.iconSize, customIconSize);
      expect(modifiedTheme.activeIconColor, originalTheme.activeIconColor);
      expect(modifiedTheme.backgroundColor, originalTheme.backgroundColor);
    });
  });

  group('VideoControlsTheme Tests', () {
    test('should create light controls theme', () {
      final lightTheme = VideoControlsTheme.light();
      
      expect(lightTheme.backgroundColor, isA<Color>());
      expect(lightTheme.iconColor, isA<Color>());
      expect(lightTheme.textStyle, isA<TextStyle>());
      expect(lightTheme.iconSize, isA<double>());
      expect(lightTheme.padding, isA<EdgeInsets>());
      expect(lightTheme.padding, isA<EdgeInsets>());
      expect(lightTheme.shadows, isA<List<BoxShadow>>());
    });

    test('should create dark controls theme', () {
      final darkTheme = VideoControlsTheme.dark();
      
      expect(darkTheme.backgroundColor, isA<Color>());
      expect(darkTheme.iconColor, isA<Color>());
      expect(darkTheme.textStyle, isA<TextStyle>());
      expect(darkTheme.iconSize, isA<double>());
      expect(darkTheme.padding, isA<EdgeInsets>());
      expect(darkTheme.padding, isA<EdgeInsets>());
      expect(darkTheme.shadows, isA<List<BoxShadow>>());
    });

    test('should support copyWith', () {
      final originalTheme = VideoControlsTheme.light();
      const customBackgroundColor = Colors.black;
      const customIconSize = 40.0;
      
      final modifiedTheme = originalTheme.copyWith(
        backgroundColor: customBackgroundColor,
        iconSize: customIconSize,
      );
      
      expect(modifiedTheme.backgroundColor, customBackgroundColor);
      expect(modifiedTheme.iconSize, customIconSize);
      expect(modifiedTheme.iconColor, originalTheme.iconColor);
      expect(modifiedTheme.textStyle, originalTheme.textStyle);
    });
  });

  group('DoomScrollColors Tests', () {
    test('should create light colors', () {
      final lightColors = DoomScrollColors.light();
      
      expect(lightColors, isA<DoomScrollColors>());
      // Test basic properties that should exist
      expect(lightColors.surface, isA<Color>());
      expect(lightColors.onSurface, isA<Color>());
      expect(lightColors.error, isA<Color>());
      expect(lightColors.onError, isA<Color>());
    });

    test('should create dark colors', () {
      final darkColors = DoomScrollColors.dark();
      
      expect(darkColors, isA<DoomScrollColors>());
      expect(darkColors.surface, isA<Color>());
      expect(darkColors.onSurface, isA<Color>());
      expect(darkColors.error, isA<Color>());
      expect(darkColors.onError, isA<Color>());
    });

    test('should have different colors for light and dark themes', () {
      final lightColors = DoomScrollColors.light();
      final darkColors = DoomScrollColors.dark();
      
      expect(lightColors.surface, isNot(equals(darkColors.surface)));
      expect(lightColors.onSurface, isNot(equals(darkColors.onSurface)));
    });

    test('should support copyWith', () {
      final originalColors = DoomScrollColors.light();
      const customSurface = Colors.purple;
      
      final modifiedColors = originalColors.copyWith(
        surface: customSurface,
      );
      
      expect(modifiedColors.surface, customSurface);
      expect(modifiedColors.onSurface, originalColors.onSurface);
    });
  });

  group('DoomScrollTheme Widget Tests', () {
    testWidgets('should provide theme to child widgets', (WidgetTester tester) async {
      final customTheme = DoomScrollThemeData.dark();
      
      late DoomScrollThemeData receivedTheme;
      
      await tester.pumpWidget(
        MaterialApp(
          home: DoomScrollTheme(
            data: customTheme,
            child: Builder(
              builder: (context) {
                receivedTheme = context.doomScrollTheme;
                return Container();
              },
            ),
          ),
        ),
      );
      
      expect(receivedTheme, customTheme);
    });

    testWidgets('should inherit theme from parent', (WidgetTester tester) async {
      final parentTheme = DoomScrollThemeData.light();
      
      late DoomScrollThemeData receivedTheme;
      
      await tester.pumpWidget(
        MaterialApp(
          home: DoomScrollTheme(
            data: parentTheme,
            child: DoomScrollTheme(
              data: parentTheme.copyWith(
                infoTheme: VideoInfoTheme.dark(),
              ),
              child: Builder(
                builder: (context) {
                  receivedTheme = context.doomScrollTheme;
                  return Container();
                },
              ),
            ),
          ),
        ),
      );
      
      expect(receivedTheme.infoTheme, isA<VideoInfoTheme>());
      expect(receivedTheme.actionsTheme, parentTheme.actionsTheme);
    });

    testWidgets('should use default theme when no theme provided', (WidgetTester tester) async {
      late DoomScrollThemeData receivedTheme;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              receivedTheme = context.doomScrollTheme;
              return Container();
            },
          ),
        ),
      );
      
      // Should provide a default theme
      expect(receivedTheme, isA<DoomScrollThemeData>());
    });
  });

  group('Theme Integration Tests', () {
    testWidgets('should apply theme to video info overlay', (WidgetTester tester) async {
      final customTheme = DoomScrollThemeData.light().copyWith(
        infoTheme: VideoInfoTheme.light().copyWith(
          titleStyle: TextStyle(fontSize: 24, color: Colors.red),
          showGradient: false,
        ),
      );

      const info = VideoInfoData(title: 'Test Video');

      await tester.pumpWidget(
        MaterialApp(
          home: DoomScrollTheme(
            data: customTheme,
            child: Scaffold(
              body: VideoInfoOverlay(info: info),
            ),
          ),
        ),
      );

      final titleWidget = tester.widget<Text>(find.text('Test Video'));
      expect(titleWidget.style?.fontSize, 24);
      expect(titleWidget.style?.color, Colors.red);
    });

    testWidgets('should apply theme to video actions overlay', (WidgetTester tester) async {
      final customTheme = DoomScrollThemeData.light().copyWith(
        actionsTheme: VideoActionsTheme.light().copyWith(
          defaultIconColor: Colors.blue,
          iconSize: 32,
        ),
      );

      final actions = [
        VideoActionData(
          icon: Icons.favorite,
          onTap: () {},
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: DoomScrollTheme(
            data: customTheme,
            child: Scaffold(
              body: VideoActionsOverlay(actions: actions),
            ),
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.favorite));
      expect(iconWidget.color, Colors.blue);
      expect(iconWidget.size, 32);
    });

    testWidgets('should apply theme to video controls overlay', (WidgetTester tester) async {
      final customTheme = DoomScrollThemeData.light().copyWith(
        controlsTheme: VideoControlsTheme.light().copyWith(
          iconColor: Colors.green,
          iconSize: 36,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: DoomScrollTheme(
            data: customTheme,
            child: Scaffold(
              body: VideoControlsOverlay(
                isMuted: true,
                showMuteIndicator: true,
              ),
            ),
          ),
        ),
      );

      await tester.pump(Duration(milliseconds: 100));

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.volume_off));
      expect(iconWidget.color, Colors.green);
      expect(iconWidget.size, 36);
    });
  });
}