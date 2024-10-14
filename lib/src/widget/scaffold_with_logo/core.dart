import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/services/auto_route/core.dart';

/// Widget créant un scaffold avec le logo de l'application (path défini dans [ApplicationModel]).
/// Le logo est centré dans le cas d'une taille d'écran inférieur à une tablette ou dans une application mobile.
/// Sinon, il est par défaut positionner en [Alignment.topLeft]
///
/// {@category Widget}
class ScaffoldWithLogo extends ConsumerWidget {
  final bool showLogo;
  final Widget child;
  final Color? color;
  final VoidCallback? onBackButtonPressed;

  final bool showBackButton;

  final bool isChildCenter;

  const ScaffoldWithLogo({
    Key? key,
    required this.showLogo,
    required this.child,
    this.color,
    this.isChildCenter = true,
    this.showBackButton = true,
    this.onBackButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AuthenticationPageThemeData theme =
        loadThemeData(null, "authentication_page", () => const AuthenticationPageThemeData())!;
    final width = loadThemeData<double>(
        null,
        getResponsiveValue(context,
            defaultValue: "skeleton_icon_size_web_width", phone: "skeleton_icon_size_phone_width"),
        () => 40)!;
    final appModel = GetIt.instance<ApplicationDataModel>();

    return Scaffold(
      backgroundColor: color,
      bottomNavigationBar: (appModel.applicationConfig.bottomBarOnAuthenticationPage)
          ? WebParentCore.buildBottomBar(context, ref)
          : null,
      body: SafeArea(
        child: getResponsiveValue(context, defaultValue: true, tablet: false, phone: false)
            ? Padding(
                padding: getResponsiveValue(
                  context,
                  defaultValue: EdgeInsets.zero,
                  phone: loadThemeData(null, "skeleton_page_padding_phone", () => EdgeInsets.zero)!,
                  tablet: loadThemeData(null, "skeleton_page_padding_tablet", () => EdgeInsets.zero)!,
                ),
                child: Stack(
                  children: [
                    if (showLogo)
                      Positioned(
                        top: 10,
                        left: 30,
                        child: SizedBox(
                          width: width,
                          child: ImageWithSmartFormat(
                              type: appModel.logoFormat, path: appModel.appLogo, width: width, boxFit: BoxFit.fitWidth),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: isChildCenter
                          ? Center(child: SingleChildScrollView(child: child))
                          : SingleChildScrollView(child: child),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                primary: false,
                child: Column(
                  children: [
                    sh(10),
                    Stack(
                      children: [
                        Padding(
                          padding: getResponsiveValue(
                            context,
                            defaultValue: EdgeInsets.zero,
                            phone: loadThemeData(null, "skeleton_page_padding_phone", () => EdgeInsets.zero)!,
                            tablet: loadThemeData(null, "skeleton_page_padding_tablet", () => EdgeInsets.zero)!,
                          ),
                          child: Center(
                            child: showLogo
                                ? ImageWithSmartFormat(
                                    type: appModel.logoFormat, path: appModel.appLogo, width: formatWidth(width))
                                : const SizedBox(),
                          ),
                        ),
                        if (showBackButton)
                          Padding(
                            padding: theme.appBarPhonePadding ??
                                loadThemeData(null, "skeleton_page_padding_phone", () => EdgeInsets.zero)!,
                            child: execInCaseOfPlatfom(
                              () => const SizedBox(),
                              () => CTA.back(
                                height: 50,
                                onTap: () {
                                  if (onBackButtonPressed != null) {
                                    onBackButtonPressed!();
                                  } else {
                                    AutoRouter.of(context).navigate(GetIt.I<ApplicationDataModel>().mainRoute);
                                  }
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (showLogo) sh(30) else sh(12),
                    Padding(
                        padding: getResponsiveValue(
                          context,
                          defaultValue: EdgeInsets.zero,
                          phone: loadThemeData(null, "skeleton_page_padding_phone", () => EdgeInsets.zero)!,
                          tablet: loadThemeData(null, "skeleton_page_padding_tablet", () => EdgeInsets.zero)!,
                        ),
                        child: child),
                  ],
                ),
              ),
      ),
    );
  }

  /// Retourne le même widget mais avec le logo contenu dans une appBar.
  const factory ScaffoldWithLogo.withBar({
    required bool showLogo,
    required Widget child,
    bool? showBackButton,
    Color? color,
  }) = _WithBar;
}

class _WithBar extends ScaffoldWithLogo {
  const _WithBar({
    Key? key,
    required bool showLogo,
    required Widget child,
    Color? color,
    bool? showBackButton,
  }) : super(key: key, showLogo: showLogo, child: child, color: color, showBackButton: showBackButton ?? true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ResponsiveAppBar.blank(
        size: Size.fromHeight(
            loadThemeData<ResponsiveAppBarThemeData>(null, "skeleton_app_bar", () => const ResponsiveAppBarThemeData())!
                .height),
        ref: ref,
      ),
      bottomNavigationBar: (GetIt.instance<ApplicationDataModel>().applicationConfig.bottomBarOnAuthenticationPage)
          ? WebParentCore.buildBottomBar(context, ref)
          : null,
      backgroundColor: color,
      body: Padding(
        padding: getResponsiveValue(
          context,
          defaultValue: EdgeInsets.zero,
          phone: loadThemeData(null, "skeleton_page_padding_phone", () => EdgeInsets.zero)!,
          tablet: loadThemeData(null, "skeleton_page_padding_tablet", () => EdgeInsets.zero)!,
        ),
        child: child,
      ),
    );
  }
}
