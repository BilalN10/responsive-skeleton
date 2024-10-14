import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

/// Check if User is already logged in. If yes, signOut him and redirect to [loginRoute].
///
/// {@category Guard}
/// {@subCategory authentication}
class OnboardingGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (!GetIt.I<ApplicationDataModel>().dependenciesConfiguration.enableOnBoarding) {
      resolver.next();
      return;
    }
    CustomSharedPreferences.instance.getBooleanValue("alreadyRun").then((value) {
      if (!value && GetIt.I<ApplicationDataModel>().dependenciesConfiguration.enableOnBoarding) {
        printInDebug("[Info] First run detected, redirecting to onboarding.");
        router.replaceNamed("/onboarding");
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const OnboardingPage()));
        return;
      } else {
        resolver.next();
        return;
      }
    });
  }
}
