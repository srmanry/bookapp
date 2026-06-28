import "package:get/get.dart";
import "package:libararybd/core/network/api_client.dart";
import "package:libararybd/core/session/auth_session.dart";
import "package:libararybd/feature/auth/data/repository/auth_repository_impl.dart";
import "package:libararybd/feature/auth/domain/repository/auth_repository.dart";

class SignUpController extends GetxController {
  final IAuthRepository _authRepository;
  final AuthSession _authSession;

  SignUpController({
    IAuthRepository? authRepository,
    AuthSession? authSession,
  })  : _authRepository = authRepository ?? AuthRepositoryImpl(),
        _authSession = authSession ?? AuthSession.instance;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      errorMessage.value = "Name, email and password are required.";
      return false;
    }

    isLoading.value = true;
    errorMessage.value = "";

    try {
      final authResult = await _authRepository.signUp(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      _authSession.setSession(
        user: authResult.user,
        accessToken: authResult.token,
      );
      return true;
    } on ApiException catch (error) {
      errorMessage.value = error.message;
      return false;
    } catch (_) {
      errorMessage.value = "Unable to sign up. Check backend connection.";
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
