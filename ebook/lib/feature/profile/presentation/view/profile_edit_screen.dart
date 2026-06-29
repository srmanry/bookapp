import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:libararybd/core/session/auth_session.dart";
import "package:libararybd/core/util/custom_color.dart";
import "package:libararybd/core/widgets/app_surfaces.dart";
import "package:libararybd/core/widgets/custom_button.dart";
import "package:libararybd/core/widgets/custom_text_field.dart";
import "package:libararybd/feature/profile/presentation/controller/profile_controller.dart";

class ProfileEditScreenView extends StatefulWidget {
  const ProfileEditScreenView({super.key});

  @override
  State<ProfileEditScreenView> createState() => _ProfileEditScreenViewState();
}

class _ProfileEditScreenViewState extends State<ProfileEditScreenView> {
  final ProfileController _profileController = Get.find<ProfileController>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final currentUser = AuthSession.instance.currentUser.value;
    final profile = _profileController.profile;
    _nameController = TextEditingController(
      text: currentUser?.name ?? profile["name"]?.toString() ?? "",
    );
    _emailController = TextEditingController(
      text: currentUser?.email ?? profile["email"]?.toString() ?? "",
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSaveTap() async {
    final ok = await _profileController.updateProfile(
      name: _nameController.text,
      email: _emailController.text,
    );

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
      Get.back();
      return;
    }

    final message = _profileController.errorMessage.value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.isEmpty ? "Profile update failed" : message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthSession.instance.currentUser.value;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit profile")),
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionCard(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [appColor, Color(0xFF14947A)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Update your profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You are signed in as ${currentUser?.role ?? "reader"}. Role stays the same here, but your public details can be refreshed anytime.",
                      style: const TextStyle(
                        color: Color(0xFFE7FFF7),
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              AppSectionCard(
                color: cardSoftColor,
                radius: 26,
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.verified_user_outlined,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        "Keep your name and email current so your reading or publishing profile stays easy to recognize.",
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AppSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Name",
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hinText: "Your name",
                      controller: _nameController,
                      priFixIcon: const Icon(Icons.person_outline_rounded),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Email",
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hinText: "Your email",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      priFixIcon: const Icon(Icons.mail_outline_rounded),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardSoftColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        "Current role: ${currentUser?.role ?? "reader"}",
                        style: const TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (_profileController.errorMessage.value.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      AppInlineMessage(
                        message: _profileController.errorMessage.value,
                      ),
                    ],
                    const SizedBox(height: 22),
                    Obx(
                      () => _profileController.isUpdating.value
                          ? const Center(child: CircularProgressIndicator())
                          : CustomBottom(
                              name: "Save changes",
                              bottomColor: appColor,
                              onTap: _onSaveTap,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
