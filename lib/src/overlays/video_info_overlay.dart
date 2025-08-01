import 'package:flutter/material.dart';

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

  const VideoInfoOverlay({
    super.key,
    required this.info,
    this.padding = const EdgeInsets.all(16),
    this.maxWidth,
    this.maxTitleLines = 3,
    this.maxDescriptionLines = 2,
    this.titleStyle,
    this.subtitleStyle,
    this.descriptionStyle,
    this.backgroundColor,
    this.showGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final infoWidth = maxWidth ?? screenWidth * 0.6;

    return Positioned(
      left: padding?.left ?? 16,
      bottom: padding?.bottom ?? 32,
      right: padding?.right ?? 16,
      child: Container(
        decoration: showGradient
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    backgroundColor ?? Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              )
            : null,
        child: Padding(
          padding: EdgeInsets.all(showGradient ? 16 : 0),
          child: SizedBox(
            width: infoWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  info.title,
                  style: titleStyle ??
                      theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                  maxLines: maxTitleLines,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),

                // Subtitle (e.g., studio name)
                if (info.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    info.subtitle!,
                    style: subtitleStyle ??
                        theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.secondary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Description/Tags
                if (info.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    info.description!,
                    style: descriptionStyle ??
                        theme.textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
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
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '#$tag',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
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
    );
  }
}