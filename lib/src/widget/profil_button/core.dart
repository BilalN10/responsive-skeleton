import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

/// Créer un button de profil contenant l'image de profil, le nom et le mail de l'utilisateur.
/// En version tablette / mobile ou application le nom et le mail ne sont pas affichés.
///
/// {@category Widget}
class ProfilButton extends ConsumerWidget {
  final String? title;
  final String? subtitle;
  final String? imagePath;

  const ProfilButton({
    this.title,
    this.subtitle,
    this.imagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appModel = GetIt.instance<ApplicationDataModel>();
    final appBarTheme = loadThemeData(null, "skeleton_app_bar", () => const ResponsiveAppBarThemeData())!;
    final profilButtonTheme = loadThemeData(null, "profil_button", () => const ProfilButtonThemeData())!;

    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          appModel.profilButtonBuilder != null
              ? appModel.profilButtonBuilder!(context, ref)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: profilButtonTheme.nameStyle,
                      ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: profilButtonTheme.emailStyle,
                      ),
                  ],
                ),
          if (appModel.applicationConfig.profilButtonHavePicture) ...[
            sw(10),
            Container(
              width: profilButtonTheme.imageSize,
              height: profilButtonTheme.imageSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(appBarTheme.height),
                color: appBarTheme.backgroundColor,
              ),
              clipBehavior: Clip.hardEdge,
              child: imagePath != null
                  ? CachedNetworkImage(
                      imageUrl: imagePath!,
                      errorWidget: (context, _, __) {
                        return Container(
                          width: profilButtonTheme.imageSize,
                          height: profilButtonTheme.imageSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(appBarTheme.height),
                            color: Colors.grey.shade200,
                          ),
                          child: Image.asset(
                            "assets/images/img_user_profil.png",
                            fit: BoxFit.fill,
                            package: "skeleton_kosmos",
                          ),
                        );
                      },
                      placeholder: (context, _) {
                        return Container(
                          width: profilButtonTheme.imageSize,
                          height: profilButtonTheme.imageSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(appBarTheme.height),
                            color: Colors.grey.shade200,
                          ),
                          child: Image.asset(
                            "assets/images/img_user_profil.png",
                            fit: BoxFit.fill,
                            package: "skeleton_kosmos",
                          ),
                        );
                      },
                    )
                  : Container(
                      width: profilButtonTheme.imageSize,
                      height: profilButtonTheme.imageSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(appBarTheme.height),
                        color: Colors.grey.shade200,
                      ),
                      child: Image.asset(
                        "assets/images/img_user_profil.png",
                        fit: BoxFit.fill,
                        package: "skeleton_kosmos",
                      ),
                    ),
            ),
          ],
        ],
      ),
      onTap: () {
        if (appModel.applicationConfig.onTapProfilButton != null) {
          appModel.applicationConfig.onTapProfilButton!(context);
        }
        if (appModel.enableProfil) AutoRouter.of(context).navigateNamed(appModel.profilRoute);
      },
    );
  }
}
