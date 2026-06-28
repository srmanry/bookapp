import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:libararybd/core/util/custom_color.dart";
import "package:libararybd/feature/favorite/presentation/controller/favorite_controller.dart";
import "package:libararybd/feature/home/data/model/book_model.dart";
import "package:libararybd/feature/home/presentation/view/readbook_screen.dart";

class FavoriteScreenView extends StatefulWidget {
  const FavoriteScreenView({super.key});

  @override
  State<FavoriteScreenView> createState() => _FavoriteScreenViewState();
}

class _FavoriteScreenViewState extends State<FavoriteScreenView> {
  final FavoriteController _favoriteController = Get.put(FavoriteController());

  Widget _bookCover(String url) {
    if (url.isEmpty) {
      return Container(
        color: cardSoftColor,
        alignment: Alignment.center,
        child: const Icon(Icons.auto_stories_rounded, color: appColor, size: 30),
      );
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

  Widget _favoriteBookCard(BookModel book) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.to(() => ReadBookScreenView(book: book)),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: cardSoftColor, borderRadius: BorderRadius.circular(999)),
                            child: Text(book.category, style: const TextStyle(color: appColor, fontSize: 11, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999), border: Border.all(color: borderColor)),
                            child: Text(book.formatLabel, style: const TextStyle(color: titleColor, fontSize: 11, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: titleColor, fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(book.authorName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: mutedTextColor, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () => Get.to(() => ReadBookScreenView(book: book)),
                            icon: const Icon(Icons.menu_book_rounded, color: appColor),
                            label: const Text("Open book"),
                          ),
                          TextButton.icon(
                            onPressed: () => _favoriteController.toggleFavorite(book.id),
                            icon: const Icon(Icons.favorite_rounded, color: dangerColor),
                            label: const Text("Remove"),
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
      body: SafeArea(
        child: Obx(() {
          if (_favoriteController.isLoading.value && _favoriteController.favoriteBooks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_favoriteController.errorMessage.value.isNotEmpty && _favoriteController.favoriteBooks.isEmpty) {
            return Center(child: Text(_favoriteController.errorMessage.value));
          }

          return RefreshIndicator(
            onRefresh: _favoriteController.loadFavorites,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
              children: [
                Text("Favorites", style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                const Text("Your saved books stay here for quick access.", style: TextStyle(color: mutedTextColor)),
                const SizedBox(height: 18),
                if (_favoriteController.favoriteBooks.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(24), border: Border.all(color: borderColor)),
                    child: const Column(
                      children: [
                        Icon(Icons.favorite_border_rounded, size: 42, color: mutedTextColor),
                        SizedBox(height: 12),
                        Text("No favorite book found", style: TextStyle(color: titleColor, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  )
                else
                  ..._favoriteController.favoriteBooks.map(_favoriteBookCard),
              ],
            ),
          );
        }),
      ),
    );
  }
}
