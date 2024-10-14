import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/services/shared_preferences/custom_shared_preferences.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appModel = GetIt.I<ApplicationDataModel>();
    final config = appModel.dependenciesConfiguration;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: OnboardingWidget(
          canGoBack: true,
          onTapLater: (_) {
            CustomSharedPreferences.instance.setBooleanValue("alreadyRun", true);
            AutoRouter.of(_).pushAndPopUntil(appModel.mainRoute, predicate: (_) => false);
          },
          finalCallback: (_) {
            CustomSharedPreferences.instance.setBooleanValue("alreadyRun", true);
            AutoRouter.of(_).pushAndPopUntil(appModel.mainRoute, predicate: (_) => false);
          },
          type: config.onboardingType,
          pages: config.onBoardingPages,
        ),
      ),
    );
  }
}
