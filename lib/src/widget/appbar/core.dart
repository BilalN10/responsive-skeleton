import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_kosmos.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/core/pages/dashboard.dart';
import 'package:skeleton_kosmos/src/widget/link_item/model.dart';

/// Créer une AppBar avec un bouton de profil et les boutons de navigation (uniquement si configuré dans ApplicationModel).
///
/// {@category Widget}
class ResponsiveAppBar extends PreferredSize {
  final WidgetRef ref;

  const ResponsiveAppBar({
    Key? key,
    required Size size,
    required this.ref,
  }) : super(
          key: key,
          child: const SizedBox(),
          preferredSize: size,
        );

  @override
  Widget build(BuildContext context) {
    final theme = loadThemeData(null, "skeleton_app_bar", () => const ResponsiveAppBarThemeData())!;
    final appModel = GetIt.instance<ApplicationDataModel>();
    final dashboardData = appModel.applicationConfig;

    return Container(
      padding: theme.padding,
      width: MediaQuery.of(context).size.width,
      height: theme.height,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        boxShadow: theme.shadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          dashboardData.appBarHaveLogo
              ? InkWell(
                  child: SizedBox(
                    width: theme.logoWidth,
                    height: theme.logoHeight,
                    child: Center(
                      child: ImageWithSmartFormat(
                        path: appModel.appLogo,
                        type: appModel.logoFormat,
                        width: theme.logoWidth,
                        height: theme.logoHeight,
                        boxFit: BoxFit.contain,
                      ),
                    ),
                  ),
                  onTap: () {
                    ref.read(dashboardProvider).updateRoute(appModel.mainRouteName);
                    AutoRouter.of(context).navigateNamed("/");
                  },
                )
              : const SizedBox(width: 1, height: 1),

          sw(30),

          /// items...
          Expanded(
            child: (getResponsiveValue(context, defaultValue: true, tablet: false))
                ? Center(
                    child: SingleChildScrollView(
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      child: (dashboardData.whereNavigationItem == NavigationPosition.all || dashboardData.whereNavigationItem == NavigationPosition.appbar) ? _generateBarItemList(context, appModel) : const SizedBox(),
                    ),
                  )
                : appModel.applicationConfig.showSideBarOrDrawerOnWeb && !appModel.applicationConfig.bottomNavigationBarInMobile
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            ref.read(dashboardProvider).key.currentState?.openDrawer();
                          },
                          child: Icon(Icons.menu_rounded, size: theme.drawerButtonSize, color: theme.drawerButtonColor),
                        ),
                      )
                    : const SizedBox(),
          ),

          if (getResponsiveValue(context, defaultValue: true, tablet: false)) ...[
            sw(30),
            _generateProfilButton(context, appModel),
          ] else if (!getResponsiveValue(context, defaultValue: true, tablet: false) && appModel.applicationConfig.enableProfilButtonInPhone) ...[
            sw(20),
            _generateProfilButton(context, appModel, true),
          ]
        ],
      ),
    );
  }

  Widget _generateProfilButton(BuildContext context, ApplicationDataModel appModel, [bool isPhone = false]) {
    if (appModel.applicationConfig.appBarHaveProfilButton /*&& appModel.applicationConfig.bottomNavigationBarInMobile*/) {
      return appModel.profilButtonBuilder?.call(context, ref) ??
          ProfilButton(
            title: isPhone ? null : "${ref.watch(userChangeNotifierProvider).userData!.firstname} ${ref.watch(userChangeNotifierProvider).userData!.lastname}",
            subtitle: isPhone ? null : ref.watch(userChangeNotifierProvider).userData!.email,
            imagePath: ref.watch(userChangeNotifierProvider).userData!.profilImage,
          );
    }
    return const SizedBox(width: 1, height: 1);
  }

  Widget _generateBarItemList(BuildContext context, ApplicationDataModel appModel) {
    if (appModel.applicationConfig.whereNavigationItem != NavigationPosition.all && appModel.applicationConfig.whereNavigationItem != NavigationPosition.appbar) {
      return const SizedBox();
    }

    final spacing = loadThemeData(null, "skeleton_app_bar", () => const ResponsiveAppBarThemeData())!.itemSpacing;

    return Row(
      children: [
        ...ItemLinkHelper.getListLinkItem(ref)
            .map((e) => Row(
                  children: [
                    LinkItem(model: e.copyWith(position: LinkItemPosition.appbar)),
                    sw(spacing),
                  ],
                ))
            .toList(),
      ],
    );
  }

  /// Créer une appBar avec uniquement le logo de l'application.
  const factory ResponsiveAppBar.blank({
    required Size size,
    required WidgetRef ref,
  }) = _Blank;
}

class _Blank extends ResponsiveAppBar {
  const _Blank({
    Key? key,
    required Size size,
    required WidgetRef ref,
  }) : super(key: key, ref: ref, size: size);

  @override
  Widget build(BuildContext context) {
    final theme = loadThemeData(null, "skeleton_app_bar", () => const ResponsiveAppBarThemeData())!;
    final appModel = GetIt.instance<ApplicationDataModel>();

    return Container(
      padding: theme.padding,
      width: MediaQuery.of(context).size.width,
      height: theme.height,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        boxShadow: theme.shadow,
      ),
      child: Row(
        children: [
          ImageWithSmartFormat(path: appModel.appLogo, type: appModel.logoFormat, width: theme.logoWidth),
        ],
      ),
    );
  }
}
