import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:libararybd/core/session/auth_session.dart";
import "package:libararybd/core/util/custom_color.dart";
import "package:libararybd/core/widgets/app_surfaces.dart";
import "package:libararybd/feature/auth/presentation/view/login_screen_view.dart";
import "package:libararybd/feature/profile/presentation/controller/profile_controller.dart";
import "package:libararybd/feature/profile/presentation/view/book_upload_screen.dart";
import "package:libararybd/feature/profile/presentation/view/profile_edit_screen.dart";
import "package:libararybd/feature/profile/presentation/view/your_books_screen.dart";
import "package:libararybd/feature/profile/presentation/widgets/profile_card_widget.dart";

class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({super.key});

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  final ProfileController _profileController = Get.put(ProfileController());

  Future<void> _showLogoutDialog() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Log out?"),
          content: const Text(
            "You will need to sign in again to access your library and notes.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: dangerColor),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Log out"),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    AuthSession.instance.clear();
    Get.offAll(() => const LoginScreenView());
  }

  Widget _statCard(String label, String value) {
    return AppSectionCard(
      radius: 22,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: titleColor,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: mutedTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authSession = AuthSession.instance;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Obx(() {
            final currentUser = authSession.currentUser.value;
            final isAuthor = authSession.isAuthor;
            final profile = _profileController.profile;
            final stats =
                profile["stats"] as Map<String, dynamic>? ?? <String, dynamic>{};
            final totalBooks = stats["totalBooks"]?.toString() ?? "0";
            final totalFavorites = stats["totalFavorites"]?.toString() ?? "0";
            final totalNotes = stats["totalNotes"]?.toString() ?? "0";

            return RefreshIndicator(
              onRefresh: _profileController.loadProfile,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
                children: [
                  Text(
                    "Profile",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Update your details, track activity, and manage your account.",
                    style: TextStyle(color: mutedTextColor),
                  ),
                  const SizedBox(height: 18),
                  AppSectionCard(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [appColor, Color(0xFF14947A)],
                    ),
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.32),
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          currentUser?.name ??
                              profile["name"]?.toString() ??
                              "Guest User",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          currentUser?.email ??
                              profile["email"]?.toString() ??
                              "guest@ebook.com",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFE7FFF7),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        AppPill(
                          label:
                              "Role: ${currentUser?.role ?? profile["role"]?.toString() ?? "reader"}",
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white.withValues(alpha: 0.16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: _statCard("Books", totalBooks)),
                      const SizedBox(width: 10),
                      Expanded(child: _statCard("Favorites", totalFavorites)),
                      const SizedBox(width: 10),
                      Expanded(child: _statCard("Notes", totalNotes)),
                    ],
                  ),
                  if (_profileController.errorMessage.value.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    AppInlineMessage(message: _profileController.errorMessage.value),
                  ],
                  const SizedBox(height: 20),
                  AppSectionCard(
                    color: cardSoftColor,
                    radius: 26,
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: appColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.insights_rounded,
                            color: appColor,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            isAuthor
                                ? "You can publish new titles, manage your catalog, and keep your public profile up to date."
                                : "Your profile keeps your reading stats, saved books, and notes in one tidy place.",
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
                  const SizedBox(height: 18),
                  ProfileCardWidget(
                    name: "Edit profile",
                    subtitle: "Update your name and email",
                    icon: Icons.edit_outlined,
                    onTap: () => Get.to(() => const ProfileEditScreenView()),
                  ),
                  if (isAuthor) ...[
                    ProfileCardWidget(
                      name: "Publish new book",
                      subtitle: "Upload a book and share it with readers",
                      icon: Icons.upload_file_rounded,
                      onTap: () => Get.to(() => const BookUploadScreenView()),
                    ),
                    ProfileCardWidget(
                      name: "View your books",
                      subtitle: "Manage and remove your published books",
                      icon: Icons.library_books_rounded,
                      onTap: () => Get.to(() => const YourBooksScreen()),
                    ),
                  ],
                  const ProfileCardWidget(
                    name: "Privacy policy",
                    subtitle: "See how your profile and activity are handled",
                    icon: Icons.privacy_tip_outlined,
                  ),
                  const ProfileCardWidget(
                    name: "Contact support",
                    subtitle: "Get help with access, reading, or publishing",
                    icon: Icons.support_agent_rounded,
                  ),
                  ProfileCardWidget(
                    name: "Log out",
                    subtitle: "End this session and return to sign in",
                    icon: Icons.logout_rounded,
                    iconColor: dangerColor,
                    onTap: _showLogoutDialog,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
