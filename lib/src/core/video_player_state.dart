import 'package:video_player/video_player.dart';

enum VideoPlayerStatus {
  loading,
  ready,
  playing,
  paused,
  error,
  disposed,
}

class VideoPlayerState {
  final VideoPlayerStatus status;
  final VideoPlayerController? controller;
  final String? errorMessage;
  final bool isMuted;
  final bool isVisible;
  final double volume;
  final Duration position;
  final Duration duration;

  const VideoPlayerState({
    this.status = VideoPlayerStatus.loading,
    this.controller,
    this.errorMessage,
    this.isMuted = true,
    this.isVisible = false,
    this.volume = 1.0,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  VideoPlayerState copyWith({
    VideoPlayerStatus? status,
    VideoPlayerController? controller,
    String? errorMessage,
    bool? isMuted,
    bool? isVisible,
    double? volume,
    Duration? position,
    Duration? duration,
  }) {
    return VideoPlayerState(
      status: status ?? this.status,
      controller: controller ?? this.controller,
      errorMessage: errorMessage ?? this.errorMessage,
      isMuted: isMuted ?? this.isMuted,
      isVisible: isVisible ?? this.isVisible,
      volume: volume ?? this.volume,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }

  bool get isInitialized => controller?.value.isInitialized ?? false;
  bool get isPlaying => controller?.value.isPlaying ?? false;
  bool get hasError => status == VideoPlayerStatus.error;
  bool get isLoading => status == VideoPlayerStatus.loading;
  double get aspectRatio => controller?.value.aspectRatio ?? 16 / 9;
}