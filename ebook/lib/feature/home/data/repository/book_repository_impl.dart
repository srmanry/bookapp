import "package:libararybd/core/network/api_client.dart";
import "package:libararybd/core/network/api_endpoint.dart";
import "package:libararybd/feature/home/data/model/book_model.dart";
import "package:libararybd/feature/home/domain/repository/book_repository.dart";

class BookRepositoryImpl implements IBookRepository {
  final ApiClient _apiClient;

  BookRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<String>> fetchCategories() async {
    final response = await _apiClient.get(ApiEndpoint.categories);
    final rawList = response["categories"] as List<dynamic>? ?? <dynamic>[];
    return rawList
        .map((item) => item.toString())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  @override
  Future<List<BookModel>> fetchBooks({String? query, String? category}) async {
    final queryParameters = <String, String>{};
    if (query != null && query.trim().isNotEmpty) {
      queryParameters["q"] = query.trim();
    }
    if (category != null && category.trim().isNotEmpty && category != "All") {
      queryParameters["category"] = category.trim();
    }

    final response = await _apiClient.get(
      ApiEndpoint.books,
      queryParameters: queryParameters,
    );

    final rawList = response["books"] as List<dynamic>? ?? <dynamic>[];
    return rawList
        .whereType<Map<String, dynamic>>()
        .map(BookModel.fromJson)
        .toList();
  }

  @override
  List<String> get fallbackCategories => const <String>[
        "Health",
        "Religion",
        "Academic",
        "Sports",
        "Programming",
      ];

  @override
  List<BookModel> get fallbackBooks => const <BookModel>[
        BookModel(
          id: "local-1",
          title: "Flutter for Beginners",
          authorName: "Demo Author",
          category: "Programming",
          coverUrl:
              "https://m.media-amazon.com/images/I/91h29Crb4LL._AC_UF1000,1000_QL80_.jpg",
          fileUrl: "assets/pdf/english.pdf",
          fileFormat: BookFormat.pdf,
        ),
        BookModel(
          id: "local-2",
          title: "Daily Health Habits",
          authorName: "Wellness Team",
          category: "Health",
          coverUrl:
              "https://m.media-amazon.com/images/I/81l3rZK4lnL._SL1500_.jpg",
          fileUrl: "assets/pdf/english.pdf",
          fileFormat: BookFormat.pdf,
        ),
        BookModel(
          id: "local-3",
          title: "Sports Psychology",
          authorName: "Performance Lab",
          category: "Sports",
          coverUrl:
              "https://m.media-amazon.com/images/I/61M5J4aM-aL._SL1500_.jpg",
          fileUrl: "assets/pdf/english.pdf",
          fileFormat: BookFormat.pdf,
        ),
        BookModel(
          id: "local-4",
          title: "Academic Writing 101",
          authorName: "Writing Team",
          category: "Academic",
          coverUrl:
              "https://m.media-amazon.com/images/I/71vMGRog+iL._SL1360_.jpg",
          fileUrl: "assets/pdf/english.pdf",
          fileFormat: BookFormat.pdf,
        ),
      ];
}
