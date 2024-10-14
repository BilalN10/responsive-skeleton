import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

abstract class LoggedController {
  static Future<void> setAsLogged(bool isLogged) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) throw Exception("User must be connected");

      await FirebaseFirestore.instance.collection(GetIt.I<ApplicationDataModel>().userCollectionPath).doc(FirebaseAuth.instance.currentUser!.uid).update({
        "isLogged": isLogged,
      });
    } catch (e) {
      printInDebug(e);
    }
  }
}
