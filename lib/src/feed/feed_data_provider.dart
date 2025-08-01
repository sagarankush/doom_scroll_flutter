import 'package:flutter/foundation.dart';

abstract class FeedItem {
  String get id;
  String get videoUrl;
  Map<String, String>? get httpHeaders;
}

abstract class FeedDataProvider<T extends FeedItem> extends ChangeNotifier {
  List<T> get items;
  bool get isLoading;
  bool get hasError;
  String? get errorMessage;
  bool get hasMore;

  Future<void> loadInitial();
  Future<void> loadMore();
  Future<void> refresh();
}