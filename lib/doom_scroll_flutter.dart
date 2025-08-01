/// A highly modular, customizable TikTok-like video player for Flutter applications.
/// 
/// Features vertical scrolling, auto-play, mute controls, customizable overlays, 
/// and flexible video dimensions. Perfect for creating engaging video feeds.
library doom_scroll_flutter;

// Core video player components
export 'src/core/base_video_player.dart';
export 'src/core/video_controller_manager.dart';
export 'src/core/video_player_state.dart';

// Overlay components
export 'src/overlays/video_controls_overlay.dart';
export 'src/overlays/video_info_overlay.dart';
export 'src/overlays/video_actions_overlay.dart';
export 'src/overlays/video_loading_overlay.dart';

// Feed management
export 'src/feed/feed_data_provider.dart';
export 'src/feed/video_feed_item.dart';
export 'src/feed/video_feed_container.dart';

// Main convenience widget
export 'src/doom_scroll_video_player.dart';