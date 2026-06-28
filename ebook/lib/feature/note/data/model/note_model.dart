class NoteModel {
  final String id;
  final String bookId;
  final String text;

  const NoteModel({
    required this.id,
    required this.bookId,
    required this.text,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json["id"]?.toString() ?? "",
      bookId: json["bookId"]?.toString() ?? "",
      text: json["text"]?.toString() ?? "",
    );
  }
}
