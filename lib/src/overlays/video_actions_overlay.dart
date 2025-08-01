import 'package:flutter/material.dart';

class VideoActionData {
  final IconData icon;
  final String? label;
  final VoidCallback? onTap;
  final Color? color;
  final bool isActive;

  const VideoActionData({
    required this.icon,
    this.label,
    this.onTap,
    this.color,
    this.isActive = false,
  });
}

class VideoActionsOverlay extends StatelessWidget {
  final List<VideoActionData> actions;
  final EdgeInsets? padding;
  final double? iconSize;
  final double spacing;
  final Color? defaultIconColor;
  final Color? activeIconColor;
  final TextStyle? labelStyle;

  const VideoActionsOverlay({
    super.key,
    required this.actions,
    this.padding = const EdgeInsets.all(16),
    this.iconSize = 28,
    this.spacing = 16,
    this.defaultIconColor,
    this.activeIconColor,
    this.labelStyle,
  });

  Widget _buildActionButton(BuildContext context, VideoActionData action) {
    final theme = Theme.of(context);
    final iconColor = action.isActive
        ? (activeIconColor ?? theme.colorScheme.primary)
        : (action.color ?? defaultIconColor ?? Colors.white);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: action.onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                action.icon,
                color: iconColor,
                size: iconSize,
              ),
              if (action.label != null) ...[
                const SizedBox(height: 4),
                Text(
                  action.label!,
                  style: labelStyle ??
                      theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    return Positioned(
      right: padding?.right ?? 16,
      bottom: padding?.bottom ?? 48,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: actions
            .map((action) => Padding(
                  padding: EdgeInsets.only(bottom: spacing),
                  child: _buildActionButton(context, action),
                ))
            .toList(),
      ),
    );
  }
}