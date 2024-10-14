import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Check if User is already logged in. If yes, signOut him and redirect to [loginRoute].
///
/// {@category Guard}
/// {@subCategory authentication}
class LogoutGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.signOut().then(
        (value) {
          router.replaceNamed("/login");
        },
      );
    } else {
      router.replaceNamed("/login");
    }
  }
}
