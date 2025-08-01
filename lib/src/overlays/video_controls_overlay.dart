import 'package:flutter/material.dart';
import '../theme/doom_scroll_theme.dart';

class VideoControlsOverlay extends StatefulWidget {
  final bool isMuted;
  final bool isPlaying;
  final bool showMuteIndicator;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsets? padding;

  const VideoControlsOverlay({
    super.key,
    this.isMuted = true,
    this.isPlaying = false,
    this.showMuteIndicator = false,
    this.iconColor,
    this.iconSize = 32,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  State<VideoControlsOverlay> createState() => _VideoControlsOverlayState();
}

class _VideoControlsOverlayState extends State<VideoControlsOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(VideoControlsOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showMuteIndicator && !oldWidget.showMuteIndicator) {
      _animationController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            _animationController.reverse();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildMuteIndicator(BuildContext context) {
    final doomTheme = context.doomScrollTheme.controlsTheme;
    
    return Container(
      decoration: BoxDecoration(
        color: doomTheme.backgroundColor,
        borderRadius: doomTheme.borderRadius,
        boxShadow: doomTheme.shadows,
      ),
      padding: widget.padding ?? doomTheme.padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.isMuted ? Icons.volume_off : Icons.volume_up,
            color: widget.iconColor ?? doomTheme.iconColor,
            size: widget.iconSize ?? doomTheme.iconSize,
          ),
          const SizedBox(width: 8),
          Text(
            widget.isMuted ? 'Muted' : 'Unmuted',
            style: doomTheme.textStyle,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mute/Unmute indicator (center)
        if (widget.showMuteIndicator)
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildMuteIndicator(context),
            ),
          ),
      ],
    );
  }
}