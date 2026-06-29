import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:libararybd/core/util/custom_color.dart";
import "package:libararybd/core/widgets/app_surfaces.dart";
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
        child: const Icon(
          Icons.auto_stories_rounded,
          color: appColor,
          size: 30,
        ),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (_, __, ___) {
        return Container(
          color: cardSoftColor,
          alignment: Alignment.center,
          child: const Icon(
            Icons.broken_image_rounded,
            color: mutedTextColor,
          ),
        );
      },
    );
  }

  Widget _favoriteBookCard(BookModel book) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.to(() => ReadBookScreenView(book: book)),
        borderRadius: BorderRadius.circular(26),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: titleColor.withValues(alpha: 0.07),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(26)),
                child: SizedBox(
                  height: 132,
                  width: 96,
                  child: _bookCover(book.coverUrl),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          AppPill(label: book.category),
                          AppPill(
                            label: book.formatLabel,
                            foregroundColor: titleColor,
                            backgroundColor: surfaceColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: titleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        book.authorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: mutedTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 2,
                        runSpacing: 2,
                        children: [
                          TextButton.icon(
                            onPressed: () =>
                                Get.to(() => ReadBookScreenView(book: book)),
                            icon: const Icon(
                              Icons.menu_book_rounded,
                              color: appColor,
                            ),
                            label: const Text("Open book"),
                          ),
                          TextButton.icon(
                            onPressed: () =>
                                _favoriteController.toggleFavorite(book.id),
                            icon: const Icon(
                              Icons.favorite_rounded,
                              color: dangerColor,
                            ),
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
      body: AppBackground(
        child: SafeArea(
          child: Obx(() {
            if (_favoriteController.isLoading.value &&
                _favoriteController.favoriteBooks.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_favoriteController.errorMessage.value.isNotEmpty &&
                _favoriteController.favoriteBooks.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: AppInlineMessage(
                    message: _favoriteController.errorMessage.value,
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _favoriteController.loadFavorites,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
                children: [
                  Text(
                    "Favorites",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Your saved books stay here for quick access.",
                    style: TextStyle(color: mutedTextColor),
                  ),
                  const SizedBox(height: 18),
                  AppSectionCard(
                    color: cardSoftColor,
                    radius: 26,
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: dangerColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: dangerColor,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            "${_favoriteController.favoriteBooks.length} saved books ready whenever you want to reopen them.",
                            style: const TextStyle(
                              color: titleColor,
                              fontWeight: FontWeight.w700,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_favoriteController.errorMessage.value.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    AppInlineMessage(
                      message: _favoriteController.errorMessage.value,
                    ),
                  ],
                  const SizedBox(height: 18),
                  if (_favoriteController.favoriteBooks.isEmpty)
                    const AppSectionCard(
                      radius: 24,
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite_border_rounded,
                            size: 42,
                            color: mutedTextColor,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No favorite book found",
                            style: TextStyle(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Save a few books from Home and they will appear here.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: mutedTextColor),
                          ),
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
      ),
    );
  }
}
