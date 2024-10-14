import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/core/pages/onboarding/core_page.dart';
import 'package:skeleton_kosmos/src/services/shared_preferences/custom_shared_preferences.dart';

class MainPage extends StatefulWidget {
  final RootStackRouter appRouter;

  const MainPage({
    Key? key,
    required this.appRouter,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final appModel = GetIt.instance<ApplicationDataModel>();
    final appTheme = GetIt.instance<AppTheme>();

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp.router(
        title: appModel.appTitle,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: [
          ...context.localizationDelegates,
          CountryLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        routerDelegate: widget.appRouter.delegate(),
        routeInformationParser: widget.appRouter.defaultRouteParser(),
        builder: (_, child) {
          return child!;
        },
        theme: appTheme.themeData,
      ),
    );
  }
}
