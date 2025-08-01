import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'accessibility_config.dart';

/// Callback for keyboard actions in the video player
typedef KeyboardActionCallback = void Function(String action);

/// Widget that handles keyboard navigation for the video player
class AccessibleVideoKeyboardHandler extends StatefulWidget {
  final Widget child;
  final KeyboardActionCallback? onKeyboardAction;
  final DoomScrollAccessibilityConfig accessibilityConfig;
  final bool autofocus;

  const AccessibleVideoKeyboardHandler({
    super.key,
    required this.child,
    this.onKeyboardAction,
    this.accessibilityConfig = DoomScrollAccessibilityConfig.defaultConfig,
    this.autofocus = false,
  });

  @override
  State<AccessibleVideoKeyboardHandler> createState() => _AccessibleVideoKeyboardHandlerState();
}

class _AccessibleVideoKeyboardHandlerState extends State<AccessibleVideoKeyboardHandler> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!widget.accessibilityConfig.enableKeyboardNavigation) {
      return KeyEventResult.ignored;
    }

    if (event is KeyDownEvent) {
      final action = AccessibilityKeyboardShortcuts.getAction(event.logicalKey);
      if (action != null) {
        widget.onKeyboardAction?.call(action);
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.accessibilityConfig.enableKeyboardNavigation) {
      return widget.child;
    }

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Semantics(
        focusable: true,
        label: widget.accessibilityConfig.enableSemanticLabels
            ? AccessibilityLabels.getLabel('video_feed', widget.accessibilityConfig.customLabels)
            : 'Video feed - use keyboard shortcuts to control playback',
        hint: widget.accessibilityConfig.enableDetailedDescriptions
            ? AccessibilityKeyboardShortcuts.getHelpText()
            : null,
        child: widget.child,
      ),
    );
  }
}

/// Mixin for handling keyboard actions in video components
mixin VideoKeyboardActionHandler {
  /// Handles keyboard actions for video playback
  void handleVideoKeyboardAction(String action, {
    VoidCallback? onPlayPause,
    VoidCallback? onMute,
    ValueChanged<double>? onVolumeChange,
    ValueChanged<Duration>? onSeek,
    VoidCallback? onLike,
    VoidCallback? onShare,
    VoidCallback? onComment,
    VoidCallback? onPreviousVideo,
    VoidCallback? onNextVideo,
    VoidCallback? onFirstVideo,
    VoidCallback? onLastVideo,
  }) {
    switch (action) {
      case 'toggle_play_pause':
        onPlayPause?.call();
        break;
      case 'toggle_mute':
        onMute?.call();
        break;
      case 'volume_up':
        onVolumeChange?.call(0.1); // Increase by 10%
        break;
      case 'volume_down':
        onVolumeChange?.call(-0.1); // Decrease by 10%
        break;
      case 'seek_forward':
        onSeek?.call(const Duration(seconds: 10));
        break;
      case 'seek_backward':
        onSeek?.call(const Duration(seconds: -10));
        break;
      case 'like_video':
        onLike?.call();
        break;
      case 'share_video':
        onShare?.call();
        break;
      case 'comment_video':
        onComment?.call();
        break;
      case 'previous_video':
        onPreviousVideo?.call();
        break;
      case 'next_video':
        onNextVideo?.call();
        break;
      case 'first_video':
        onFirstVideo?.call();
        break;
      case 'last_video':
        onLastVideo?.call();
        break;
    }
  }

  /// Gets accessibility announcement for keyboard action
  String getKeyboardActionAnnouncement(String action, [Map<String, String>? customLabels]) {
    switch (action) {
      case 'toggle_play_pause':
        return AccessibilityLabels.getLabel('play_video', customLabels);
      case 'toggle_mute':
        return AccessibilityLabels.getLabel('mute_video', customLabels);
      case 'volume_up':
        return 'Volume increased';
      case 'volume_down':
        return 'Volume decreased';
      case 'seek_forward':
        return 'Seeking forward 10 seconds';
      case 'seek_backward':
        return 'Seeking backward 10 seconds';
      case 'like_video':
        return AccessibilityLabels.getLabel('like_video', customLabels);
      case 'share_video':
        return AccessibilityLabels.getLabel('share_video', customLabels);
      case 'comment_video':
        return AccessibilityLabels.getLabel('comment_video', customLabels);
      case 'previous_video':
        return AccessibilityLabels.getLabel('scroll_previous', customLabels);
      case 'next_video':
        return AccessibilityLabels.getLabel('scroll_next', customLabels);
      case 'first_video':
        return 'Navigated to first video';
      case 'last_video':
        return 'Navigated to last video';
      default:
        return 'Action performed: $action';
    }
  }
}

/// Widget that provides keyboard shortcut help overlay
class KeyboardShortcutsHelp extends StatelessWidget {
  final DoomScrollAccessibilityConfig accessibilityConfig;
  final VoidCallback? onClose;

  const KeyboardShortcutsHelp({
    super.key,
    this.accessibilityConfig = DoomScrollAccessibilityConfig.defaultConfig,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Keyboard shortcuts help',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Keyboard Shortcuts',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                if (onClose != null)
                  Semantics(
                    label: 'Close keyboard shortcuts help',
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Semantics(
              label: 'Keyboard shortcuts list',
              child: Text(
                AccessibilityKeyboardShortcuts.getHelpText(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}