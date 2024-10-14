import 'package:core_kosmos/core_package.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

/// Class helper to manage link handler
///
/// {@category Utils}
abstract class ItemLinkHelper {
  /// Récupère la liste des liens / items que l'utilisateur accès.
  static List<LinkItemModel> getListLinkItem(WidgetRef ref) {
    final String userType =
        FirebaseAuth.instance.currentUser != null && ref.read(userChangeNotifierProvider).userData != null ? ref.read(userChangeNotifierProvider).userData!.userType : "default";

    final itemNode = GetIt.instance<ApplicationDataModel>().applicationConfig.navigationItems.where((element) => element.value1 == userType);
    if (itemNode.isNotEmpty) {
      return itemNode.first.value2;
    }

    printInDebug("No item found. are you sure you are user type is good ?");

    return [];
  }
}
