import 'package:flutter/material.dart';
import '../overlays/video_info_overlay.dart';
import '../overlays/video_actions_overlay.dart';
import 'feed_data_provider.dart';
import 'video_feed_item.dart';

typedef FeedItemInfoBuilder<T extends FeedItem> = VideoInfoData? Function(T item);
typedef FeedItemActionsBuilder<T extends FeedItem> = List<VideoActionData>? Function(T item);
typedef FeedErrorBuilder = Widget Function(BuildContext context, String? error, VoidCallback? onRetry);
typedef FeedLoadingBuilder = Widget Function(BuildContext context);
typedef FeedEmptyBuilder = Widget Function(BuildContext context);

class VideoFeedContainer<T extends FeedItem> extends StatefulWidget {
  final FeedDataProvider<T> dataProvider;
  final FeedItemInfoBuilder<T>? infoBuilder;
  final FeedItemActionsBuilder<T>? actionsBuilder;
  final VideoFeedItemBuilder<T>? itemBuilder;
  final FeedErrorBuilder? errorBuilder;
  final FeedLoadingBuilder? loadingBuilder;
  final FeedEmptyBuilder? emptyBuilder;
  final bool autoPlay;
  final bool loop;
  final bool muted;
  final bool showControls;
  final bool showInfo;
  final bool showActions;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final PageController? pageController;
  final Function(int)? onPageChanged;
  final double preloadThreshold;

  const VideoFeedContainer({
    super.key,
    required this.dataProvider,
    this.infoBuilder,
    this.actionsBuilder,
    this.itemBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.autoPlay = true,
    this.loop = true,
    this.muted = true,
    this.showControls = true,
    this.showInfo = true,
    this.showActions = true,
    this.padding,
    this.physics,
    this.pageController,
    this.onPageChanged,
    this.preloadThreshold = 0.8,
  });

  @override
  State<VideoFeedContainer<T>> createState() => _VideoFeedContainerState<T>();
}

class _VideoFeedContainerState<T extends FeedItem> extends State<VideoFeedContainer<T>> {
  late PageController _pageController;
  bool _globalMuted = true;

  @override
  void initState() {
    super.initState();
    _pageController = widget.pageController ?? PageController();
    _globalMuted = widget.muted;
    _loadInitialData();
  }

  @override
  void dispose() {
    if (widget.pageController == null) {
      _pageController.dispose();
    }
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    if (widget.dataProvider.items.isEmpty && !widget.dataProvider.isLoading) {
      await widget.dataProvider.loadInitial();
    }
  }

  void _onPageChanged(int index) {
    widget.onPageChanged?.call(index);
    
    // Load more data when approaching the end
    final totalItems = widget.dataProvider.items.length;
    if (index >= (totalItems * widget.preloadThreshold) && 
        widget.dataProvider.hasMore && 
        !widget.dataProvider.isLoading) {
      widget.dataProvider.loadMore();
    }
  }

  void _onGlobalMuteToggle() {
    setState(() {
      _globalMuted = !_globalMuted;
    });
  }

  Widget _buildErrorState() {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder!(
        context,
        widget.dataProvider.errorMessage,
        () => widget.dataProvider.refresh(),
      );
    }

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
          Text(
            'Failed to load videos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.dataProvider.errorMessage ?? 'Please check your connection and try again',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => widget.dataProvider.refresh(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    if (widget.loadingBuilder != null) {
      return widget.loadingBuilder!(context);
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyState() {
    if (widget.emptyBuilder != null) {
      return widget.emptyBuilder!(context);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No videos available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new content',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedItem(T item) {
    return VideoFeedItem<T>(
      item: item,
      infoData: widget.infoBuilder?.call(item),
      actions: widget.actionsBuilder?.call(item),
      showControls: widget.showControls,
      showInfo: widget.showInfo,
      showActions: widget.showActions,
      autoPlay: widget.autoPlay,
      loop: widget.loop,
      muted: _globalMuted,
      onMuteToggle: _onGlobalMuteToggle,
      customBuilder: widget.itemBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.dataProvider,
      builder: (context, child) {
        if (widget.dataProvider.hasError && widget.dataProvider.items.isEmpty) {
          return _buildErrorState();
        }

        if (widget.dataProvider.isLoading && widget.dataProvider.items.isEmpty) {
          return _buildLoadingState();
        }

        if (widget.dataProvider.items.isEmpty && !widget.dataProvider.isLoading) {
          return _buildEmptyState();
        }

        return PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          physics: widget.physics,
          onPageChanged: _onPageChanged,
          itemCount: widget.dataProvider.items.length,
          itemBuilder: (context, index) {
            final item = widget.dataProvider.items[index];
            return Padding(
              padding: widget.padding ?? EdgeInsets.zero,
              child: _buildFeedItem(item),
            );
          },
        );
      },
    );
  }
}