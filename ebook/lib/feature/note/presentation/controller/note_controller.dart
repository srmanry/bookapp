import "package:get/get.dart";
import "package:libararybd/core/network/api_client.dart";
import "package:libararybd/core/session/auth_session.dart";
import "package:libararybd/feature/home/data/model/book_model.dart";
import "package:libararybd/feature/home/data/repository/book_repository_impl.dart";
import "package:libararybd/feature/home/domain/repository/book_repository.dart";
import "package:libararybd/feature/note/data/model/note_model.dart";
import "package:libararybd/feature/note/data/repository/note_repository_impl.dart";
import "package:libararybd/feature/note/domain/repository/note_repository.dart";

class NoteController extends GetxController {
  final INoteRepository _noteRepository;
  final IBookRepository _bookRepository;
  final AuthSession _authSession;

  NoteController({
    INoteRepository? noteRepository,
    IBookRepository? bookRepository,
    AuthSession? authSession,
  })  : _noteRepository = noteRepository ?? NoteRepositoryImpl(),
        _bookRepository = bookRepository ?? BookRepositoryImpl(),
        _authSession = authSession ?? AuthSession.instance;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;
  final RxList<NoteModel> notes = <NoteModel>[].obs;
  final RxList<BookModel> userBooks = <BookModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll() async {
    final user = _authSession.currentUser.value;
    final token = _authSession.token.value;
    if (user == null || token.isEmpty) {
      notes.clear();
      userBooks.clear();
      errorMessage.value = "Please login to use notes.";
      return;
    }

    isLoading.value = true;
    errorMessage.value = "";

    try {
      final books = await _bookRepository.fetchBooks();
      userBooks.assignAll(books);

      final userNotes = await _noteRepository.fetchNotes(
        token: token,
        userId: user.id,
      );
      notes.assignAll(userNotes);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = "Failed to load notes.";
    } finally {
      isLoading.value = false;
    }
  }

  String findBookTitle(String bookId) {
    final match = userBooks.firstWhereOrNull((book) => book.id == bookId);
    return match?.title ?? "Unknown Book";
  }

  Future<bool> addNote({
    required String bookId,
    required String text,
  }) async {
    final user = _authSession.currentUser.value;
    final token = _authSession.token.value;
    if (user == null || token.isEmpty) return false;
    if (bookId.isEmpty || text.trim().isEmpty) {
      errorMessage.value = "Book and note text are required.";
      return false;
    }

    try {
      final createdNote = await _noteRepository.addNote(
        token: token,
        userId: user.id,
        bookId: bookId,
        text: text,
      );
      notes.insert(0, createdNote);
      return true;
    } on ApiException catch (error) {
      errorMessage.value = error.message;
      return false;
    } catch (_) {
      errorMessage.value = "Failed to save note.";
      return false;
    }
  }

  Future<void> deleteNote(String noteId) async {
    final user = _authSession.currentUser.value;
    final token = _authSession.token.value;
    if (user == null || token.isEmpty) return;

    try {
      await _noteRepository.deleteNote(
        token: token,
        userId: user.id,
        noteId: noteId,
      );
      notes.removeWhere((note) => note.id == noteId);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = "Failed to delete note.";
    }
  }
}
