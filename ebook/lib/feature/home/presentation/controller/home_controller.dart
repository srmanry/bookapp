import "package:get/get.dart";
import "package:libararybd/core/network/api_client.dart";
import "package:libararybd/core/session/auth_session.dart";
import "package:libararybd/feature/favorite/data/repository/favorite_repository_impl.dart";
import "package:libararybd/feature/favorite/domain/repository/favorite_repository.dart";
import "package:libararybd/feature/home/data/model/book_model.dart";
import "package:libararybd/feature/home/data/repository/book_repository_impl.dart";
import "package:libararybd/feature/home/domain/repository/book_repository.dart";

class HomeController extends GetxController {
  final IBookRepository _bookRepository;
  final IFavoriteRepository _favoriteRepository;
  final AuthSession _authSession;

  HomeController({
    IBookRepository? bookRepository,
    IFavoriteRepository? favoriteRepository,
    AuthSession? authSession,
  })  : _bookRepository = bookRepository ?? BookRepositoryImpl(),
        _favoriteRepository = favoriteRepository ?? FavoriteRepositoryImpl(),
        _authSession = authSession ?? AuthSession.instance;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;
  final RxList<String> categories = <String>[].obs;
  final RxList<BookModel> books = <BookModel>[].obs;
  final RxList<String> favoriteBookIds = <String>[].obs;
  final RxString selectedCategory = "All".obs;

  String _searchQuery = "";

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    errorMessage.value = "";

    try {
      final remoteCategories = await _bookRepository.fetchCategories();
      categories.assignAll(<String>["All", ...remoteCategories]);
    } catch (_) {
      categories
          .assignAll(<String>["All", ..._bookRepository.fallbackCategories]);
      errorMessage.value = "Backend offline. Showing local book list.";
    }

    await loadBooks();
    await loadFavoriteBookIds();
    isLoading.value = false;
  }

  Future<void> loadBooks() async {
    try {
      final remoteBooks = await _bookRepository.fetchBooks(
        query: _searchQuery,
        category: selectedCategory.value,
      );
      books.assignAll(remoteBooks);
    } catch (_) {
      books.assignAll(_filterFallbackBooks());
      if (errorMessage.value.isEmpty) {
        errorMessage.value = "Backend offline. Showing local book list.";
      }
    }
  }

  Future<void> onSearchChanged(String query) async {
    _searchQuery = query;
    await loadBooks();
  }

  Future<void> onCategorySelected(String category) async {
    selectedCategory.value = category;
    await loadBooks();
  }

  Future<void> loadFavoriteBookIds() async {
    final user = _authSession.currentUser.value;
    final token = _authSession.token.value;
    if (user == null || token.isEmpty) {
      favoriteBookIds.clear();
      return;
    }

    try {
      final ids = await _favoriteRepository.fetchFavoriteBookIds(
        token: token,
        userId: user.id,
      );
      favoriteBookIds.assignAll(ids);
    } catch (_) {}
  }

  bool isFavorite(String bookId) => favoriteBookIds.contains(bookId);

  Future<void> toggleFavorite(String bookId) async {
    final user = _authSession.currentUser.value;
    final token = _authSession.token.value;
    if (user == null || token.isEmpty) return;

    try {
      final ids = await _favoriteRepository.toggleFavorite(
        token: token,
        userId: user.id,
        bookId: bookId,
      );
      favoriteBookIds.assignAll(ids);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = "Failed to update favorite.";
    }
  }

  List<BookModel> _filterFallbackBooks() {
    return _bookRepository.fallbackBooks.where((book) {
      final categoryMatches = selectedCategory.value == "All" ||
          book.category == selectedCategory.value;
      final query = _searchQuery.trim().toLowerCase();
      final queryMatches = query.isEmpty ||
          book.title.toLowerCase().contains(query) ||
          book.authorName.toLowerCase().contains(query);
      return categoryMatches && queryMatches;
    }).toList();
  }
}
