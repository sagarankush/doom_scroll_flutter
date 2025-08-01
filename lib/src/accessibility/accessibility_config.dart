import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Configuration class for accessibility features in the video player
class DoomScrollAccessibilityConfig {
  /// Whether to announce video state changes to screen readers
  final bool announceStateChanges;
  
  /// Whether to provide semantic labels for video content
  final bool enableSemanticLabels;
  
  /// Whether to enable keyboard navigation
  final bool enableKeyboardNavigation;
  
  /// Whether to provide detailed descriptions for actions
  final bool enableDetailedDescriptions;
  
  /// Whether to announce video progress updates
  final bool announceProgressUpdates;
  
  /// Interval for progress announcements (in seconds)
  final int progressAnnouncementInterval;
  
  /// Custom semantic labels for common actions
  final Map<String, String> customLabels;
  
  /// Language code for accessibility announcements
  final String languageCode;

  const DoomScrollAccessibilityConfig({
    this.announceStateChanges = true,
    this.enableSemanticLabels = true,
    this.enableKeyboardNavigation = true,
    this.enableDetailedDescriptions = true,
    this.announceProgressUpdates = false,
    this.progressAnnouncementInterval = 30,
    this.customLabels = const {},
    this.languageCode = 'en',
  });

  /// Default accessibility configuration
  static const DoomScrollAccessibilityConfig defaultConfig = DoomScrollAccessibilityConfig();

  /// High accessibility configuration with all features enabled
  static const DoomScrollAccessibilityConfig highAccessibility = DoomScrollAccessibilityConfig(
    announceStateChanges: true,
    enableSemanticLabels: true,
    enableKeyboardNavigation: true,
    enableDetailedDescriptions: true,
    announceProgressUpdates: true,
    progressAnnouncementInterval: 15,
  );

  /// Minimal accessibility configuration
  static const DoomScrollAccessibilityConfig minimal = DoomScrollAccessibilityConfig(
    announceStateChanges: false,
    enableSemanticLabels: true,
    enableKeyboardNavigation: false,
    enableDetailedDescriptions: false,
    announceProgressUpdates: false,
  );

  /// Creates a copy with modified properties
  DoomScrollAccessibilityConfig copyWith({
    bool? announceStateChanges,
    bool? enableSemanticLabels,
    bool? enableKeyboardNavigation,
    bool? enableDetailedDescriptions,
    bool? announceProgressUpdates,
    int? progressAnnouncementInterval,
    Map<String, String>? customLabels,
    String? languageCode,
  }) {
    return DoomScrollAccessibilityConfig(
      announceStateChanges: announceStateChanges ?? this.announceStateChanges,
      enableSemanticLabels: enableSemanticLabels ?? this.enableSemanticLabels,
      enableKeyboardNavigation: enableKeyboardNavigation ?? this.enableKeyboardNavigation,
      enableDetailedDescriptions: enableDetailedDescriptions ?? this.enableDetailedDescriptions,
      announceProgressUpdates: announceProgressUpdates ?? this.announceProgressUpdates,
      progressAnnouncementInterval: progressAnnouncementInterval ?? this.progressAnnouncementInterval,
      customLabels: customLabels ?? this.customLabels,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

/// Accessibility labels and messages for the video player
class AccessibilityLabels {
  static const Map<String, String> _defaultLabels = {
    // Video states
    'video_loading': 'Video is loading',
    'video_playing': 'Video is playing',
    'video_paused': 'Video is paused',
    'video_ended': 'Video has ended',
    'video_error': 'Video failed to load',
    'video_muted': 'Video is muted',
    'video_unmuted': 'Video sound is on',
    
    // Actions
    'play_video': 'Play video',
    'pause_video': 'Pause video',
    'mute_video': 'Mute video',
    'unmute_video': 'Unmute video',
    'like_video': 'Like video',
    'share_video': 'Share video',
    'comment_video': 'Comment on video',
    'scroll_next': 'Scroll to next video',
    'scroll_previous': 'Scroll to previous video',
    
    // Navigation
    'video_feed': 'Video feed',
    'video_item': 'Video item',
    'video_controls': 'Video controls',
    'video_actions': 'Video actions',
    'video_info': 'Video information',
    
    // Progress
    'video_progress': 'Video progress',
    'video_duration': 'Video duration',
    'seek_forward': 'Seek forward',
    'seek_backward': 'Seek backward',
    
    // Content
    'video_title': 'Video title',
    'video_description': 'Video description',
    'video_author': 'Video author',
    'video_tags': 'Video tags',
  };

  /// Gets a label with optional custom overrides
  static String getLabel(String key, [Map<String, String>? customLabels]) {
    return customLabels?[key] ?? _defaultLabels[key] ?? key;
  }

  /// Gets a formatted announcement for video state changes
  static String getStateAnnouncement(String state, {
    String? videoTitle,
    Duration? duration,
    Duration? position,
    Map<String, String>? customLabels,
  }) {
    final baseLabel = getLabel(state, customLabels);
    
    if (videoTitle != null) {
      switch (state) {
        case 'video_playing':
          return '$baseLabel: $videoTitle';
        case 'video_paused':
          return '$baseLabel: $videoTitle';
        case 'video_ended':
          return '$baseLabel: $videoTitle';
        default:
          return '$baseLabel: $videoTitle';
      }
    }
    
    return baseLabel;
  }

  /// Gets a progress announcement
  static String getProgressAnnouncement(Duration position, Duration duration, [Map<String, String>? customLabels]) {
    final minutes = position.inMinutes;
    final seconds = position.inSeconds % 60;
    final totalMinutes = duration.inMinutes;
    final totalSeconds = duration.inSeconds % 60;
    
    return 'Video progress: $minutes minutes $seconds seconds of $totalMinutes minutes $totalSeconds seconds';
  }
}

/// Keyboard shortcuts for video player accessibility
class AccessibilityKeyboardShortcuts {
  static final Map<LogicalKeyboardKey, String> defaultShortcuts = {
    LogicalKeyboardKey.space: 'toggle_play_pause',
    LogicalKeyboardKey.keyM: 'toggle_mute',
    LogicalKeyboardKey.arrowUp: 'volume_up',
    LogicalKeyboardKey.arrowDown: 'volume_down',
    LogicalKeyboardKey.arrowLeft: 'seek_backward',
    LogicalKeyboardKey.arrowRight: 'seek_forward',
    LogicalKeyboardKey.keyL: 'like_video',
    LogicalKeyboardKey.keyS: 'share_video',
    LogicalKeyboardKey.keyC: 'comment_video',
    LogicalKeyboardKey.pageUp: 'previous_video',
    LogicalKeyboardKey.pageDown: 'next_video',
    LogicalKeyboardKey.home: 'first_video',
    LogicalKeyboardKey.end: 'last_video',
  };

  /// Gets the action for a keyboard key
  static String? getAction(LogicalKeyboardKey key) {
    return defaultShortcuts[key];
  }

  /// Gets help text for keyboard shortcuts
  static String getHelpText() {
    return '''
Keyboard Shortcuts:
- Space: Play/Pause video
- M: Mute/Unmute video
- Arrow Up/Down: Volume control
- Arrow Left/Right: Seek backward/forward
- L: Like video
- S: Share video
- C: Comment on video
- Page Up/Down: Previous/Next video
- Home/End: First/Last video
''';
  }
}