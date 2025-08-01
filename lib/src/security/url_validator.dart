/// Security utilities for validating video URLs and enforcing content policies
class VideoUrlValidator {
  static const Set<String> _allowedSchemes = {'https', 'http'};
  static const Set<String> _videoExtensions = {
    'mp4', 'm4v', 'mov', 'avi', 'mkv', 'webm', 'flv', '3gp'
  };
  
  /// Configuration for URL validation
  static bool enforceHttps = true;
  static bool validateVideoExtensions = false;
  static Set<String> allowedDomains = {};
  static Set<String> blockedDomains = {};
  static int maxUrlLength = 2048;

  /// Validates a video URL for security and format compliance
  static ValidationResult validateUrl(String url) {
    if (url.isEmpty) {
      return ValidationResult.error('URL cannot be empty');
    }

    if (url.length > maxUrlLength) {
      return ValidationResult.error('URL exceeds maximum length of $maxUrlLength characters');
    }

    final Uri? uri;
    try {
      uri = Uri.parse(url);
    } catch (e) {
      return ValidationResult.error('Invalid URL format: ${e.toString()}');
    }

    // Check scheme
    if (!_allowedSchemes.contains(uri.scheme.toLowerCase())) {
      return ValidationResult.error('URL scheme "${uri.scheme}" is not allowed. Use HTTP or HTTPS.');
    }

    // Enforce HTTPS if required
    if (enforceHttps && uri.scheme.toLowerCase() != 'https') {
      return ValidationResult.error('HTTPS is required for video URLs');
    }

    // Check host
    if (uri.host.isEmpty) {
      return ValidationResult.error('URL must have a valid host');
    }

    // Domain allowlist check
    if (allowedDomains.isNotEmpty && !_isDomainAllowed(uri.host)) {
      return ValidationResult.error('Domain "${uri.host}" is not in the allowlist');
    }

    // Domain blocklist check
    if (blockedDomains.isNotEmpty && _isDomainBlocked(uri.host)) {
      return ValidationResult.error('Domain "${uri.host}" is blocked');
    }

    // Video extension validation (optional)
    if (validateVideoExtensions && !_hasValidVideoExtension(uri.path)) {
      return ValidationResult.error('URL does not appear to be a valid video file');
    }

    // Check for suspicious patterns
    final suspiciousCheck = _checkSuspiciousPatterns(url);
    if (!suspiciousCheck.isValid) {
      return suspiciousCheck;
    }

    return ValidationResult.valid();
  }

  /// Sanitizes a URL by upgrading HTTP to HTTPS if enforcement is enabled
  static String sanitizeUrl(String url) {
    if (enforceHttps && url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }

  static bool _isDomainAllowed(String host) {
    return allowedDomains.any((domain) => 
      host == domain || host.endsWith('.$domain'));
  }

  static bool _isDomainBlocked(String host) {
    return blockedDomains.any((domain) => 
      host == domain || host.endsWith('.$domain'));
  }

  static bool _hasValidVideoExtension(String path) {
    final extension = path.split('.').last.toLowerCase();
    return _videoExtensions.contains(extension);
  }

  static ValidationResult _checkSuspiciousPatterns(String url) {
    // Check for potential XSS patterns
    final suspiciousPatterns = [
      'javascript:',
      'data:',
      'vbscript:',
      '<script',
      'onload=',
      'onerror=',
    ];

    final lowerUrl = url.toLowerCase();
    for (final pattern in suspiciousPatterns) {
      if (lowerUrl.contains(pattern)) {
        return ValidationResult.error('URL contains suspicious pattern: $pattern');
      }
    }

    // Check for excessive URL encoding
    final encodedCount = RegExp(r'%[0-9a-fA-F]{2}').allMatches(url).length;
    if (encodedCount > 20) {
      return ValidationResult.error('URL contains excessive encoding which may indicate malicious content');
    }

    return ValidationResult.valid();
  }
}

/// Result of URL validation
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult._(this.isValid, this.errorMessage);

  factory ValidationResult.valid() => const ValidationResult._(true, null);
  factory ValidationResult.error(String message) => ValidationResult._(false, message);

  @override
  String toString() {
    return isValid ? 'Valid' : 'Invalid: $errorMessage';
  }
}

/// Exception thrown when a video URL fails security validation
class VideoUrlSecurityException implements Exception {
  final String message;
  final String url;

  const VideoUrlSecurityException(this.message, this.url);

  @override
  String toString() => 'VideoUrlSecurityException: $message (URL: $url)';
}