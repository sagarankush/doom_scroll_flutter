import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'video_controller_manager.dart';
import 'video_player_state.dart';

class BaseVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final Map<String, String>? httpHeaders;
  final bool autoPlay;
  final bool loop;
  final bool muted;
  final double? aspectRatio;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Function(VideoPlayerState)? onStateChanged;
  final Function(bool)? onVisibilityChanged;
  final double visibilityThreshold;

  const BaseVideoPlayer({
    super.key,
    required this.videoUrl,
    this.httpHeaders,
    this.autoPlay = true,
    this.loop = true,
    this.muted = true,
    this.aspectRatio,
    this.loadingWidget,
    this.errorWidget,
    this.onStateChanged,
    this.onVisibilityChanged,
    this.visibilityThreshold = 0.5,
  });

  @override
  State<BaseVideoPlayer> createState() => _BaseVideoPlayerState();
}

class _BaseVideoPlayerState extends State<BaseVideoPlayer> {
  late VideoControllerManager _controllerManager;
  late String _visibilityKey;

  @override
  void initState() {
    super.initState();
    _visibilityKey = 'BaseVideoPlayer_${widget.videoUrl}';
    _controllerManager = VideoControllerManager();
    _controllerManager.addListener(_onStateChanged);
    _initializeVideo();
  }

  @override
  void didUpdateWidget(BaseVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    await _controllerManager.initialize(
      videoUrl: widget.videoUrl,
      httpHeaders: widget.httpHeaders,
      autoPlay: widget.autoPlay,
      loop: widget.loop,
      muted: widget.muted,
    );
  }

  void _onStateChanged() {
    if (mounted) {
      widget.onStateChanged?.call(_controllerManager.state);
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    final isVisible = info.visibleFraction >= widget.visibilityThreshold;
    _controllerManager.setVisibility(isVisible);
    widget.onVisibilityChanged?.call(isVisible);
  }

  Widget _buildLoadingWidget() {
    return widget.loadingWidget ??
        const Center(
          child: CircularProgressIndicator(),
        );
  }

  Widget _buildErrorWidget() {
    return widget.errorWidget ??
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 8),
              Text(
                'Video failed to load',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        );
  }

  Widget _buildVideoPlayer() {
    final state = _controllerManager.state;
    final aspectRatio = widget.aspectRatio ?? state.aspectRatio;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: VideoPlayer(state.controller!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(_visibilityKey),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        child: ListenableBuilder(
          listenable: _controllerManager,
          builder: (context, child) {
            final state = _controllerManager.state;

            switch (state.status) {
              case VideoPlayerStatus.loading:
                return _buildLoadingWidget();
              case VideoPlayerStatus.error:
                return _buildErrorWidget();
              case VideoPlayerStatus.ready:
              case VideoPlayerStatus.playing:
              case VideoPlayerStatus.paused:
                return _buildVideoPlayer();
              case VideoPlayerStatus.disposed:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerManager.removeListener(_onStateChanged);
    _controllerManager.dispose();
    super.dispose();
  }
}