import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:libararybd/core/widgets/custom_button.dart";
import "package:libararybd/core/widgets/custom_text_field.dart";
import "package:libararybd/core/util/custom_color.dart";
import "package:libararybd/feature/appground/presentation/view/dashboard_screen.dart";
import "package:libararybd/feature/auth/presentation/controller/sign_up_controller.dart";
import "package:libararybd/feature/auth/presentation/view/login_screen_view.dart";

enum UserRole { author, reader }

class SignUpScreenView extends StatefulWidget {
  const SignUpScreenView({super.key});

  @override
  State<SignUpScreenView> createState() => _SignUpScreenViewState();
}

class _SignUpScreenViewState extends State<SignUpScreenView> {
  UserRole? _selectedRole;
  final SignUpController _signUpController = Get.put(SignUpController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignUpTap() async {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select Author or Reader")),
      );
      return;
    }

    if (_signUpController.isLoading.value) return;

    final isSuccess = await _signUpController.signUp(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      role: _selectedRole!.name,
    );

    if (!mounted) return;

    if (isSuccess) {
      Get.offAll(() => const AppGroundScreenView());
      return;
    }

    final message = _signUpController.errorMessage.value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message.isEmpty ? "Signup failed" : message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradientStartColor, gradientEndColor],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton.filledTonal(
                  onPressed: Get.back,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.82),
                  ),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  "Create your account\nand start building a library.",
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  "Choose whether you are here to read or publish, then set up your account in a minute.",
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.84),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: borderColor),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 30,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Name",
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        priFixIcon: const Icon(Icons.person_outline_rounded),
                        hinText: "Your name",
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Email",
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        priFixIcon: const Icon(Icons.mail_outline_rounded),
                        hinText: "Enter your email",
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Password",
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        priFixIcon: const Icon(Icons.lock_outline_rounded),
                        hinText: "Create a password",
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        "Choose your role",
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _RoleCard(
                              title: "Reader",
                              subtitle: "Discover books and save notes",
                              icon: Icons.chrome_reader_mode_rounded,
                              isSelected: _selectedRole == UserRole.reader,
                              onTap: () {
                                setState(() {
                                  _selectedRole = UserRole.reader;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _RoleCard(
                              title: "Author",
                              subtitle: "Publish and manage your books",
                              icon: Icons.edit_note_rounded,
                              isSelected: _selectedRole == UserRole.author,
                              onTap: () {
                                setState(() {
                                  _selectedRole = UserRole.author;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardSoftColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.verified_user_outlined,
                              color: appColor,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "By joining, you agree to keep the library respectful and useful for everyone.",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: titleColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Obx(
                        () => _signUpController.isLoading.value
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : CustomBottom(
                                name: "Sign up",
                                bottomColor: appColor,
                                onTap: _onSignUpTap,
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(
                          () => const LoginScreenView(),
                          transition: Transition.leftToRight,
                        );
                      },
                      child: const Text("Sign in"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? appColor.withValues(alpha: 0.1) : surfaceColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? appColor : borderColor,
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: isSelected ? appColor : mutedTextColor),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                color: mutedTextColor,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
