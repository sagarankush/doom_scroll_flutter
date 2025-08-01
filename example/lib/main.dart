import 'package:flutter/material.dart';
import 'package:doom_scroll_flutter/doom_scroll_flutter.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoomScroll Flutter Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DoomScroll Flutter Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ExampleCard(
            title: 'Basic Video Feed',
            description: 'Simple vertical scrolling video feed',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BasicFeedExample()),
            ),
          ),
          const SizedBox(height: 16),
          ExampleCard(
            title: 'Custom Dimensions',
            description: 'Videos with different aspect ratios and sizes',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomDimensionsExample()),
            ),
          ),
          const SizedBox(height: 16),
          ExampleCard(
            title: 'Custom Layout',
            description: 'Completely custom video item layouts',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomLayoutExample()),
            ),
          ),
        ],
      ),
    );
  }
}

class ExampleCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const ExampleCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

// Example video item implementation
class ExampleVideoItem implements FeedItem {
  final String videoId;
  final String url;
  final String title;
  final String? description;
  final String? creator;

  ExampleVideoItem({
    required this.videoId,
    required this.url,
    required this.title,
    this.description,
    this.creator,
  });

  @override
  String get id => videoId;

  @override
  String get videoUrl => url;

  @override
  Map<String, String>? get httpHeaders => null;
}

// Example data provider
class ExampleVideoDataProvider extends FeedDataProvider<ExampleVideoItem> {
  List<ExampleVideoItem> _items = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  
  @override
  List<ExampleVideoItem> get items => _items;
  
  @override
  bool get isLoading => _isLoading;
  
  @override
  bool get hasError => _hasError;
  
  @override
  String? get errorMessage => _errorMessage;
  
  @override
  bool get hasMore => false; // For simplicity

  @override
  Future<void> loadInitial() async {
    if (_isLoading) return;
    
    _setLoading(true);
    _setError(false, null);
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _items = [
        ExampleVideoItem(
          videoId: '1',
          url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          title: 'Big Buck Bunny',
          description: 'A funny 3D animated short film',
          creator: 'Blender Foundation',
        ),
        ExampleVideoItem(
          videoId: '2',
          url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          title: 'Elephants Dream',
          description: 'An open source animated film',
          creator: 'Orange Open Movie Project',
        ),
        ExampleVideoItem(
          videoId: '3',
          url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          title: 'For Bigger Blazes',
          description: 'A sample video for testing',
          creator: 'Google',
        ),
      ];
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(true, e.toString());
      _setLoading(false);
    }
  }

  @override
  Future<void> loadMore() async {
    // No pagination in this example
  }

  @override
  Future<void> refresh() async {
    _items.clear();
    await loadInitial();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(bool error, String? message) {
    _hasError = error;
    _errorMessage = message;
    notifyListeners();
  }
}

// Basic feed example
class BasicFeedExample extends StatefulWidget {
  const BasicFeedExample({super.key});

  @override
  State<BasicFeedExample> createState() => _BasicFeedExampleState();
}

class _BasicFeedExampleState extends State<BasicFeedExample> {
  late ExampleVideoDataProvider _dataProvider;

  @override
  void initState() {
    super.initState();
    _dataProvider = ExampleVideoDataProvider();
  }

  @override
  void dispose() {
    _dataProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Feed'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: DoomScrollVideoPlayer<ExampleVideoItem>(
        dataProvider: _dataProvider,
        infoBuilder: (item) => VideoInfoData(
          title: item.title,
          subtitle: item.creator,
          description: item.description,
        ),
        actionsBuilder: (item) => [
          VideoActionData(
            icon: Icons.favorite_border,
            label: 'Like',
            onTap: () => _showSnackBar(context, 'Liked ${item.title}'),
          ),
          VideoActionData(
            icon: Icons.share,
            label: 'Share',
            onTap: () => _showSnackBar(context, 'Shared ${item.title}'),
          ),
          VideoActionData(
            icon: Icons.comment,
            label: 'Comment',
            onTap: () => _showSnackBar(context, 'Comment on ${item.title}'),
          ),
        ],
        onPageChanged: (index) => debugPrint('Page changed to $index'),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// Custom dimensions example
class CustomDimensionsExample extends StatefulWidget {
  const CustomDimensionsExample({super.key});

  @override
  State<CustomDimensionsExample> createState() => _CustomDimensionsExampleState();
}

class _CustomDimensionsExampleState extends State<CustomDimensionsExample> {
  late ExampleVideoDataProvider _dataProvider;

  @override
  void initState() {
    super.initState();
    _dataProvider = ExampleVideoDataProvider();
  }

  @override
  void dispose() {
    _dataProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Dimensions'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: DoomScrollVideoPlayer<ExampleVideoItem>(
        dataProvider: _dataProvider,
        infoBuilder: (item) => VideoInfoData(
          title: item.title,
          subtitle: item.creator,
        ),
        actionsBuilder: (item) => [
          VideoActionData(
            icon: Icons.favorite_border,
            onTap: () => _showSnackBar(context, 'Liked ${item.title}'),
          ),
        ],
        itemBuilder: (context, item, state) => VideoFeedItem<ExampleVideoItem>(
          item: item,
          infoData: VideoInfoData(
            title: item.title,
            subtitle: item.creator,
          ),
          actions: [
            VideoActionData(
              icon: Icons.favorite_border,
              onTap: () => _showSnackBar(context, 'Liked ${item.title}'),
            ),
          ],
          customAspectRatio: 16/9, // Widescreen format
          customPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// Custom layout example
class CustomLayoutExample extends StatefulWidget {
  const CustomLayoutExample({super.key});

  @override
  State<CustomLayoutExample> createState() => _CustomLayoutExampleState();
}

class _CustomLayoutExampleState extends State<CustomLayoutExample> {
  late ExampleVideoDataProvider _dataProvider;

  @override
  void initState() {
    super.initState();
    _dataProvider = ExampleVideoDataProvider();
  }

  @override
  void dispose() {
    _dataProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Layout'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: DoomScrollVideoPlayer<ExampleVideoItem>(
        dataProvider: _dataProvider,
        itemBuilder: (context, item, state) {
          return Container(
            color: Colors.black,
            child: Stack(
              children: [
                // Custom video player with rounded corners
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 1.0, // Square videos
                        child: BaseVideoPlayer(
                          videoUrl: item.videoUrl,
                          httpHeaders: item.httpHeaders,
                          aspectRatio: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Custom info overlay at the top
                Positioned(
                  top: 60,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (item.creator != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'by ${item.creator}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                // Custom action buttons at the bottom
                Positioned(
                  bottom: 40,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCustomActionButton(
                        Icons.favorite,
                        'Like',
                        Colors.red,
                        () => _showSnackBar(context, 'Liked ${item.title}'),
                      ),
                      _buildCustomActionButton(
                        Icons.share,
                        'Share',
                        Colors.blue,
                        () => _showSnackBar(context, 'Shared ${item.title}'),
                      ),
                      _buildCustomActionButton(
                        Icons.bookmark,
                        'Save',
                        Colors.green,
                        () => _showSnackBar(context, 'Saved ${item.title}'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}