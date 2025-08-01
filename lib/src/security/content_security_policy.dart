/// Content Security Policy configuration for video content
class ContentSecurityPolicy {
  /// Maximum file size for video content (in bytes)
  static int maxVideoFileSize = 100 * 1024 * 1024; // 100MB default
  
  /// Maximum video duration (in seconds)
  static int maxVideoDuration = 300; // 5 minutes default
  
  /// Allowed MIME types for video content
  static Set<String> allowedMimeTypes = {
    'video/mp4',
    'video/webm',
    'video/ogg',
    'video/quicktime',
    'video/x-msvideo',
    'video/x-ms-wmv',
  };
  
  /// Rate limiting configuration
  static int maxRequestsPerMinute = 60;
  static int maxConcurrentConnections = 10;
  
  /// Content validation flags
  static bool validateContentLength = true;
  static bool validateMimeType = false;
  static bool enableRateLimiting = false;

  /// Validates video content headers before loading
  static Future<SecurityValidationResult> validateVideoHeaders({
    required String url,
    Map<String, String>? headers,
  }) async {
    try {
      // In a real implementation, you would make a HEAD request here
      // For now, we'll simulate basic header validation
      
      if (headers != null) {
        // Check Content-Length if present
        if (validateContentLength && headers.containsKey('content-length')) {
          final contentLength = int.tryParse(headers['content-length'] ?? '0') ?? 0;
          if (contentLength > maxVideoFileSize) {
            return SecurityValidationResult.error(
              'Video file size ($contentLength bytes) exceeds maximum allowed size ($maxVideoFileSize bytes)'
            );
          }
        }
        
        // Check MIME type if present and validation is enabled
        if (validateMimeType && headers.containsKey('content-type')) {
          final contentType = headers['content-type']?.toLowerCase() ?? '';
          final mimeType = contentType.split(';').first.trim();
          
          if (!allowedMimeTypes.contains(mimeType)) {
            return SecurityValidationResult.error(
              'MIME type "$mimeType" is not allowed for video content'
            );
          }
        }
      }
      
      return SecurityValidationResult.valid();
    } catch (e) {
      return SecurityValidationResult.error('Failed to validate content headers: ${e.toString()}');
    }
  }

  /// Rate limiting check (simplified implementation)
  static final Map<String, List<DateTime>> _requestHistory = {};
  
  static bool isRateLimited(String identifier) {
    if (!enableRateLimiting) return false;
    
    final now = DateTime.now();
    final requests = _requestHistory[identifier] ?? [];
    
    // Remove requests older than 1 minute
    requests.removeWhere((request) => 
      now.difference(request).inMinutes >= 1);
    
    if (requests.length >= maxRequestsPerMinute) {
      return true;
    }
    
    requests.add(now);
    _requestHistory[identifier] = requests;
    
    return false;
  }

  /// Sanitizes HTTP headers to remove potentially dangerous values
  static Map<String, String> sanitizeHeaders(Map<String, String>? headers) {
    if (headers == null) return {};
    
    final sanitized = <String, String>{};
    final dangerousHeaders = {
      'authorization',
      'cookie',
      'x-forwarded-for',
      'x-real-ip',
    };
    
    for (final entry in headers.entries) {
      final key = entry.key.toLowerCase();
      
      // Skip dangerous headers
      if (dangerousHeaders.contains(key)) {
        continue;
      }
      
      // Sanitize header values
      var value = entry.value.trim();
      
      // Remove potential XSS patterns
      value = value.replaceAll(RegExp(r'[<>"' + r"'" + r'()&]'), '');
      
      // Limit header value length
      if (value.length > 1000) {
        value = value.substring(0, 1000);
      }
      
      if (value.isNotEmpty) {
        sanitized[entry.key] = value;
      }
    }
    
    return sanitized;
  }

  /// Validates video content after loading (duration, format, etc.)
  static SecurityValidationResult validateVideoContent({
    required Duration? duration,
    required String? mimeType,
    int? fileSize,
  }) {
    // Check duration
    if (duration != null && duration.inSeconds > maxVideoDuration) {
      return SecurityValidationResult.error(
        'Video duration (${duration.inSeconds}s) exceeds maximum allowed duration (${maxVideoDuration}s)'
      );
    }
    
    // Check MIME type
    if (validateMimeType && mimeType != null) {
      if (!allowedMimeTypes.contains(mimeType.toLowerCase())) {
        return SecurityValidationResult.error(
          'Video MIME type "$mimeType" is not allowed'
        );
      }
    }
    
    // Check file size
    if (validateContentLength && fileSize != null && fileSize > maxVideoFileSize) {
      return SecurityValidationResult.error(
        'Video file size (${fileSize}B) exceeds maximum allowed size (${maxVideoFileSize}B)'
      );
    }
    
    return SecurityValidationResult.valid();
  }
  
  /// Resets rate limiting data (useful for testing)
  static void resetRateLimiting() {
    _requestHistory.clear();
  }
}

/// Result of security validation
class SecurityValidationResult {
  final bool isValid;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  const SecurityValidationResult._(this.isValid, this.errorMessage, this.metadata);

  factory SecurityValidationResult.valid([Map<String, dynamic>? metadata]) => 
      SecurityValidationResult._(true, null, metadata);
      
  factory SecurityValidationResult.error(String message, [Map<String, dynamic>? metadata]) => 
      SecurityValidationResult._(false, message, metadata);

  @override
  String toString() {
    return isValid ? 'Valid' : 'Invalid: $errorMessage';
  }
}