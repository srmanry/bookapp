import "package:get/get.dart";
import "package:libararybd/feature/auth/data/model/app_user.dart";

class AuthSession {
  AuthSession._();

  static final AuthSession instance = AuthSession._();

  final Rxn<AppUser> currentUser = Rxn<AppUser>();
  final RxString token = "".obs;

  bool get isLoggedIn => currentUser.value != null && token.value.isNotEmpty;
  bool get isAuthor => currentUser.value?.role == "author";
  bool get isReader => currentUser.value?.role == "reader";

  void setSession({required AppUser user, required String accessToken}) {
    currentUser.value = user;
    token.value = accessToken;
  }

  void updateUser(AppUser user) {
    currentUser.value = user;
  }

  void clear() {
    currentUser.value = null;
    token.value = "";
  }
}
