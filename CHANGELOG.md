# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-27

### Added
- Initial release of DoomScroll Flutter
- Core video player functionality with auto-play and mute controls
- Vertical scrolling video feed (TikTok/Instagram Reels style)  
- Modular overlay system (info, controls, actions)
- Flexible video dimension control (aspect ratio, fixed size, responsive)
- Comprehensive error handling and loading states
- Type-safe generic implementation for custom video item types
- Performance optimized with visibility detection and proper lifecycle management
- Full customization support with custom item builders
- Built-in pagination support through data providers
- Example app with multiple implementation patterns
- Comprehensive documentation and guides

### Features
- **BaseVideoPlayer**: Core video functionality with lifecycle management
- **VideoFeedContainer**: Manages vertical scrolling feed with PageView
- **VideoFeedItem**: Individual video item with overlay support
- **DoomScrollVideoPlayer**: Main convenience widget
- **Overlay Components**: 
  - VideoControlsOverlay (mute/unmute, play/pause)
  - VideoInfoOverlay (title, subtitle, description, tags)
  - VideoActionsOverlay (like, share, comment buttons)
  - VideoLoadingOverlay (loading and error states)
- **Data Management**: Abstract FeedDataProvider for flexible data loading
- **Custom Dimensions**: Support for aspect ratios, fixed dimensions, and responsive sizing
- **Error Handling**: Comprehensive error states with retry functionality
- **Performance**: Optimized for smooth scrolling and memory management

### Dependencies
- Flutter SDK: >=3.10.0
- video_player: ^2.8.2
- visibility_detector: ^0.4.0+2

## [Unreleased]

### Planned Features
- Video caching support
- Playlist management
- Advanced gesture controls (double-tap to like, etc.)
- Video effects and filters
- Picture-in-picture mode
- Offline video support
- Analytics integration
- Accessibility improvements
- Performance monitoring tools