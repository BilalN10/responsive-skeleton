import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

abstract class AuthFirestoreService {
  ///
  ///
  ///
  static Future<String?> createUserDoc(String uid, Map<String, dynamic> json) async {
    final collectionPath = GetIt.instance<ApplicationDataModel>().userCollectionPath;
    final doc = FirebaseFirestore.instance.collection(collectionPath).doc(uid);
    if ((await doc.get()).exists) return "Error-Already-Exist";
    await doc.set(json);
    return null;
  }

  ///
  ///
  ///
  static Future<String?> updateUserDoc(String uid, Map<String, dynamic> json) async {
    final collectionPath = GetIt.instance<ApplicationDataModel>().userCollectionPath;
    final doc = FirebaseFirestore.instance.collection(collectionPath).doc(uid);
    await doc.update(json);
    return null;
  }

  ///
  ///
  ///
  static Future<String?> updateUserField(String uid, String field, dynamic value) async {
    final collectionPath = GetIt.instance<ApplicationDataModel>().userCollectionPath;
    final doc = FirebaseFirestore.instance.collection(collectionPath).doc(uid);
    await doc.update({field: value});
    return null;
  }
}
