import 'package:flutter/material.dart';
import '../theme/doom_scroll_theme.dart';

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
    final doomTheme = context.doomScrollTheme.actionsTheme;
    final iconColor = action.isActive
        ? (activeIconColor ?? doomTheme.activeIconColor)
        : (action.color ?? defaultIconColor ?? doomTheme.defaultIconColor);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: action.onTap,
        child: Container(
          padding: padding ?? doomTheme.buttonPadding,
          decoration: BoxDecoration(
            color: doomTheme.backgroundColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                action.icon,
                color: iconColor,
                size: iconSize ?? doomTheme.iconSize,
              ),
              if (action.label != null) ...[
                const SizedBox(height: 4),
                Text(
                  action.label!,
                  style: labelStyle ?? doomTheme.labelStyle,
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
    
    final doomTheme = context.doomScrollTheme.actionsTheme;

    return Positioned(
      right: (padding ?? doomTheme.padding).right,
      bottom: (padding ?? doomTheme.padding).bottom,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: actions
            .map((action) => Padding(
                  padding: EdgeInsets.only(bottom: spacing ?? doomTheme.spacing),
                  child: _buildActionButton(context, action),
                ))
            .toList(),
      ),
    );
  }
}