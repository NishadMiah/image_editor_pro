class AppUrls {
  AppUrls._();

  static const String _baseUrl = 'http://10.0.10.135:8000/api/v1';
  static const String sendOtp = '$_baseUrl/auth/send-otp';
  static const String verifyOtp = '$_baseUrl/auth/login';

  static const String getMe = '$_baseUrl/auth/me';
  static const String guestToregular = '$_baseUrl/auth/login-guest-to-regular';

  static const String guestUsers = '$_baseUrl/auth/login-guest';
  static const String reportPost = '$_baseUrl/report';

  static const String saveAndUnsave = '$_baseUrl/like-and-save/save-unsave';
  static const String likeAndDislike = '$_baseUrl/like-and-save/like-dislike';
  static const String postDetails = '$_baseUrl/post';
  static const String notifications = '$_baseUrl/notification';
  static const String searches = '$_baseUrl/post';
  static const String updatePost = '$_baseUrl/post/update';

  //================== Nishad ==================//
  static const String getCategory = '$_baseUrl/category';
  static const String createPost = '$_baseUrl/post/create';

  static const String searchApi = '$_baseUrl/post/top-discount';

  static const String getSaveItem = '$_baseUrl/post/saved/me';
  static const String getMyPost = '$_baseUrl/post/store/me';

  static const String searchFilter = '$_baseUrl/post/search-filter';

  static const String getPrefarences = '$_baseUrl/legal-info';
  static const String getRestrictWord = '$_baseUrl/filter-word/restricted-word';


  static String getTopDiscount({String? category}) {
    final uri = Uri.parse(_baseUrl).replace(
      path: '/api/v1/post/top-discount',
      queryParameters: {
        if (category != null && category.isNotEmpty) 'category': category,
      }..removeWhere((key, value) => value == null),
    );
    return uri.toString();
  }

  static String getNareMe({
    required String? longitude,
    required String? latitude,
    String? category,
  }) {
    final uri = Uri.parse(_baseUrl).replace(
      path: '/api/v1/post/nearby',
      queryParameters: {
        'longitude': longitude,
        'latitude': latitude,
        if (category != null && category.isNotEmpty) 'category': category,
      }..removeWhere((key, value) => value == null),
    );
    return uri.toString();
  }
}
