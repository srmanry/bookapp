import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:libararybd/core/util/custom_color.dart";
import "package:libararybd/feature/home/data/model/book_model.dart";
import "package:libararybd/feature/home/presentation/view/readbook_screen.dart";
import "package:libararybd/feature/profile/presentation/controller/your_books_controller.dart";

class YourBooksScreen extends StatefulWidget {
  const YourBooksScreen({super.key});

  @override
  State<YourBooksScreen> createState() => _YourBooksScreenState();
}

class _YourBooksScreenState extends State<YourBooksScreen> {
  final YourBooksController _yourBooksController = Get.put(YourBooksController());

  Widget _bookCover(String url) {
    if (url.isEmpty) {
      return Container(color: cardSoftColor, alignment: Alignment.center, child: const Icon(Icons.collections_bookmark_outlined, color: appColor));
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)));
      },
      errorBuilder: (_, __, ___) {
        return Container(color: cardSoftColor, alignment: Alignment.center, child: const Icon(Icons.broken_image_rounded, color: mutedTextColor));
      },
    );
  }

  Widget _bookCard(BookModel book) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.to(() => ReadBookScreenView(book: book)),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(24), border: Border.all(color: borderColor)),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
                child: SizedBox(height: 126, width: 92, child: _bookCover(book.coverUrl)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: titleColor, fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(book.authorName, style: const TextStyle(color: mutedTextColor)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: cardSoftColor, borderRadius: BorderRadius.circular(999)),
                        child: Text(book.formatLabel, style: const TextStyle(color: appColor, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () => Get.to(() => ReadBookScreenView(book: book)),
                            icon: const Icon(Icons.visibility_outlined),
                            label: const Text("Preview"),
                          ),
                          TextButton.icon(
                            onPressed: () async => await _yourBooksController.deleteBook(book.id),
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: const Text("Delete"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your books")),
      body: Obx(() {
        if (_yourBooksController.isLoading.value && _yourBooksController.books.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_yourBooksController.errorMessage.value.isNotEmpty && _yourBooksController.books.isEmpty) {
          return Center(child: Text(_yourBooksController.errorMessage.value));
        }

        return RefreshIndicator(
          onRefresh: _yourBooksController.loadBooks,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
            children: [
              if (_yourBooksController.books.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(24), border: Border.all(color: borderColor)),
                  child: const Column(
                    children: [
                      Icon(Icons.library_add_outlined, size: 42, color: mutedTextColor),
                      SizedBox(height: 12),
                      Text("You have not published any book yet", textAlign: TextAlign.center, style: TextStyle(color: titleColor, fontWeight: FontWeight.w700)),
                    ],
                  ),
                )
              else
                ..._yourBooksController.books.map(_bookCard),
            ],
          ),
        );
      }),
    );
  }
}
