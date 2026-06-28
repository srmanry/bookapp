enum BookFormat { epub, pdf, unknown }

class BookModel {
  final String id;
  final String title;
  final String authorName;
  final String category;
  final String coverUrl;
  final String fileUrl;
  final BookFormat fileFormat;

  const BookModel({
    required this.id,
    required this.title,
    required this.authorName,
    required this.category,
    required this.coverUrl,
    required this.fileUrl,
    required this.fileFormat,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final rawFileUrl = json["fileUrl"]?.toString() ?? json["pdfUrl"]?.toString() ?? "";
    final rawFormat = json["fileFormat"]?.toString() ?? "";

    return BookModel(
      id: json["id"]?.toString() ?? "",
      title: json["title"]?.toString() ?? "Untitled",
      authorName: json["authorName"]?.toString() ?? "Unknown",
      category: json["category"]?.toString() ?? "General",
      coverUrl: json["coverUrl"]?.toString() ?? "",
      fileUrl: rawFileUrl,
      fileFormat: _parseBookFormat(rawFormat, rawFileUrl),
    );
  }

  bool get isEpub => fileFormat == BookFormat.epub;
  bool get isPdf => fileFormat == BookFormat.pdf;
  bool get hasReadableFile => fileUrl.trim().isNotEmpty;
  String get formatLabel => switch (fileFormat) {
    BookFormat.epub => "EPUB",
    BookFormat.pdf => "PDF",
    BookFormat.unknown => "FILE",
  };

  static BookFormat _parseBookFormat(String rawFormat, String fileUrl) {
    final normalizedFormat = rawFormat.trim().toLowerCase();
    if (normalizedFormat == "epub") {
      return BookFormat.epub;
    }
    if (normalizedFormat == "pdf") {
      return BookFormat.pdf;
    }

    final normalizedUrl = fileUrl.trim().toLowerCase();
    if (normalizedUrl.endsWith(".epub")) {
      return BookFormat.epub;
    }
    if (normalizedUrl.endsWith(".pdf")) {
      return BookFormat.pdf;
    }

    return BookFormat.unknown;
  }
}
