import 'package:core_kosmos/core_kosmos.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

/// Widget parent permettant un scrolling par défaut, à mettre avant votre page, pour gérer les différentes fonctionnalités de vote interface.
/// Va générer automatiquement la bottom bar et la sidebar.
///
/// {@category Widget}
/// {@category Page}
class ScrollingPage extends ConsumerWidget {
  final Widget child;
  final bool isExpanded;
  final bool useSidebarPadding;

  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool useSafeArea;

  const ScrollingPage({
    Key? key,
    required this.child,
    this.isExpanded = false,
    this.useSidebarPadding = false,
    this.safeAreaBottom = true,
    this.safeAreaTop = true,
    this.useSafeArea = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appModel = GetIt.instance<ApplicationDataModel>();
    final appTheme = GetIt.instance<AppTheme>();

    EdgeInsetsGeometry? dPadding = getResponsiveValue(
      context,
      defaultValue: loadThemeData(null, "skeleton_page_padding", () => EdgeInsets.zero),
      phone: loadThemeData(null, "skeleton_page_padding_phone", () => EdgeInsets.zero),
      tablet: loadThemeData(null, "skeleton_page_padding_tablet", () => EdgeInsets.zero),
    );

    execInCaseOfPlatfom(
      () {
        if (!appModel.applicationConfig.showSideBarOrDrawerOnWeb && useSidebarPadding && dPadding != null) {
          dPadding?.add(EdgeInsets.only(left: appTheme.fetchTheme<NavigationSidebarThemeData>("skeleton_sidebar")!.width));
        }
      },
      () => dPadding = appTheme.fetchTheme<EdgeInsetsGeometry>("skeleton_page_padding_phone"),
    );

    final c = Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          WebParentCore.buildLeftNavBar(context, ref),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      primary: false,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height -
                                  (appModel.applicationConfig.showAppBarOnWeb ? (GetIt.instance<AppTheme>().fetchTheme<ResponsiveAppBarThemeData>("skeleton_app_bar")?.height ?? 75) : 0) -
                                  (appModel.applicationConfig.showBottomBarOnWeb ? (GetIt.instance<AppTheme>().fetchTheme<ResponsiveAppBarThemeData>("skeleton_botttom_bar")?.height ?? 75) : 0) -
                                  getResponsiveValue(context,
                                      defaultValue: 0,
                                      tablet: appModel.applicationConfig.bottomNavigationBarInMobile
                                          ? (GetIt.instance<AppTheme>().fetchTheme<ResponsiveAppBarThemeData>("skeleton_app_bar")?.height ?? 75)
                                          : 0),
                              minWidth: isExpanded ? MediaQuery.of(context).size.width : 0,
                            ),
                            child: Padding(
                              padding: ResponsiveValue<EdgeInsetsGeometry>(
                                context,
                                defaultValue: dPadding ?? EdgeInsets.zero,
                                valueWhen: [
                                  Condition.smallerThan(name: TABLET, value: appTheme.fetchTheme<EdgeInsetsGeometry>("skeleton_page_padding_tablet")!),
                                  Condition.smallerThan(name: PHONE, value: appTheme.fetchTheme<EdgeInsetsGeometry>("skeleton_page_padding_phone")!),
                                ],
                              ).value!,
                              child: child,
                            ),
                          ),
                          if (appModel.applicationConfig.showBottomBarOnWeb) WebParentCore.buildBottomBar(context, ref),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: useSafeArea
          ? SafeArea(
              top: safeAreaTop,
              bottom: safeAreaBottom,
              child: c,
            )
          : c,
    );
  }
}
