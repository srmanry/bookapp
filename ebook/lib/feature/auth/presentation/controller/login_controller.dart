import "package:get/get.dart";
import "package:libararybd/core/network/api_client.dart";
import "package:libararybd/core/session/auth_session.dart";
import "package:libararybd/feature/auth/data/repository/auth_repository_impl.dart";
import "package:libararybd/feature/auth/domain/repository/auth_repository.dart";

class LoginController extends GetxController {
  final IAuthRepository _authRepository;
  final AuthSession _authSession;

  LoginController({
    IAuthRepository? authRepository,
    AuthSession? authSession,
  })  : _authRepository = authRepository ?? AuthRepositoryImpl(),
        _authSession = authSession ?? AuthSession.instance;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      errorMessage.value = "Email and password are required.";
      return false;
    }

    isLoading.value = true;
    errorMessage.value = "";

    try {
      final authResult = await _authRepository.login(
        email: email,
        password: password,
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
      errorMessage.value = "Unable to login. Check backend connection.";
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
