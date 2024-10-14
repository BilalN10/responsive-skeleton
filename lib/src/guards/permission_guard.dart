import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

/// Check if User is already logged in. If yes, signOut him and redirect to [loginRoute].
///
/// {@category Guard}
/// {@subCategory authentication}
class PermissionGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (!GetIt.I<ApplicationDataModel>().dependenciesConfiguration.applicationNeedsPermission) {
      resolver.next();
      return;
    }

    if (GetIt.I<ApplicationDataModel>().dependenciesConfiguration.permissionNeedConnectedUser && FirebaseAuth.instance.currentUser == null) {
      resolver.next();
      return;
    }

    CustomSharedPreferences.instance.getBooleanValue("permissionAlreadyLaunched").then((value) {
      if (!value &&
          (GetIt.I<ApplicationDataModel>().dependenciesConfiguration.applicationNeedsPermission ||
              GetIt.I<ApplicationDataModel>().applicationConfig.applicationNeedsPermission)) {
        printInDebug("[Info] First run detected, redirecting to Permission.");
        router.replaceNamed("/permission");
        return;
      } else {
        resolver.next();
        return;
      }
    });
  }
}
