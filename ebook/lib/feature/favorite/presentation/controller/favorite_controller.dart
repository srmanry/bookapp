import "package:get/get.dart";
import "package:libararybd/core/network/api_client.dart";
import "package:libararybd/core/session/auth_session.dart";
import "package:libararybd/feature/favorite/data/repository/favorite_repository_impl.dart";
import "package:libararybd/feature/favorite/domain/repository/favorite_repository.dart";
import "package:libararybd/feature/home/data/model/book_model.dart";

class FavoriteController extends GetxController {
  final IFavoriteRepository _favoriteRepository;
  final AuthSession _authSession;

  FavoriteController({
    IFavoriteRepository? favoriteRepository,
    AuthSession? authSession,
  })  : _favoriteRepository = favoriteRepository ?? FavoriteRepositoryImpl(),
        _authSession = authSession ?? AuthSession.instance;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;
  final RxList<BookModel> favoriteBooks = <BookModel>[].obs;
  final RxList<String> favoriteBookIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final user = _authSession.currentUser.value;
    final token = _authSession.token.value;

    if (user == null || token.isEmpty) {
      favoriteBooks.clear();
      favoriteBookIds.clear();
      errorMessage.value = "Please login to see favorites.";
      return;
    }

    isLoading.value = true;
    errorMessage.value = "";

    try {
      final books = await _favoriteRepository.fetchFavorites(
        token: token,
        userId: user.id,
      );
      favoriteBooks.assignAll(books);
      favoriteBookIds.assignAll(books.map((book) => book.id));
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = "Failed to load favorite books.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(String bookId) async {
    final user = _authSession.currentUser.value;
    final token = _authSession.token.value;
    if (user == null || token.isEmpty) return;

    try {
      await _favoriteRepository.toggleFavorite(
        token: token,
        userId: user.id,
        bookId: bookId,
      );
      await loadFavorites();
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = "Unable to update favorite.";
    }
  }
}
