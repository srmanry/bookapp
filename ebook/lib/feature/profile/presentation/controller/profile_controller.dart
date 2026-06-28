import "package:get/get.dart";
import "package:libararybd/core/network/api_client.dart";
import "package:libararybd/core/session/auth_session.dart";
import "package:libararybd/feature/auth/data/model/app_user.dart";
import "package:libararybd/feature/profile/data/repository/profile_repository_impl.dart";
import "package:libararybd/feature/profile/domain/repository/profile_repository.dart";

class ProfileController extends GetxController {
  final IProfileRepository _profileRepository;
  final AuthSession _authSession;

  ProfileController({
    IProfileRepository? profileRepository,
    AuthSession? authSession,
  })  : _profileRepository = profileRepository ?? ProfileRepositoryImpl(),
        _authSession = authSession ?? AuthSession.instance;

  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString errorMessage = "".obs;
  final RxMap<String, dynamic> profile = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final token = _authSession.token.value;
    if (token.isEmpty) {
      errorMessage.value = "Please login first.";
      profile.clear();
      return;
    }

    isLoading.value = true;
    errorMessage.value = "";
    try {
      final value = await _profileRepository.fetchProfile(token: token);
      profile.assignAll(value);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (_) {
      errorMessage.value = "Failed to load profile.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
  }) async {
    final token = _authSession.token.value;
    final currentUser = _authSession.currentUser.value;

    if (token.isEmpty || currentUser == null) {
      errorMessage.value = "Please login first.";
      return false;
    }

    if (name.trim().isEmpty || email.trim().isEmpty) {
      errorMessage.value = "Name and email are required.";
      return false;
    }

    isUpdating.value = true;
    errorMessage.value = "";

    try {
      final updatedProfile = await _profileRepository.updateProfile(
        token: token,
        name: name,
        email: email,
      );

      profile.assignAll(updatedProfile);
      _authSession.updateUser(
        AppUser.fromJson(updatedProfile).copyWith(
          id: currentUser.id,
          role: currentUser.role,
        ),
      );
      return true;
    } on ApiException catch (error) {
      errorMessage.value = error.message;
      return false;
    } catch (_) {
      errorMessage.value = "Failed to update profile.";
      return false;
    } finally {
      isUpdating.value = false;
    }
  }
}
