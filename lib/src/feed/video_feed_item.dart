import 'package:flutter/material.dart';
import '../core/base_video_player.dart';
import '../core/video_player_state.dart';
import '../overlays/video_controls_overlay.dart';
import '../overlays/video_info_overlay.dart';
import '../overlays/video_actions_overlay.dart';
import '../overlays/video_loading_overlay.dart';
import '../theme/doom_scroll_theme.dart';
import 'feed_data_provider.dart';

typedef VideoFeedItemBuilder<T extends FeedItem> = Widget Function(
  BuildContext context,
  T item,
  VideoPlayerState state,
);

class VideoFeedItem<T extends FeedItem> extends StatefulWidget {
  final T item;
  final VideoInfoData? infoData;
  final List<VideoActionData>? actions;
  final bool showControls;
  final bool showInfo;
  final bool showActions;
  final bool autoPlay;
  final bool loop;
  final bool muted;
  final VoidCallback? onMuteToggle;
  final VideoFeedItemBuilder<T>? customBuilder;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double? customAspectRatio;
  final double? customWidth;
  final double? customHeight;
  final EdgeInsets? customPadding;
  final BoxFit? fit;
  final bool preserveAspectRatio;
  final bool tapToMute;

  const VideoFeedItem({
    super.key,
    required this.item,
    this.infoData,
    this.actions,
    this.showControls = true,
    this.showInfo = true,
    this.showActions = true,
    this.autoPlay = true,
    this.loop = true,
    this.muted = true,
    this.onMuteToggle,
    this.customBuilder,
    this.loadingWidget,
    this.errorWidget,
    this.customAspectRatio,
    this.customWidth,
    this.customHeight,
    this.customPadding,
    this.fit,
    this.preserveAspectRatio = true,
    this.tapToMute = true,
  });

  @override
  State<VideoFeedItem<T>> createState() => _VideoFeedItemState<T>();
}

class _VideoFeedItemState<T extends FeedItem> extends State<VideoFeedItem<T>> {
  VideoPlayerState _playerState = const VideoPlayerState();
  bool _localMuted = true;
  bool _showMuteIndicator = false;

  @override
  void initState() {
    super.initState();
    _localMuted = widget.muted;
  }

  void _onStateChanged(VideoPlayerState state) {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _playerState = state;
          });
        }
      });
    }
  }

  void _onMuteToggle() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _localMuted = !_localMuted;
            _showMuteIndicator = true;
          });
          widget.onMuteToggle?.call();
          
          // Hide indicator after a delay
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (mounted) {
              setState(() {
                _showMuteIndicator = false;
              });
            }
          });
        }
      });
    }
  }


  Widget _buildDefaultLayout() {
    final doomColors = context.doomScrollTheme.colors;
    
    Widget layout = Container(
      width: double.infinity,
      height: double.infinity,
      color: doomColors.surface,
      child: Stack(
        children: [
          // Video Player
          _buildVideoPlayerPositioned(),

          // Loading/Error Overlay
          if (_playerState.isLoading || _playerState.hasError)
            Positioned.fill(
              child: VideoLoadingOverlay(
                loadingWidget: widget.loadingWidget,
                errorWidget: widget.errorWidget,
                errorMessage: _playerState.errorMessage,
                onRetry: () {
                  // Trigger rebuild to retry video loading
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {});
                    }
                  });
                },
              ),
            ),

          // Controls Overlay
          if (widget.showControls && _playerState.isInitialized)
            Positioned.fill(
              child: VideoControlsOverlay(
                isMuted: _localMuted,
                isPlaying: _playerState.isPlaying,
                showMuteIndicator: _showMuteIndicator,
              ),
            ),

          // Info Overlay
          if (widget.showInfo && widget.infoData != null)
            VideoInfoOverlay(
              info: widget.infoData!,
              rightPadding: (widget.showActions && widget.actions != null && widget.actions!.isNotEmpty) 
                  ? 80.0 // Space for action buttons
                  : 16.0, // Normal padding
            ),

          // Actions Overlay
          if (widget.showActions && widget.actions != null)
            VideoActionsOverlay(actions: widget.actions!),
        ],
      ),
    );

    // Add tap gesture detector if tapToMute is enabled
    if (widget.tapToMute) {
      layout = GestureDetector(
        onTap: _onMuteToggle,
        child: layout,
      );
    }

    return layout;
  }

  Widget _buildVideoPlayerPositioned() {
    Widget videoPlayer = BaseVideoPlayer(
      videoUrl: widget.item.videoUrl,
      httpHeaders: widget.item.httpHeaders,
      autoPlay: widget.autoPlay,
      loop: widget.loop,
      muted: _localMuted,
      aspectRatio: widget.customAspectRatio,
      onStateChanged: _onStateChanged,
      loadingWidget: widget.loadingWidget,
      errorWidget: widget.errorWidget,
    );

    // Handle aspect ratio preservation with BoxFit (removed - causes layout issues)

    // Apply custom dimensions
    if (widget.customWidth != null || widget.customHeight != null) {
      videoPlayer = SizedBox(
        width: widget.customWidth,
        height: widget.customHeight,
        child: videoPlayer,
      );
    } else if (widget.customAspectRatio != null) {
      videoPlayer = AspectRatio(
        aspectRatio: widget.customAspectRatio!,
        child: videoPlayer,
      );
    }

    // Apply padding if specified
    if (widget.customPadding != null) {
      videoPlayer = Padding(
        padding: widget.customPadding!,
        child: videoPlayer,
      );
    }

    // If preserveAspectRatio is true and no custom dimensions, use Center without FittedBox
    if (widget.preserveAspectRatio && 
        widget.customWidth == null && 
        widget.customHeight == null && 
        widget.customAspectRatio == null &&
        widget.customPadding == null) {
      return Center(child: videoPlayer);
    }

    // If custom dimensions are specified, center the video
    if (widget.customWidth != null || 
        widget.customHeight != null || 
        widget.customAspectRatio != null || 
        widget.customPadding != null) {
      return Center(child: videoPlayer);
    }

    // Legacy behavior: use full screen (may stretch)
    return Positioned.fill(child: videoPlayer);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.item, _playerState);
    }

    return _buildDefaultLayout();
  }
}