import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:libararybd/core/widgets/custom_button.dart";
import "package:libararybd/core/widgets/custom_text_field.dart";
import "package:libararybd/core/util/custom_color.dart";
import "package:libararybd/feature/appground/presentation/view/dashboard_screen.dart";
import "package:libararybd/feature/auth/presentation/controller/login_controller.dart";
import "package:libararybd/feature/auth/presentation/view/sign_up_screen.dart";

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({super.key});

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController _loginController = Get.put(LoginController());

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginTap() async {
    if (_loginController.isLoading.value) return;

    final isSuccess = await _loginController.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (isSuccess) {
      Get.offAll(() => const AppGroundScreenView());
      return;
    }

    final message = _loginController.errorMessage.value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message.isEmpty ? "Login failed" : message)),
    );
  }

  void _onForgotPasswordTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Forgot password flow will be added here.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: gradientEndColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientStartColor, gradientEndColor],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -70,
              right: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: appColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 160,
              left: -50,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: borderColor),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_stories_rounded, color: appColor),
                          SizedBox(width: 10),
                          Text(
                            "Shelf Story",
                            style: TextStyle(
                              color: titleColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Welcome back\nto your reading space.",
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Continue reading, manage favorites, and keep every note in one calm place.",
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.82),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: borderColor),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 30,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Sign in", style: theme.textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text(
                            "Use your email and password to enter the library.",
                            style: theme.textTheme.bodyMedium,
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
                            hinText: "Enter your password",
                            obscureText: true,
                            controller: _passwordController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _onForgotPasswordTap,
                        child: const Text("Forgot password?"),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Obx(
                      () => _loginController.isLoading.value
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : CustomBottom(
                              name: "Login",
                              bottomColor: appColor,
                              onTap: _onLoginTap,
                            ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(
                              () => const SignUpScreenView(),
                              transition: Transition.rightToLeft,
                            );
                          },
                          child: const Text("Create one"),
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
    );
  }
}
