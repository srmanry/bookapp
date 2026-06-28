import "package:get/get.dart";
import "package:libararybd/core/network/api_client.dart";
import "package:libararybd/core/session/auth_session.dart";
import "package:libararybd/feature/home/data/model/book_model.dart";
import "package:libararybd/feature/profile/data/repository/your_book_repository_impl.dart";
import "package:libararybd/feature/profile/domain/repository/your_book_repository.dart";

class YourBooksController extends GetxController {
  final IYourBookRepository _yourBookRepository;
  final AuthSession _authSession;

  YourBooksController({
    IYourBookRepository? yourBookRepository,
    AuthSession? authSession,
  })  : _yourBookRepository = yourBookRepository ?? YourBookRepositoryImpl(),
        _authSession = authSession ?? AuthSession.instance;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;
  final RxList<BookModel> books = <BookModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBooks();
  }

  Future<void> loadBooks() async {
    final user = _authSession.currentUser.value;
    final token = _authSession.token.value;

    if (user == null || token.isEmpty) {
      books.clear();
      errorMessage.value = "Please login first.";
      return;
    }

    isLoading.value = true;
    errorMessage.value = "";
    try {
      final myBooks = await _yourBookRepository.fetchUserBooks(
        userId: user.id,
        token: token,
      );
      books.assignAll(myBooks);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = "Failed to load your books.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBook(String bookId) async {
    final token = _authSession.token.value;
    if (token.isEmpty) return;

    try {
      await _yourBookRepository.deleteBook(token: token, bookId: bookId);
      books.removeWhere((book) => book.id == bookId);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = "Failed to delete book.";
    }
  }
}
