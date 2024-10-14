import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/controller/logged_controller.dart';

/// UserData Provider
///
/// {@category Provider}
final userChangeNotifierProvider = ChangeNotifierProvider<UserProvider>((ref) {
  return UserProvider(ref, GetIt.instance<ApplicationDataModel>().userCollectionPath, GetIt.instance<ApplicationDataModel>().userConstructorProvider);
});

final dashboardProvider = ChangeNotifierProvider<DashboardProvider>((ref) => DashboardProvider(ref));

/// Page principal du skeleton, gère toutes les pages de l'application.
/// peut être modifié pour ajouter des pages depuis le AppRouter.
///
/// {@category Core}
class DashboardPage extends StatefulHookConsumerWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends ConsumerState<DashboardPage> with WidgetsBindingObserver {
  ValueNotifier<bool> popupCompleteProfile = ValueNotifier<bool>(false);
  bool isPermissionGranted = false;

  final appModel = GetIt.instance<ApplicationDataModel>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    // if ((appModel.applicationConfig.applicationNeedsPermission || appModel.dependenciesConfiguration.applicationNeedsPermission)) {
    //   execAfterBuild(() async => await _loadPermissions(context));
    // }

    ref.read(dashboardProvider).init(GetIt.instance<ApplicationDataModel>().mainRoute);
    if (GetIt.I<ApplicationDataModel>().forceUserConnection || FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (ref.read(userChangeNotifierProvider).userData == null) {
          await ref.read(userChangeNotifierProvider).init(FirebaseAuth.instance.currentUser!.uid, context);
          if (GetIt.instance<ApplicationDataModel>().dashboardInitialiser != null) {
            await GetIt.instance<ApplicationDataModel>().dashboardInitialiser!(context, ref);
          }
        }
      });
    }


    if (FirebaseAuth.instance.currentUser != null) {
      (()async{
        final d = (await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get()).get("enablePushNotification");
        if (d == true) {
          final token = await FirebaseMessaging.instance.getToken();
          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({"fcmToken": token});
        }
      }).call();
    }
    
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      /// Mets à jour l'utilisateur en "connected"
      LoggedController.setAsLogged(true);
    } else {
      /// Mets à jour l'utilisateur en "disconnected"
      LoggedController.setAsLogged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    printInDebug("We have to rebuild main scaffold.");

    if (appModel.forceUserConnection || FirebaseAuth.instance.currentUser != null) {
      // if ((appModel.applicationConfig.applicationNeedsPermission || appModel.dependenciesConfiguration.applicationNeedsPermission) && !isPermissionGranted) {
      //   isPermissionGranted = true;
      //   _loadPermissions(context);
      // }

      if (ref.watch(userChangeNotifierProvider).userData == null) {
        return const Scaffold(body: Center(child: LoaderClassique()));
      } else if (ref.watch(userChangeNotifierProvider).userData!.profilCompleted != true) {
        execAfterBuild(() => _showCompleteProfil(context));
        return const Scaffold(body: Center(child: LoaderClassique()));
      }

      if (GetIt.instance<ApplicationDataModel>().dashboardInitialiserWithUserData != null) {
        GetIt.instance<ApplicationDataModel>().dashboardInitialiserWithUserData!(context, ref);
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawerEnableOpenDragGesture: false,
      drawer: _generateDrawer(context),
      appBar: execInCaseOfPlatfom(() {
        return appModel.applicationConfig.showAppBarOnWeb
            ? ResponsiveAppBar(
                ref: ref,
                size: Size.fromHeight(
                  loadThemeData<ResponsiveAppBarThemeData>(null, "skeleton_app_bar", () => const ResponsiveAppBarThemeData())!.height,
                ))
            : null;
      }, () {
        return appModel.applicationConfig.mobileAppBarBuilder != null ? appModel.applicationConfig.mobileAppBarBuilder!(context, ref) : null;
      }),
      body: const BasicWebParentPage(child: AutoRouter()),
      bottomNavigationBar: _generateBottomNavigationBar(context, appModel),
    );
  }

  Widget? _generateDrawer(BuildContext context) {
    final appModel = GetIt.instance<ApplicationDataModel>();

    if (!appModel.applicationConfig.showSideBarOrDrawerOnWeb) return null;
    if (getResponsiveValue(context, defaultValue: true, tablet: false, phone: false)) return null;
    return Drawer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: formatWidth(10)),
        child: Center(
          child: SingleChildScrollView(
            primary: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...ItemLinkHelper.getListLinkItem(ref)
                    .map(
                      (e) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinkItem(model: e, isSideBar: true),
                          sh(8),
                        ],
                      ),
                    )
                    .toList(),
                if (appModel.enableProfil)
                  LinkItem(
                    model: LinkItemModel(
                      tag: "profile",
                      route: appModel.profilRoute,
                      routeName: appModel.profilRouteName,
                      label: "profil",
                      iconInactiveAndDefaultPath: "assets/svg/ic_profil.svg",
                    ),
                    isSideBar: true,
                  )
                else
                  LinkItem(
                    model: LinkItemModel(
                      tag: "logout",
                      route: "/logout",
                      routeName: "LogoutRoute",
                      label: "logout",
                      iconInactiveAndDefaultPath: "assets/svg/ic_profil.svg",
                    ),
                    isSideBar: true,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _generateBottomNavigationBar(BuildContext context, ApplicationDataModel appModel) {
    final appBarTheme = loadThemeData(null, "skeleton_bottom_bar", () => const ResponsiveAppBarThemeData())!;
    final theme = loadThemeData(null, "skeleton_app_bar", () => const ResponsiveAppBarThemeData())!;

    if (getResponsiveValue(context, defaultValue: false, tablet: true, phone: true)) {
      if (!appModel.applicationConfig.bottomNavigationBarInMobile) return null;
      if (appModel.applicationConfig.mobileBottomBarBuilder != null) {
        return appModel.applicationConfig.mobileBottomBarBuilder!(context, ref);
      }
      return Container(
        width: MediaQuery.of(context).size.width,
        height: theme.height,
        decoration: BoxDecoration(
          color: appBarTheme.backgroundColor,
          boxShadow: appBarTheme.shadow,
        ),
        padding: appBarTheme.padding,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: ItemLinkHelper.getListLinkItem(ref)
              .map((e) => Expanded(child: Center(child: LinkItem(model: e.copyWith(label: null), showLabel: false))))
              .toList(),
        ),
      );
    }
    return null;
  }

  _showCompleteProfil(BuildContext context) async {
    if (popupCompleteProfile.value) return;
    popupCompleteProfile.value = true;

    final child = GetIt.instance<ApplicationDataModel>().applicationConfig.completeProfilPopup;

    printInDebug(child != null ? "[Info]: Load custom complete profil Widget" : "[Info]: Load default complete profil Widget");

    if (getResponsiveValue(context, defaultValue: false, tablet: true, phone: true)) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            body: child ?? CompleteProfilPopup(context: context),
          ),
        );
      }));
      return;
    }

    await showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(builder: (__, StateSetter newState) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: CustomCard(
                maxWidth: formatWidth(536),
                useIntrisict: false,
                child: child ?? CompleteProfilPopup(context: _),
              ),
            ),
          );
        });
      },
    );

    popupCompleteProfile.value = false;
  }

  // FutureOr<bool> _loadPermissions(BuildContext context) async {
  //   printInDebug("[Info]: Init permissions");

  //   final prefs = await SharedPreferences.getInstance();
  //   final loaded = prefs.getStringList("loadedUser");

  //   if (loaded?.contains(FirebaseAuth.instance.currentUser!.uid) ?? false) {
  //     printInDebug("[Info]: Permissions already loaded");
  //     return false;
  //   }

  //   printInDebug("[Info]: Load permissions");

  //   final PageController controller = PageController(initialPage: 0);
  //   final appModel = GetIt.I<ApplicationDataModel>();

  //   execAfterBuild(() async {
  //     await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
  //       return WillPopScope(
  //         onWillPop: () async => false,
  //         child: Scaffold(
  //           body: PermissionsPageViewCustom(
  //             pages: appModel.applicationConfig.permissonWidgets.map((e) => e(context, ref, controller)).toList(),
  //             pageController: controller,
  //           ),
  //         ),
  //       );
  //     })).then((_) async {
  //       printInDebug("[Info]: End permissions");
  //       List<String> t = [];
  //       loaded?.forEach((e) => t.add(e));
  //       t.add(FirebaseAuth.instance.currentUser!.uid);
  //       prefs.setStringList("loadedUser", t);
  //       isPermissionGranted = false;
  //       setState(() {});
  //     });
  //   });
  //   return true;
  // }
}
