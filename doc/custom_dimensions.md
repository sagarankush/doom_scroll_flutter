# Custom Video Dimensions

The DoomScroll Flutter package provides flexible options for controlling video dimensions and layout.

## Overview

You can control video dimensions in several ways:

1. **Aspect Ratio** - Maintain proportions while filling available space
2. **Fixed Dimensions** - Set specific width and height in pixels
3. **Responsive Sizing** - Use screen size percentages
4. **Custom Layouts** - Complete control over video placement

## Aspect Ratio Control

### Basic Aspect Ratios

```dart
// TikTok-style vertical videos (9:16)
VideoFeedItem(
  item: item,
  customAspectRatio: 9/16,
  customPadding: EdgeInsets.all(8),
)

// Instagram-style square videos (1:1)
VideoFeedItem(
  item: item,
  customAspectRatio: 1.0,
  customPadding: EdgeInsets.all(16),
)

// YouTube-style widescreen (16:9)
VideoFeedItem(
  item: item,
  customAspectRatio: 16/9,
  customPadding: EdgeInsets.symmetric(vertical: 40),
)

// Instagram Stories style (9:16 with padding)
VideoFeedItem(
  item: item,
  customAspectRatio: 9/16,
  customPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
)
```

### Dynamic Aspect Ratios

```dart
DoomScrollVideoPlayer<MyVideoItem>(
  dataProvider: dataProvider,
  itemBuilder: (context, item, state) {
    // Choose aspect ratio based on video properties
    final aspectRatio = item.isWidescreen ? 16/9 : 9/16;
    
    return VideoFeedItem(
      item: item,
      customAspectRatio: aspectRatio,
      customPadding: const EdgeInsets.all(16),
    );
  },
)
```

## Fixed Dimensions

### Pixel-Perfect Control

```dart
// Fixed size videos
VideoFeedItem(
  item: item,
  customWidth: 300,
  customHeight: 400,
  customPadding: EdgeInsets.all(20),
)

// Responsive fixed sizes
VideoFeedItem(
  item: item,
  customWidth: MediaQuery.of(context).size.width * 0.8,
  customHeight: MediaQuery.of(context).size.height * 0.6,
  customPadding: EdgeInsets.all(16),
)
```

### Screen-Based Sizing

```dart
class ResponsiveVideoFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    
    return DoomScrollVideoPlayer<MyVideoItem>(
      dataProvider: dataProvider,
      itemBuilder: (context, item, state) => VideoFeedItem(
        item: item,
        customWidth: isTablet 
          ? screenSize.width * 0.6 
          : screenSize.width * 0.9,
        customHeight: isTablet 
          ? screenSize.height * 0.7 
          : screenSize.height * 0.8,
        customPadding: EdgeInsets.all(isTablet ? 40 : 16),
      ),
    );
  }
}
```

## Orientation-Aware Sizing

```dart
class OrientationAwareVideoFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DoomScrollVideoPlayer<MyVideoItem>(
      dataProvider: dataProvider,
      itemBuilder: (context, item, state) {
        return OrientationBuilder(
          builder: (context, orientation) {
            final isPortrait = orientation == Orientation.portrait;
            
            return VideoFeedItem(
              item: item,
              customAspectRatio: isPortrait ? 9/16 : 16/9,
              customPadding: EdgeInsets.all(isPortrait ? 8 : 40),
            );
          },
        );
      },
    );
  }
}
```

## Multiple Size Modes

```dart
enum VideoSizeMode { fullScreen, square, widescreen, compact }

class MultiSizeVideoFeed extends StatefulWidget {
  @override
  State<MultiSizeVideoFeed> createState() => _MultiSizeVideoFeedState();
}

class _MultiSizeVideoFeedState extends State<MultiSizeVideoFeed> {
  VideoSizeMode _currentMode = VideoSizeMode.fullScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoomScrollVideoPlayer<MyVideoItem>(
        dataProvider: dataProvider,
        itemBuilder: (context, item, state) => _buildVideoForMode(item, _currentMode),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _switchMode,
        child: Icon(Icons.aspect_ratio),
      ),
    );
  }

  Widget _buildVideoForMode(MyVideoItem item, VideoSizeMode mode) {
    switch (mode) {
      case VideoSizeMode.fullScreen:
        // Use default full-screen layout
        return VideoFeedItem(item: item);
        
      case VideoSizeMode.square:
        return VideoFeedItem(
          item: item,
          customAspectRatio: 1.0,
          customPadding: EdgeInsets.all(20),
        );
        
      case VideoSizeMode.widescreen:
        return VideoFeedItem(
          item: item,
          customAspectRatio: 16/9,
          customPadding: EdgeInsets.symmetric(vertical: 40),
        );
        
      case VideoSizeMode.compact:
        final screenSize = MediaQuery.of(context).size;
        return VideoFeedItem(
          item: item,
          customWidth: screenSize.width * 0.7,
          customHeight: screenSize.height * 0.5,
          customPadding: EdgeInsets.all(24),
        );
    }
  }

  void _switchMode() {
    setState(() {
      final modes = VideoSizeMode.values;
      final currentIndex = modes.indexOf(_currentMode);
      _currentMode = modes[(currentIndex + 1) % modes.length];
    });
  }
}
```

## Advanced Custom Layouts

For complete control over video layout, use a custom item builder:

```dart
DoomScrollVideoPlayer<MyVideoItem>(
  dataProvider: dataProvider,
  itemBuilder: (context, item, state) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Custom positioned video player
          Center(
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: BaseVideoPlayer(
                    videoUrl: item.videoUrl,
                    httpHeaders: item.httpHeaders,
                    aspectRatio: 1.0,
                  ),
                ),
              ),
            ),
          ),
          
          // Custom overlays positioned exactly where you want them
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: _buildCustomInfoOverlay(item),
          ),
          
          Positioned(
            bottom: 60,
            right: 20,
            child: _buildCustomActionsColumn(item),
          ),
        ],
      ),
    );
  },
)
```

## Best Practices

### Performance Considerations

1. **Use aspect ratios when possible** - More performant than fixed dimensions
2. **Avoid frequent dimension changes** - Can cause layout thrashing
3. **Consider screen density** - Use `MediaQuery.of(context).devicePixelRatio`

### User Experience

1. **Consistent sizing within a feed** - Don't mix different aspect ratios randomly
2. **Responsive padding** - Adjust padding based on screen size
3. **Test on different devices** - Ensure videos look good on various screen sizes

### Common Patterns

```dart
// Mobile-first responsive design
Widget buildResponsiveVideo(BuildContext context, MyVideoItem item) {
  final screenWidth = MediaQuery.of(context).size.width;
  
  if (screenWidth < 600) {
    // Mobile: Full width with minimal padding
    return VideoFeedItem(
      item: item,
      customAspectRatio: 9/16,
      customPadding: EdgeInsets.all(8),
    );
  } else if (screenWidth < 1200) {
    // Tablet: Centered with more padding
    return VideoFeedItem(
      item: item,
      customWidth: screenWidth * 0.7,
      customPadding: EdgeInsets.all(40),
    );
  } else {
    // Desktop: Fixed max width
    return VideoFeedItem(
      item: item,
      customWidth: 600,
      customHeight: 800,
      customPadding: EdgeInsets.all(60),
    );
  }
}
```

## Troubleshooting

### Videos appear stretched
- Check that your aspect ratio matches the video's natural aspect ratio
- Use `BoxFit.cover` for the video player to maintain proportions

### Layout jumping during loading
- Set consistent dimensions before video loads
- Use placeholder widgets with the same dimensions

### Performance issues with custom layouts
- Avoid complex calculations in build methods
- Cache dimension calculations where possible
- Use `const` constructors for static layouts