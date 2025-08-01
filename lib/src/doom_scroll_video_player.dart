import 'package:flutter/material.dart';
import 'feed/feed_data_provider.dart';
import 'feed/video_feed_container.dart';
import 'feed/video_feed_item.dart';

/// Main convenience widget that combines all DoomScroll video player functionality.
/// 
/// This is the primary widget you'll use in your application. It provides a
/// complete TikTok-like video experience with vertical scrolling, auto-play,
/// and customizable overlays.
/// 
/// Example:
/// ```dart
/// DoomScrollVideoPlayer<MyVideoItem>(
///   dataProvider: myDataProvider,
///   infoBuilder: (item) => VideoInfoData(title: item.title),
///   actionsBuilder: (item) => [
///     VideoActionData(icon: Icons.favorite, onTap: () => like(item)),
///   ],
/// )
/// ```
class DoomScrollVideoPlayer<T extends FeedItem> extends StatelessWidget {
  /// The data provider that supplies video items
  final FeedDataProvider<T> dataProvider;
  
  /// Builder for video information overlay
  final FeedItemInfoBuilder<T>? infoBuilder;
  
  /// Builder for action buttons overlay
  final FeedItemActionsBuilder<T>? actionsBuilder;
  
  /// Custom item builder for complete layout control
  final VideoFeedItemBuilder<T>? itemBuilder;
  
  /// Whether videos should auto-play when visible
  final bool autoPlay;
  
  /// Whether videos should loop when they reach the end
  final bool loop;
  
  /// Whether videos should start muted
  final bool muted;
  
  /// Whether to show control overlays (mute button, etc.)
  final bool showControls;
  
  /// Whether to show info overlay (title, description, etc.)
  final bool showInfo;
  
  /// Whether to show action buttons overlay
  final bool showActions;
  
  /// Callback when page changes (video scrolls)
  final Function(int)? onPageChanged;

  const DoomScrollVideoPlayer({
    super.key,
    required this.dataProvider,
    this.infoBuilder,
    this.actionsBuilder,
    this.itemBuilder,
    this.autoPlay = true,
    this.loop = true,
    this.muted = true,
    this.showControls = true,
    this.showInfo = true,
    this.showActions = true,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return VideoFeedContainer<T>(
      dataProvider: dataProvider,
      infoBuilder: infoBuilder,
      actionsBuilder: actionsBuilder,
      itemBuilder: itemBuilder,
      autoPlay: autoPlay,
      loop: loop,
      muted: muted,
      showControls: showControls,
      showInfo: showInfo,
      showActions: showActions,
      onPageChanged: onPageChanged,
    );
  }
}