import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/core/pages/dashboard.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LinkItem extends ConsumerWidget {
  final LinkItemModel model;

  ///theme
  final LinkItemThemeData? theme;
  final String? themeName;

  final bool isSideBar;

  final bool showLabel;

  const LinkItem({
    Key? key,
    required this.model,
    this.theme,
    this.themeName,
    this.isSideBar = false,
    this.showLabel = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = loadThemeData(theme, themeName ?? "link_item_${enumToString(model.position)}", () => const LinkItemThemeData())!;
    final routeIsActive = (ref.watch(dashboardProvider).route ?? "") == model.routeName;
    final appModel = GetIt.instance<ApplicationDataModel>();

    return InkWell(
      onTap: () {
        if (!appModel.applicationConfig.bottomNavigationBarInMobile && (ref.read(dashboardProvider).key.currentState?.isDrawerOpen ?? false) && model.label != "logout") {
          Navigator.of(context).pop();
        }
        ref.read(dashboardProvider).updateRoute(model.routeName);
        AutoRouter.of(context).navigateNamed(model.route);
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (model.iconInactiveAndDefaultPath != null) ...[
            Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  routeIsActive && model.iconActivePath != null ? model.iconActivePath! : model.iconInactiveAndDefaultPath!,
                  width: themeData.iconWidth,
                ),
                if (model.havePastille != null && model.havePastille!.call(context, ref) == true) ...[
                  Positioned(
                    top: 0,
                    right: 8,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  )
                ],
              ],
            ),
            if (model.label != null) sw(themeData.spacing),
          ],
          if (model.label != null && showLabel) ...[
            if (isSideBar)
              Expanded(
                child: Text(
                  model.label!.tr(),
                  style: TextStyle(
                    color: routeIsActive ? themeData.colorActive : themeData.colorInactiveAndDefault,
                    fontSize: sp(themeData.fontSize),
                    fontWeight: themeData.fontWeight,
                  ),
                ),
              )
            else
              Text(
                model.label!.tr(),
                style: TextStyle(
                  color: routeIsActive ? themeData.colorActive : themeData.colorInactiveAndDefault,
                  fontSize: sp(themeData.fontSize),
                  fontWeight: themeData.fontWeight,
                ),
              ),
          ]
        ],
      ),
    );
  }
}
