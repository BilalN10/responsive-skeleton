import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dartz/dartz.dart' as dz;
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

class ResponsiveSettingsPage extends ConsumerWidget {
  final String nodeTag;

  final appModel = GetIt.instance<ApplicationDataModel>();

  ResponsiveSettingsPage({
    Key? key,
    @PathParam("nodeTag") required this.nodeTag,
  }) : super(key: key);

  List<dz.Tuple2<String, List<SettingsNode>>> _checkUserData(WidgetRef ref) {
    List<dz.Tuple2<String, List<SettingsNode>>> ret = [];
    for (var section in appModel.applicationConfig.settingsNodes) {
      List<SettingsNode> nodes = [];
      for (final node in section.value2) {
        if (node.type == SettingsType.personnalData && node.data == null) {
          nodes.add(
            node.copyWith(
              data: SettingsData(
                title:
                    "${ref.watch(userChangeNotifierProvider).userData!.firstname != null ? ref.watch(userChangeNotifierProvider).userData!.firstname! : ""} ${ref.watch(userChangeNotifierProvider).userData!.lastname != null ? ref.watch(userChangeNotifierProvider).userData!.lastname! : ""}",
                subTitle: ref.watch(userChangeNotifierProvider).userData!.email ?? "",
                prefix: ref.watch(userChangeNotifierProvider).userData!.profilImage != null
                    ? CachedNetworkImage(
                        imageUrl: ref.watch(userChangeNotifierProvider).userData!.profilImage!,
                        fit: BoxFit.cover,
                        width: formatWidth(103),
                        height: formatWidth(103),
                        errorWidget: (context, _, __) {
                          return Container(
                            width: formatWidth(103),
                            height: formatWidth(103),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(formatWidth(103)),
                              color: Colors.grey.shade200,
                            ),
                            child: Image.asset(
                              "assets/images/img_user_profil.png",
                              package: "skeleton_kosmos",
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        placeholder: (context, _) {
                          return Container(
                            width: formatWidth(103),
                            height: formatWidth(103),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(formatWidth(103)),
                              color: Colors.grey.shade200,
                            ),
                            child: Image.asset(
                              "assets/images/img_user_profil.png",
                              package: "skeleton_kosmos",
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      )
                    : null,
              ),
            ),
          );
        } else {
          nodes.add(node);
        }
      }
      section = section.copyWith(value2: nodes);
      ret.add(section);
    }
    return ret;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = loadThemeData(null, "responsive_settings", () => const ResponsiveSettingsThemeData())!;
    final nodes = _checkUserData(ref);

    final Widget c = NodePage(nodeTag: nodeTag, nodes: nodes);

    return SafeArea(
      bottom: false,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sh(themeData.settingsVeriticalSpacing ?? 40),
              c,
              sh(12),
            ],
          ),
        ),
      ),
    );

    // return ScrollingPage(useSafeArea: true, child: c);
  }
}
