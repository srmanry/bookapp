import "package:libararybd/feature/note/data/model/note_model.dart";

abstract class INoteRepository {
  Future<List<NoteModel>> fetchNotes({required String token, required String userId});
  Future<NoteModel> addNote({required String token, required String userId, required String bookId, required String text});
  Future<void> deleteNote({required String token, required String userId, required String noteId});
}
