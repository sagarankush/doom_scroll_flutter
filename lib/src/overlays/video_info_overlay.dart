import 'package:flutter/material.dart';
import '../theme/doom_scroll_theme.dart';

class VideoInfoData {
  final String title;
  final String? subtitle;
  final String? description;
  final List<String>? tags;

  const VideoInfoData({
    required this.title,
    this.subtitle,
    this.description,
    this.tags,
  });
}

class VideoInfoOverlay extends StatelessWidget {
  final VideoInfoData info;
  final EdgeInsets? padding;
  final double? maxWidth;
  final int? maxTitleLines;
  final int? maxDescriptionLines;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? descriptionStyle;
  final Color? backgroundColor;
  final bool showGradient;
  final double? rightPadding;

  const VideoInfoOverlay({
    super.key,
    required this.info,
    this.padding = const EdgeInsets.all(2),
    this.maxWidth,
    this.maxTitleLines = 3,
    this.maxDescriptionLines = 2,
    this.titleStyle,
    this.subtitleStyle,
    this.descriptionStyle,
    this.backgroundColor,
    this.showGradient = false,
    this.rightPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doomTheme = context.doomScrollTheme.infoTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final actionButtonsWidth = rightPadding ?? 16; // Space to reserve for action buttons
    final availableWidth = screenWidth - (padding?.left ?? 16) - actionButtonsWidth;
    final infoWidth = maxWidth ?? (availableWidth * 0.75).clamp(200.0, availableWidth);

    return Positioned(
      left: padding?.left ?? 16,
      bottom: padding?.bottom ?? 32,
      right: padding?.right ?? 16, // Keep full width for gradient
      child: Container(
        decoration: (showGradient || doomTheme.showGradient)
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    backgroundColor ?? doomTheme.gradientStartColor,
                    doomTheme.gradientEndColor,
                  ],
                ),
              )
            : null,
        child: Padding(
          padding: padding ?? doomTheme.padding,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: infoWidth,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  info.title,
                  style: titleStyle ?? doomTheme.titleStyle,
                  maxLines: maxTitleLines,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),

                // Subtitle (e.g., studio name)
                if (info.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    info.subtitle!,
                    style: subtitleStyle ?? doomTheme.subtitleStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Description/Tags
                if (info.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    info.description!,
                    style: descriptionStyle ?? doomTheme.descriptionStyle,
                    maxLines: maxDescriptionLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Tags
                if (info.tags != null && info.tags!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: info.tags!
                        .take(3) // Limit to 3 tags
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: doomTheme.tagBackgroundColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '#$tag',
                                style: doomTheme.tagStyle,
                              ),
                            ))
                        .toList(),
                  ),
                ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}