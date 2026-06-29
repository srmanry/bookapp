import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:libararybd/core/session/auth_session.dart";
import "package:libararybd/core/util/custom_color.dart";
import "package:libararybd/core/widgets/app_surfaces.dart";
import "package:libararybd/core/widgets/custom_text_field.dart";
import "package:libararybd/feature/home/data/model/book_model.dart";
import "package:libararybd/feature/home/presentation/controller/home_controller.dart";
import "package:libararybd/feature/home/presentation/view/readbook_screen.dart";

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  final HomeController _homeController = Get.put(HomeController());

  Widget _bookCover(String url) {
    if (url.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: cardSoftColor,
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.menu_book_rounded, color: appColor, size: 44),
      );
    }

    return Image.network(
      url,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: cardSoftColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (_, __, ___) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: cardSoftColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(Icons.broken_image_rounded, color: mutedTextColor),
        );
      },
    );
  }

  Widget _bookCard(BookModel book) {
    final isFavorite = _homeController.isFavorite(book.id);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.to(() => ReadBookScreenView(book: book)),
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: titleColor.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: SizedBox.expand(child: _bookCover(book.coverUrl)),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: AppPill(
                          label: book.category,
                          backgroundColor: Colors.white.withValues(alpha: 0.92),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.94),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: titleColor.withValues(alpha: 0.08),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () => _homeController.toggleFavorite(book.id),
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFavorite ? dangerColor : titleColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.authorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: mutedTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      AppPill(
                        label: book.formatLabel,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.auto_stories_rounded, size: 14, color: appColor),
                          const SizedBox(width: 4),
                          Text(
                            book.isEpub ? "Read" : "Read",
                            style: const TextStyle(
                              color: appColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshHome() async {
    await _homeController.loadBooks();
    await _homeController.loadFavoriteBookIds();
  }

  Widget _categoryChip(String category, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: isSelected ? appColor : surfaceColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: isSelected ? appColor : borderColor),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: appColor.withValues(alpha: 0.2),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: InkWell(
        onTap: () => _homeController.onCategorySelected(category),
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? Colors.white : titleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _heroCard() {
    final currentUser = AuthSession.instance.currentUser.value;
    final displayName = currentUser != null && currentUser.name.isNotEmpty
        ? currentUser.name
        : "Reader";

    return AppSectionCard(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [appColor, Color(0xFF14947A)],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello $displayName",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Find your next favorite book today.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.local_library_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_up_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${_homeController.books.length} books ready to explore across curated categories.",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return AppSectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      radius: 24,
      child: CustomTextField(
        hinText: "Search by title or author",
        priFixIcon: const Icon(Icons.search_rounded),
        onChanged: _homeController.onSearchChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Obx(
            () => RefreshIndicator(
              onRefresh: _refreshHome,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Discover",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Browse calm, curated shelves and jump back into reading fast.",
                              style: TextStyle(color: mutedTextColor),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: _refreshHome,
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _heroCard(),
                  const SizedBox(height: 18),
                  _searchBox(),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 44,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _homeController.categories.length,
                      itemBuilder: (_, index) {
                        final category = _homeController.categories[index];
                        final isSelected =
                            category == _homeController.selectedCategory.value;
                        return _categoryChip(category, isSelected);
                      },
                    ),
                  ),
                  if (_homeController.errorMessage.value.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    AppInlineMessage(message: _homeController.errorMessage.value),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        "Books for you",
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      AppPill(
                        label: "${_homeController.books.length} items",
                        foregroundColor: titleColor,
                        backgroundColor: surfaceColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_homeController.isLoading.value &&
                      _homeController.books.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 44),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_homeController.books.isEmpty)
                    const AppSectionCard(
                      radius: 24,
                      child: Column(
                        children: [
                          Icon(
                            Icons.library_books_outlined,
                            size: 42,
                            color: mutedTextColor,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No books found",
                            style: TextStyle(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Try another keyword or category.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: mutedTextColor),
                          ),
                        ],
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _homeController.books.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.66,
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 14,
                      ),
                      itemBuilder: (_, index) =>
                          _bookCard(_homeController.books[index]),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
