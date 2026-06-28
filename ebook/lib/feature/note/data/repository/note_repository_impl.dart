import "package:libararybd/core/network/api_client.dart";
import "package:libararybd/core/network/api_endpoint.dart";
import "package:libararybd/feature/note/data/model/note_model.dart";
import "package:libararybd/feature/note/domain/repository/note_repository.dart";

class NoteRepositoryImpl implements INoteRepository {
  final ApiClient _apiClient;

  NoteRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<NoteModel>> fetchNotes({
    required String token,
    required String userId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoint.notes(userId),
      token: token,
    );
    final rawList = response["notes"] as List<dynamic>? ?? <dynamic>[];
    return rawList
        .whereType<Map<String, dynamic>>()
        .map(NoteModel.fromJson)
        .toList();
  }

  @override
  Future<NoteModel> addNote({
    required String token,
    required String userId,
    required String bookId,
    required String text,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoint.notes(userId),
      token: token,
      body: {
        "bookId": bookId,
        "text": text.trim(),
      },
    );
    final noteJson =
        response["note"] as Map<String, dynamic>? ?? <String, dynamic>{};
    return NoteModel.fromJson(noteJson);
  }

  @override
  Future<void> deleteNote({
    required String token,
    required String userId,
    required String noteId,
  }) async {
    await _apiClient.delete(
      ApiEndpoint.deleteNote(userId, noteId),
      token: token,
    );
  }
}
