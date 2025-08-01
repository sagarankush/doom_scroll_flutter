import 'package:flutter/material.dart';

class VideoControlsOverlay extends StatelessWidget {
  final bool isMuted;
  final bool isPlaying;
  final bool showPlayButton;
  final VoidCallback? onPlayPause;
  final VoidCallback? onMuteToggle;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsets? padding;

  const VideoControlsOverlay({
    super.key,
    this.isMuted = true,
    this.isPlaying = false,
    this.showPlayButton = false,
    this.onPlayPause,
    this.onMuteToggle,
    this.iconColor,
    this.iconSize = 24,
    this.padding = const EdgeInsets.all(8),
  });

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback? onTap,
    Color? backgroundColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.black.withValues(alpha: 0.25),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 3,
              ),
            ],
          ),
          padding: padding,
          child: Icon(
            icon,
            color: iconColor ?? Colors.white,
            size: iconSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mute/Unmute button (bottom left)
        if (onMuteToggle != null)
          Positioned(
            left: 8,
            bottom: 8,
            child: _buildControlButton(
              icon: isMuted ? Icons.volume_off : Icons.volume_up,
              onTap: onMuteToggle,
            ),
          ),

        // Play/Pause button (center)
        if (showPlayButton && onPlayPause != null)
          Center(
            child: _buildControlButton(
              icon: isPlaying ? Icons.pause : Icons.play_arrow,
              onTap: onPlayPause,
              backgroundColor: Colors.black.withValues(alpha: 0.4),
            ),
          ),
      ],
    );
  }
}