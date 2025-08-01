# Aspect Ratio Control

Control how videos are displayed to prevent stretching and maintain visual quality.

## Overview

DoomScroll Flutter provides several options to control video aspect ratios and prevent unwanted stretching:

- **Preserve aspect ratio**: Keep original video proportions
- **Flexible fitting**: Choose how videos fit in containers
- **Custom aspect ratios**: Force specific ratios for consistency

## Prevent Video Stretching

### Default Behavior (Recommended)
```dart
DoomScrollVideoPlayer<MyVideoItem>(
  preserveAspectRatio: true,  // Default: prevents stretching
  fit: BoxFit.contain,        // Default: shows full video
  dataProvider: dataProvider,
)
```

### Fitting Options

**BoxFit.contain** (Default - Recommended)
- Shows the entire video
- Adds letterboxing if needed
- No cropping or stretching

```dart
DoomScrollVideoPlayer(
  fit: BoxFit.contain,
  // Video maintains aspect ratio with black bars if needed
)
```

**BoxFit.cover**
- Fills the entire container
- Crops video if aspect ratios don't match
- No stretching, but may lose some content

```dart
DoomScrollVideoPlayer(
  fit: BoxFit.cover,
  // Video fills screen, crops if needed
)
```

**BoxFit.fill**
- Stretches video to fill container
- May distort video if aspect ratios differ
- Use only when distortion is acceptable

```dart
DoomScrollVideoPlayer(
  fit: BoxFit.fill,
  // Video stretches to fill (may distort)
)
```

## Force Specific Aspect Ratios

### Common Aspect Ratios

```dart
DoomScrollVideoPlayer(
  itemBuilder: (context, item, state) => VideoFeedItem(
    // TikTok/Instagram Reels style (9:16)
    customAspectRatio: 9/16,
    
    // YouTube/Widescreen style (16:9)  
    customAspectRatio: 16/9,
    
    // Instagram square style (1:1)
    customAspectRatio: 1,
    
    // Custom ratio
    customAspectRatio: 4/3,
  ),
)
```

### Mixed Content Handling

For feeds with mixed landscape and portrait videos:

```dart
DoomScrollVideoPlayer(
  // Let each video use its natural aspect ratio
  preserveAspectRatio: true,
  fit: BoxFit.contain,
  
  // Or force consistency
  itemBuilder: (context, item, state) {
    // Determine aspect ratio based on content
    final isPortrait = item.height > item.width;
    return VideoFeedItem(
      customAspectRatio: isPortrait ? 9/16 : 16/9,
    );
  },
)
```

## Advanced Sizing

### Custom Dimensions with Aspect Ratio

```dart
VideoFeedItem(
  customAspectRatio: 16/9,
  customPadding: EdgeInsets.all(16),  // Add spacing around video
)
```

### Fixed Dimensions

```dart
VideoFeedItem(
  customWidth: 300,
  customHeight: 400,
  // Aspect ratio calculated automatically
)
```

### Responsive Sizing

```dart
VideoFeedItem(
  customAspectRatio: 16/9,
  customWidth: MediaQuery.of(context).size.width * 0.9,
  // Height calculated from aspect ratio
)
```

## Best Practices

### 1. Preserve Aspect Ratios
```dart
// ✅ Good - prevents stretching
DoomScrollVideoPlayer(
  preserveAspectRatio: true,
  fit: BoxFit.contain,
)

// ❌ Avoid - may stretch videos
DoomScrollVideoPlayer(
  preserveAspectRatio: false,
)
```

### 2. Choose Appropriate Fit
```dart
// ✅ For mixed content - shows everything
fit: BoxFit.contain,

// ✅ For consistent framing - crops if needed
fit: BoxFit.cover,

// ❌ Avoid unless distortion is acceptable  
fit: BoxFit.fill,
```

### 3. Consider Content Type
```dart
// For TikTok-style feeds (mostly portrait)
itemBuilder: (context, item, state) => VideoFeedItem(
  customAspectRatio: 9/16,
),

// For YouTube-style feeds (mostly landscape)
itemBuilder: (context, item, state) => VideoFeedItem(
  customAspectRatio: 16/9,
),

// For mixed content feeds
preserveAspectRatio: true,
fit: BoxFit.contain,
```

## Common Issues

### Videos Appear Stretched
**Problem**: Videos look distorted or elongated
**Solution**: Enable aspect ratio preservation
```dart
DoomScrollVideoPlayer(
  preserveAspectRatio: true,  // Add this
  fit: BoxFit.contain,        // Add this
)
```

### Black Bars Around Videos
**Problem**: Unwanted letterboxing
**Solution**: Use BoxFit.cover or force aspect ratio
```dart
// Option 1: Crop to fill
DoomScrollVideoPlayer(
  fit: BoxFit.cover,
)

// Option 2: Force consistent ratio
itemBuilder: (context, item, state) => VideoFeedItem(
  customAspectRatio: 16/9,  // Matches your design
),
```

### Inconsistent Video Sizes
**Problem**: Videos have different sizes in feed
**Solution**: Force consistent aspect ratio
```dart
itemBuilder: (context, item, state) => VideoFeedItem(
  customAspectRatio: 16/9,  // All videos same ratio
),
```

## Examples

### TikTok-Style Feed
```dart
DoomScrollVideoPlayer<MyVideoItem>(
  dataProvider: dataProvider,
  preserveAspectRatio: true,
  itemBuilder: (context, item, state) => VideoFeedItem(
    customAspectRatio: 9/16,  // Portrait
    customPadding: EdgeInsets.symmetric(horizontal: 16),
  ),
)
```

### YouTube-Style Feed
```dart
DoomScrollVideoPlayer<MyVideoItem>(
  dataProvider: dataProvider,
  preserveAspectRatio: true,
  itemBuilder: (context, item, state) => VideoFeedItem(
    customAspectRatio: 16/9,  // Landscape
    customPadding: EdgeInsets.all(8),
  ),
)
```

### Instagram-Style Feed
```dart
DoomScrollVideoPlayer<MyVideoItem>(
  dataProvider: dataProvider,
  preserveAspectRatio: true,
  itemBuilder: (context, item, state) => VideoFeedItem(
    customAspectRatio: 1,  // Square
    customPadding: EdgeInsets.all(4),
  ),
)
```

### Mixed Content Feed
```dart
DoomScrollVideoPlayer<MyVideoItem>(
  dataProvider: dataProvider,
  preserveAspectRatio: true,
  fit: BoxFit.contain,  // Handles all aspect ratios
  // No custom aspect ratio - uses natural video proportions
)
```