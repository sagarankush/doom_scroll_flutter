import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_player_state.dart';

class VideoControllerManager extends ChangeNotifier {
  VideoPlayerState _state = const VideoPlayerState();
  VideoPlayerController? _controller;
  StreamSubscription? _positionSubscription;
  bool _disposed = false;

  VideoPlayerState get state => _state;
  bool get disposed => _disposed;

  Future<void> initialize({
    required String videoUrl,
    Map<String, String>? httpHeaders,
    bool autoPlay = true,
    bool loop = true,
    bool muted = true,
  }) async {
    if (_disposed) return;

    try {
      _updateState(_state.copyWith(status: VideoPlayerStatus.loading));

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        httpHeaders: httpHeaders ?? {},
      );

      await _controller!.initialize();

      if (_disposed) {
        await _controller!.dispose();
        return;
      }

      if (loop) {
        await _controller!.setLooping(true);
      }

      if (muted) {
        await _controller!.setVolume(0.0);
      }

      _updateState(_state.copyWith(
        status: VideoPlayerStatus.ready,
        controller: _controller,
        isMuted: muted,
        volume: muted ? 0.0 : 1.0,
        duration: _controller!.value.duration,
      ));

      _startPositionTracking();

      if (autoPlay) {
        await play();
      }
    } catch (e) {
      if (!_disposed) {
        _updateState(_state.copyWith(
          status: VideoPlayerStatus.error,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  Future<void> play() async {
    if (_disposed || !_state.isInitialized) return;

    try {
      await _controller!.play();
      _updateState(_state.copyWith(status: VideoPlayerStatus.playing));
    } catch (e) {
      _updateState(_state.copyWith(
        status: VideoPlayerStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> pause() async {
    if (_disposed || !_state.isInitialized) return;

    try {
      await _controller!.pause();
      _updateState(_state.copyWith(status: VideoPlayerStatus.paused));
    } catch (e) {
      _updateState(_state.copyWith(
        status: VideoPlayerStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> setMuted(bool muted) async {
    if (_disposed || !_state.isInitialized) return;

    try {
      final volume = muted ? 0.0 : 1.0;
      await _controller!.setVolume(volume);
      _updateState(_state.copyWith(
        isMuted: muted,
        volume: volume,
      ));
    } catch (e) {
      // Handle mute errors gracefully
    }
  }

  Future<void> seekTo(Duration position) async {
    if (_disposed || !_state.isInitialized) return;

    try {
      await _controller!.seekTo(position);
    } catch (e) {
      // Handle seek errors gracefully
    }
  }

  void setVisibility(bool isVisible) {
    if (_disposed) return;

    _updateState(_state.copyWith(isVisible: isVisible));

    if (_state.isInitialized) {
      if (isVisible && _state.status == VideoPlayerStatus.paused) {
        play();
      } else if (!isVisible && _state.status == VideoPlayerStatus.playing) {
        pause();
      }
    }
  }

  void _startPositionTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = Stream.periodic(const Duration(milliseconds: 100))
        .listen((_) {
      if (!_disposed && _state.isInitialized) {
        _updateState(_state.copyWith(
          position: _controller!.value.position,
        ));
      }
    });
  }

  void _updateState(VideoPlayerState newState) {
    if (_disposed) return;
    _state = newState;
    
    // Use post frame callback to avoid setState during build issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_disposed) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _positionSubscription?.cancel();
    _controller?.dispose();
    super.dispose();
  }
}