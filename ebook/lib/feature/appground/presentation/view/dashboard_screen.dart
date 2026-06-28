import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:libararybd/core/session/auth_session.dart";
import "package:libararybd/core/util/custom_color.dart";
import "package:libararybd/feature/favorite/presentation/controller/favorite_controller.dart";
import "package:libararybd/feature/favorite/presentation/view/favorite_screen.dart";
import "package:libararybd/feature/home/presentation/controller/home_controller.dart";
import "package:libararybd/feature/home/presentation/view/home_screen.dart";
import "package:libararybd/feature/note/presentation/controller/note_controller.dart";
import "package:libararybd/feature/note/presentation/view/note_screen_view.dart";
import "package:libararybd/feature/profile/presentation/controller/book_upload_controller.dart";
import "package:libararybd/feature/profile/presentation/controller/profile_controller.dart";
import "package:libararybd/feature/profile/presentation/controller/your_books_controller.dart";
import "package:libararybd/feature/profile/presentation/view/book_upload_screen.dart";
import "package:libararybd/feature/profile/presentation/view/profile_screen.dart";
import "package:libararybd/feature/profile/presentation/view/your_books_screen.dart";

class AppGroundScreenView extends StatefulWidget {
  const AppGroundScreenView({super.key});

  @override
  State<AppGroundScreenView> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<AppGroundScreenView> {
  int currentPage = 0;

  bool get _isAuthor => AuthSession.instance.isAuthor;

  List<Widget> get _pageList => _isAuthor
      ? const [
          YourBooksScreen(),
          BookUploadScreenView(),
          ProfileScreenView(),
        ]
      : const [
          HomeScreenView(),
          FavoriteScreenView(),
          NoteScreenView(),
          ProfileScreenView(),
        ];

  List<NavigationDestination> get _destinations => _isAuthor
      ? const [
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books_rounded),
            label: "My Books",
          ),
          NavigationDestination(
            icon: Icon(Icons.upload_file_outlined),
            selectedIcon: Icon(Icons.upload_file_rounded),
            label: "Upload",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: "Profile",
          ),
        ]
      : const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: "Favorite",
          ),
          NavigationDestination(
            icon: Icon(Icons.sticky_note_2_outlined),
            selectedIcon: Icon(Icons.sticky_note_2_rounded),
            label: "Notes",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: "Profile",
          ),
        ];

  void _handleDestinationSelected(int index) {
    setState(() {
      currentPage = index;
    });

    if (_isAuthor) {
      if (index == 0 && Get.isRegistered<YourBooksController>()) {
        Get.find<YourBooksController>().loadBooks();
      }

      if (index == 1 && Get.isRegistered<BookUploadController>()) {
        Get.find<BookUploadController>().loadCategories();
      }

      if (index == 2 && Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().loadProfile();
      }

      return;
    }

    if (index == 0 && Get.isRegistered<HomeController>()) {
      final controller = Get.find<HomeController>();
      controller.loadBooks();
      controller.loadFavoriteBookIds();
    }

    if (index == 1 && Get.isRegistered<FavoriteController>()) {
      Get.find<FavoriteController>().loadFavorites();
    }

    if (index == 2 && Get.isRegistered<NoteController>()) {
      Get.find<NoteController>().loadAll();
    }

    if (index == 3 && Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageList = _pageList;
    if (currentPage >= pageList.length) {
      currentPage = pageList.length - 1;
    }

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentPage,
        children: pageList,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: titleColor.withValues(alpha: 0.08),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: NavigationBar(
              height: 76,
              selectedIndex: currentPage,
              onDestinationSelected: _handleDestinationSelected,
              destinations: _destinations,
            ),
          ),
        ),
      ),
    );
  }
}
