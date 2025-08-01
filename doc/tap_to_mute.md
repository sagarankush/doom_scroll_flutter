# Tap-to-Mute

Enable tap-anywhere-to-mute functionality with visual feedback for better user experience.

## Overview

The tap-to-mute feature allows users to toggle video audio by tapping anywhere on the video. It provides:

- **Intuitive interaction**: Tap anywhere on video to mute/unmute
- **Visual feedback**: Animated indicator shows mute status
- **Configurable**: Can be enabled/disabled as needed
- **Themeable**: Fully customizable appearance

## Basic Usage

### Enable Tap-to-Mute (Default)
```dart
DoomScrollVideoPlayer<MyVideoItem>(
  tapToMute: true,  // Default: enabled
  dataProvider: dataProvider,
)
```

### Disable Tap-to-Mute
```dart
DoomScrollVideoPlayer<MyVideoItem>(
  tapToMute: false,  // Disable tap-to-mute
  dataProvider: dataProvider,
)
```

## How It Works

### User Interaction
1. **Tap anywhere** on the video
2. **Audio toggles** between muted/unmuted
3. **Visual indicator** appears showing new state
4. **Indicator fades out** after 1.2 seconds

### Visual Feedback
The mute indicator shows:
- **Icon**: Volume off (🔇) or volume up (🔊)
- **Text**: "Muted" or "Unmuted"
- **Animation**: Smooth fade in/out
- **Positioning**: Centered over video

## Customization

### Styling with Themes

```dart
DoomScrollVideoPlayer(
  theme: DoomScrollThemeData.dark().copyWith(
    controlsTheme: VideoControlsTheme(
      // Indicator background
      backgroundColor: Colors.black87,
      
      // Icon and text color
      iconColor: Colors.white,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      
      // Icon size
      iconSize: 28,
      
      // Padding around content
      padding: EdgeInsets.all(16),
      
      // Border radius
      borderRadius: BorderRadius.circular(12),
      
      // Drop shadow
      shadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
  ),
  tapToMute: true,
  dataProvider: dataProvider,
)
```

### Light Theme Example
```dart
DoomScrollVideoPlayer(
  theme: DoomScrollThemeData.light().copyWith(
    controlsTheme: VideoControlsTheme(
      backgroundColor: Colors.white.withOpacity(0.9),
      iconColor: Colors.black87,
      textStyle: TextStyle(
        color: Colors.black87,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  tapToMute: true,
  dataProvider: dataProvider,
)
```

## Advanced Configuration

### Custom Item Builder with Tap-to-Mute
```dart
DoomScrollVideoPlayer(
  tapToMute: true,
  itemBuilder: (context, item, state) => VideoFeedItem(
    item: item,
    customAspectRatio: 16/9,
    // tapToMute is automatically inherited
  ),
  dataProvider: dataProvider,
)
```

### Conditional Tap-to-Mute
```dart
class VideoFeedPage extends StatefulWidget {
  @override
  _VideoFeedPageState createState() => _VideoFeedPageState();
}

class _VideoFeedPageState extends State<VideoFeedPage> {
  bool allowTapToMute = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch(
            value: allowTapToMute,
            onChanged: (value) => setState(() => allowTapToMute = value),
          ),
        ],
      ),
      body: DoomScrollVideoPlayer(
        tapToMute: allowTapToMute,
        dataProvider: dataProvider,
      ),
    );
  }
}
```

## User Experience Best Practices

### 1. Keep It Enabled (Recommended)
```dart
// ✅ Good - intuitive for users
DoomScrollVideoPlayer(
  tapToMute: true,
)
```

Most users expect tap-to-mute functionality in video feeds. Disabling it may confuse users familiar with TikTok, Instagram, etc.

### 2. Provide Visual Feedback
The built-in indicator provides clear feedback. Avoid removing it:

```dart
// ✅ Good - clear feedback
theme: DoomScrollThemeData.dark(),  // Includes styled indicator

// ❌ Avoid - poor user experience
// No way to hide indicator without custom implementation
```

### 3. Consider Accessibility
The tap-to-mute feature works well with accessibility tools:

```dart
DoomScrollVideoPlayer(
  tapToMute: true,
  // Indicator provides visual feedback for screen readers
  theme: DoomScrollThemeData.light().copyWith(
    controlsTheme: VideoControlsTheme(
      textStyle: TextStyle(
        fontSize: 16,  // Larger text for better visibility
      ),
    ),
  ),
)
```

## Integration Examples

### With Custom Actions
```dart
DoomScrollVideoPlayer(
  tapToMute: true,
  actionsBuilder: (item) => [
    VideoActionData(
      icon: Icons.favorite_border,
      onTap: () => _likeVideo(item),
    ),
    VideoActionData(
      icon: Icons.share,
      onTap: () => _shareVideo(item),
    ),
    // Note: No manual mute button needed - tap anywhere to mute
  ],
  dataProvider: dataProvider,
)
```

### With Info Overlay
```dart
DoomScrollVideoPlayer(
  tapToMute: true,
  infoBuilder: (item) => VideoInfoData(
    title: item.title,
    subtitle: item.creator,
    description: item.description,
  ),
  // Tap outside info area to mute/unmute
  dataProvider: dataProvider,
)
```

## Troubleshooting

### Tap Not Working
**Problem**: Tap-to-mute not responding
**Solution**: Check configuration
```dart
// Ensure it's enabled
DoomScrollVideoPlayer(
  tapToMute: true,  // Must be true
  showControls: true,  // Must be true for indicator to show
)
```

### Indicator Not Showing
**Problem**: No visual feedback on mute toggle
**Solution**: Enable controls and check theme
```dart
DoomScrollVideoPlayer(
  tapToMute: true,
  showControls: true,  // Required for indicator
  theme: DoomScrollThemeData.dark(),  // Provides styled indicator
)
```

### Conflicting Gestures
**Problem**: Tap conflicts with other interactions
**Solution**: Consider gesture hierarchy
```dart
// Tap-to-mute works with:
// - Vertical scrolling (doesn't conflict)
// - Action button taps (buttons take priority)
// - Info overlay (overlay text doesn't block taps)

// May conflict with:
// - Custom GestureDetectors on video area
// - Horizontal swipe gestures
```

## Migration from Manual Controls

### Before (Manual Mute Button)
```dart
// Old approach - manual button
actionsBuilder: (item) => [
  VideoActionData(
    icon: Icons.volume_off,
    onTap: () => toggleMute(),
  ),
],
```

### After (Tap-to-Mute)
```dart
// New approach - tap anywhere
DoomScrollVideoPlayer(
  tapToMute: true,  // No manual button needed
  actionsBuilder: (item) => [
    // Use action buttons for other functions
    VideoActionData(
      icon: Icons.favorite_border,
      onTap: () => likeVideo(item),
    ),
  ],
)
```

## Examples

### Minimal Setup
```dart
DoomScrollVideoPlayer<MyVideoItem>(
  dataProvider: dataProvider,
  tapToMute: true,  // That's it!
)
```

### With Custom Styling
```dart
DoomScrollVideoPlayer<MyVideoItem>(
  dataProvider: dataProvider,
  tapToMute: true,
  theme: DoomScrollThemeData.dark().copyWith(
    controlsTheme: VideoControlsTheme.dark().copyWith(
      backgroundColor: Colors.purple.withOpacity(0.8),
      iconColor: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
  ),
)
```

### Production Example
```dart
class VideoFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DoomScrollVideoPlayer<VideoModel>(
        dataProvider: VideoDataProvider(),
        tapToMute: true,
        preserveAspectRatio: true,
        theme: DoomScrollThemeData.dark(),
        infoBuilder: (video) => VideoInfoData(
          title: video.title,
          subtitle: '@${video.username}',
          description: video.description,
        ),
        actionsBuilder: (video) => [
          VideoActionData(
            icon: video.isLiked ? Icons.favorite : Icons.favorite_border,
            label: _formatCount(video.likeCount),
            onTap: () => _toggleLike(video),
          ),
          VideoActionData(
            icon: Icons.comment,
            label: _formatCount(video.commentCount),
            onTap: () => _showComments(video),
          ),
          VideoActionData(
            icon: Icons.share,
            label: 'Share',
            onTap: () => _shareVideo(video),
          ),
        ],
      ),
    );
  }
}
```