import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

class SwicthNotifEmail extends HookConsumerWidget {
  const SwicthNotifEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appModel = GetIt.instance<ApplicationDataModel>();

    return CupertinoSwitch(
      value: ref.watch(userChangeNotifierProvider).userData!.enableEmailNotification ?? false,
      onChanged: (val) async {
        await FirebaseFirestore.instance.collection(appModel.userCollectionPath).doc(FirebaseAuth.instance.currentUser!.uid).update({"enableEmailNotification": val});
      },
    );
  }
}

class SwicthNotifPush extends HookConsumerWidget {
  const SwicthNotifPush({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appModel = GetIt.instance<ApplicationDataModel>();

    return CupertinoSwitch(
      value: ref.watch(userChangeNotifierProvider).userData!.enablePushNotification ?? false,
      onChanged: (val) async {
        await FirebaseFirestore.instance.collection(appModel.userCollectionPath).doc(FirebaseAuth.instance.currentUser!.uid).update({"enablePushNotification": val});
      },
    );
  }
}

class SwicthNotifSms extends HookConsumerWidget {
  const SwicthNotifSms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appModel = GetIt.instance<ApplicationDataModel>();

    return CupertinoSwitch(
      value: ref.watch(userChangeNotifierProvider).userData!.enablePushNotification ?? false,
      onChanged: (val) async {
        await FirebaseFirestore.instance.collection(appModel.userCollectionPath).doc(FirebaseAuth.instance.currentUser!.uid).update({"enablePushNotification": val});
      },
    );
  }
}
