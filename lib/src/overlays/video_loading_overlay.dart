import 'package:flutter/material.dart';

class VideoLoadingOverlay extends StatelessWidget {
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool showRetryButton;
  final Color? backgroundColor;

  const VideoLoadingOverlay({
    super.key,
    this.loadingWidget,
    this.errorWidget,
    this.errorMessage,
    this.onRetry,
    this.showRetryButton = true,
    this.backgroundColor,
  });

  Widget _buildDefaultLoadingWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading video...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultErrorWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          const Text(
            'Video failed to load',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (showRetryButton && onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor ?? Theme.of(context).colorScheme.surface,
      child: (errorWidget != null || errorMessage != null)
          ? (errorWidget ?? _buildDefaultErrorWidget(context))
          : (loadingWidget ?? _buildDefaultLoadingWidget(context)),
    );
  }
}