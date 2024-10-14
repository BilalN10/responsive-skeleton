import 'package:core_kosmos/core_package.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

/// Check if User is already logged in. If not, redirect to Login Page.
///
/// {@category Guard}
/// {@subCategory authentication}
class LoginGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (FirebaseAuth.instance.currentUser != null) {
      printInDebug("User connected");
      if (GetIt.instance<ApplicationDataModel>().applicationConfig.emailMustBeVerified && !FirebaseAuth.instance.currentUser!.emailVerified) {
        printInDebug("email not verified");
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
        FirebaseAuth.instance.signOut().then((value) => router.replaceNamed("/login"));
        return;
      }
      resolver.next(true);
    } else {
      printInDebug("No User connected");
      router.replaceNamed("/login");
    }
  }
}
