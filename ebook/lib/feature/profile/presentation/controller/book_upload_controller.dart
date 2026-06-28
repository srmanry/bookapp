import "package:get/get.dart";
import "package:libararybd/core/network/api_client.dart";
import "package:libararybd/core/session/auth_session.dart";
import "package:libararybd/feature/home/data/repository/book_repository_impl.dart";
import "package:libararybd/feature/home/domain/repository/book_repository.dart";
import "package:libararybd/feature/profile/data/repository/book_upload_repository_impl.dart";
import "package:libararybd/feature/profile/domain/repository/book_upload_repository.dart";

class BookUploadController extends GetxController {
  final IBookUploadRepository _bookUploadRepository;
  final IBookRepository _bookRepository;
  final AuthSession _authSession;

  BookUploadController({
    IBookUploadRepository? bookUploadRepository,
    IBookRepository? bookRepository,
    AuthSession? authSession,
  })  : _bookUploadRepository =
            bookUploadRepository ?? BookUploadRepositoryImpl(),
        _bookRepository = bookRepository ?? BookRepositoryImpl(),
        _authSession = authSession ?? AuthSession.instance;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;
  final RxString uploadStatus = "".obs;
  final RxList<String> categories = <String>[].obs;

  final RxString pickedBookPath = "".obs;
  final RxString pickedBookName = "".obs;
  final RxString pickedCoverPath = "".obs;
  final RxString pickedCoverName = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final remote = await _bookRepository.fetchCategories();
      categories.assignAll(remote);
    } catch (_) {
      categories.assignAll(_bookRepository.fallbackCategories);
    }
  }

  void setBookFile(String path, String name) {
    pickedBookPath.value = path;
    pickedBookName.value = name;
  }

  void setCoverFile(String path, String name) {
    pickedCoverPath.value = path;
    pickedCoverName.value = name;
  }

  void clearFiles() {
    pickedBookPath.value = "";
    pickedBookName.value = "";
    pickedCoverPath.value = "";
    pickedCoverName.value = "";
    uploadStatus.value = "";
  }

  Future<bool> publishBook({
    required String title,
    required String authorName,
    required String category,
  }) async {
    final token = _authSession.token.value;
    if (token.isEmpty) {
      errorMessage.value = "Please login first.";
      return false;
    }

    if (title.trim().isEmpty || authorName.trim().isEmpty || category.isEmpty) {
      errorMessage.value = "Title, author, and category are required.";
      return false;
    }

    if (pickedBookPath.value.isEmpty) {
      errorMessage.value = "Please select a book file (PDF or EPUB).";
      return false;
    }

    isLoading.value = true;
    errorMessage.value = "";

    try {
      uploadStatus.value = "Uploading book file...";
      final bookResult = await _bookUploadRepository.uploadBookFile(
        token: token,
        filePath: pickedBookPath.value,
      );
      final fileUrl = bookResult["fileUrl"]?.toString() ?? "";
      final fileFormat = bookResult["fileFormat"]?.toString() ?? "unknown";

      String? coverUrl;
      if (pickedCoverPath.value.isNotEmpty) {
        uploadStatus.value = "Uploading cover image...";
        final coverResult = await _bookUploadRepository.uploadCoverImage(
          token: token,
          filePath: pickedCoverPath.value,
        );
        coverUrl = coverResult["coverUrl"]?.toString();
      }

      uploadStatus.value = "Publishing book...";
      await _bookUploadRepository.publishBook(
        token: token,
        title: title.trim(),
        authorName: authorName.trim(),
        category: category,
        fileUrl: fileUrl,
        fileFormat: fileFormat,
        coverUrl: coverUrl,
      );

      clearFiles();
      return true;
    } on ApiException catch (error) {
      errorMessage.value = error.message;
      return false;
    } catch (_) {
      errorMessage.value = "Failed to publish book.";
      return false;
    } finally {
      isLoading.value = false;
      uploadStatus.value = "";
    }
  }
}
