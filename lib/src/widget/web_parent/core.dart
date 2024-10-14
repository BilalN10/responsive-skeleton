import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/widget/link_item/model.dart';

/// Class contenant les différentes méthodes de création d'interface.
/// (Ex. buildBottomBar => bottomBar si active dans le model, buildLeftSideBar => sideBar, contenant les liens de navigation, si active dans le model)
///
/// {@category Widget}
/// {@subCategory page}
abstract class WebParentCore {
  static int checkAuthorizationsForBar() {
    final appModel = GetIt.instance<ApplicationDataModel>();
    int ret = 0;
    if (appModel.applicationConfig.showBottomBarOnWeb) ret += 1;
    if (appModel.applicationConfig.showAppBarOnWeb) ret += 1;
    return ret;
  }

  static Widget buildBottomBar(BuildContext context, WidgetRef ref) {
    final appModel = GetIt.instance<ApplicationDataModel>();

    if (ResponsiveValue<bool>(context, defaultValue: false, valueWhen: [const Condition.smallerThan(name: TABLET, value: true)]).value ?? false) return const SizedBox();

    final theme = loadThemeData(null, "skeleton_bottom_bar", () => const ResponsiveAppBarThemeData())!;

    return Container(
      height: theme.height,
      decoration: BoxDecoration(
        color: theme.gradient != null ? null : theme.backgroundColor,
        boxShadow: theme.shadow,
        gradient: theme.gradient,
      ),
      padding: theme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          appModel.applicationConfig.bottomBarHaveLogo
              ? appModel.applicationConfig.bottomBarUseReverseLogo && appModel.appLogoReverse != null
                  ? InkWell(
                      child: ImageWithSmartFormat(
                        path: appModel.appLogoReverse!,
                        width: theme.logoWidth,
                        type: appModel.logoFormat,
                      ),
                      onTap: () => AutoRouter.of(context).navigateNamed("/"),
                    )
                  : InkWell(
                      child: ImageWithSmartFormat(
                        path: appModel.appLogo,
                        width: theme.logoWidth,
                        type: appModel.logoFormat,
                      ),
                      onTap: () => AutoRouter.of(context).navigateNamed("/"),
                    )
              : const SizedBox(width: 1, height: 1),
          sw(30),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: theme.itemSpacing,
              runSpacing: theme.itemRunSpacing,
              children: appModel.applicationConfig.bottomNavItems.map((e) {
                return InkWell(
                  onTap: () {
                    if (e.route.isNotEmpty) {
                      AutoRouter.of(context).navigateNamed(e.route);
                    } else {
                      if (e.onTap != null) {
                        e.onTap!(context);
                      }
                    }
                  },
                  child: Text(
                    e.label!.tr(),
                    textAlign: TextAlign.center,
                    style: theme.itemStyle,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildLeftNavBar(BuildContext context, WidgetRef ref) {
    final appModel = GetIt.instance<ApplicationDataModel>();
    final theme = loadThemeData(null, "skeleton_sidebar", () => const NavigationSidebarThemeData())!;
    if (ResponsiveValue<bool>(context, defaultValue: false, valueWhen: [const Condition.smallerThan(name: TABLET, value: true)]).value ?? false) return const SizedBox();
    if (!appModel.applicationConfig.showSideBarOrDrawerOnWeb) return const SizedBox();

    final items = ItemLinkHelper.getListLinkItem(ref);

    return Container(
      width: theme.width,
      height: MediaQuery.of(context).size.height,
      padding: theme.padding,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        boxShadow: theme.shadow,
      ),
      child: Center(
        child: SingleChildScrollView(
          primary: false,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: theme.padding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: appModel.applicationConfig.whereNavigationItem == NavigationPosition.all || appModel.applicationConfig.whereNavigationItem == NavigationPosition.sidebar
                  ? items
                      .map((e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinkItem(model: e.copyWith(position: LinkItemPosition.sidebar), isSideBar: true),
                              e == items.last ? const SizedBox() : sh(theme.itemSpacing),
                            ],
                          ))
                      .toList()
                  : [],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget par défaut, permet d'instancier une page de largeur maximum et d'ajouter la sidebar (uniquement si [AppConfigModel.showSideBarOrDrawerOnWeb] est à true)
///
/// {@category Widget}
class BasicWebParentPage extends ConsumerWidget {
  final Widget child;
  final bool showBottomBar;

  const BasicWebParentPage({
    Key? key,
    required this.child,
    this.showBottomBar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appModel = GetIt.instance<ApplicationDataModel>();

    return execInCaseOfPlatfom(() {
      if (appModel.applicationConfig.showSideBarOrDrawerOnWeb) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: child),
            ],
          ),
        );
      }

      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: child,
      );
    }, () {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: child,
      );
    });
  }
}
