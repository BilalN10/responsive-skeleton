// ignore_for_file: provide_deprecation_message

import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:skeleton_kosmos/src/core/pages/main_page.dart';
import 'package:skeleton_kosmos/src/model/app_model.dart';
import 'package:url_strategy/url_strategy.dart';

/// {@category Core}
///
/// Point d'entrée de l'application.
/// Cette classe est responsable de l'initialisation de l'application.
/// Elle est responsable de l'initialisation des services de l'application et du lancement en fonction de la platforme (IOS / Android ou Web).
///
/// ![An image of function](./doc/images/LaunchApplication_launch.png)
///
abstract class LaunchApplication {
  static Future<void> _registerAppModel({
    required ApplicationDataModel appModel,
    AppTheme? customTheme,
  }) async {
    GetIt.instance.registerSingleton(appModel);
    if (customTheme != null) {
      GetIt.instance.registerSingleton(customTheme);
    }
  }

  static Future<void> _launchFirebaseService({required ApplicationDataModel appModel}) async {
    if (!appModel.firebaseIsEnabled) return;

    if (kIsWeb) {
      await Firebase.initializeApp(options: appModel.firebaseOptions);
      await FirebaseAuth.instance.setPersistence(Persistence.INDEXED_DB);
    } else {
      await Firebase.initializeApp();
    }

    if (appModel.clearUserSessionOnDebugMode) {
      if (!kReleaseMode && FirebaseAuth.instance.currentUser != null) {
        printInDebug("[Debug] clear user session");
        await FirebaseAuth.instance.signOut();
      }
    }

    User? firebaseUser = FirebaseAuth.instance.currentUser;
    firebaseUser ??= await FirebaseAuth.instance.authStateChanges().first;
  }

  /// Lance l'application.
  ///
  static Future<void> launch({
    required ApplicationDataModel applicationModel,
    required RootStackRouter appRouter,
    AppTheme Function(BuildContext)? initTheme,
    @Deprecated("customTheme was deprecated from v3.3.0, /!\\ this parameter will be removed in v4.0.0") AppTheme? customTheme,
    String translationsPath = "assets/translations",
  }) async {
    /// Be sure all widget and flutter system are initialized
    final binding = WidgetsFlutterBinding.ensureInitialized();
    if (kIsWeb) setPathUrlStrategy();

    FlutterNativeSplash.preserve(widgetsBinding: binding);

    // ignore: deprecated_member_use

    /// Ensure Translations is correctly initialized
    await EasyLocalization.ensureInitialized();

    /// Register model and data via Get_it package
    await _registerAppModel(appModel: applicationModel, customTheme: customTheme);

    /// Initialize services
    /// Firebase
    await _launchFirebaseService(appModel: applicationModel);

    /// Function Passed by user.
    await applicationModel.splashScreenPreserve?.call();

    FlutterNativeSplash.remove();

    return runApp(
      ProviderScope(
        child: EasyLocalization(
          supportedLocales: applicationModel.supportedLocales,
          fallbackLocale: applicationModel.defaultLocale,
          startLocale: applicationModel.defaultLocale,
          path: translationsPath,
          child: ScreenUtilInit(
            child: MainPage(appRouter: appRouter),
            designSize: applicationModel.designSize,
            builder: ((context, _) {
              if (!GetIt.instance.isRegistered<AppTheme>() && initTheme != null) {
                GetIt.instance.registerSingleton(initTheme(context));
              }
              return ResponsiveWrapper.builder(
                BouncingScrollWrapper(child: _!),
                maxWidth: applicationModel.maxWidth,
                minWidth: 480,
                breakpoints: [
                  ResponsiveBreakpoint.tag(applicationModel.maxPhoneWidth, name: PHONE),
                  ResponsiveBreakpoint.tag(applicationModel.maxTabletWidth, name: TABLET),
                  ResponsiveBreakpoint.tag(applicationModel.maxWebWidth, name: DESKTOP),
                  ResponsiveBreakpoint.autoScale(applicationModel.maxWidth, name: "MaxWidth"),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
