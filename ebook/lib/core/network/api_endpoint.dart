import "dart:io" show Platform;

class ApiEndpoint {
  ApiEndpoint._();

  static String get _host => Platform.isAndroid ? "10.0.2.2" : "127.0.0.1";
  static String get baseUrl => "http://$_host:8080/api";

  // Auth
  static const String login = "/auth/login";
  static const String signUp = "/auth/signup";

  // Books
  static const String categories = "/categories";
  static const String books = "/books";
  static String deleteBook(String bookId) => "/books/$bookId";

  // Favorites
  static String favorites(String userId) => "/users/$userId/favorites";
  static String favoriteBookIds(String userId) =>
      "/users/$userId/favorites/book-ids";

  // Notes
  static String notes(String userId) => "/users/$userId/notes";
  static String deleteNote(String userId, String noteId) =>
      "/users/$userId/notes/$noteId";

  // Profile
  static const String profile = "/profile";
  static const String updateProfile = "/profile";

  // Upload
  static const String uploadBook = "/upload/book";
  static const String uploadCover = "/upload/cover";

  // User Books
  static String userBooks(String userId) => "/users/$userId/books";
}
