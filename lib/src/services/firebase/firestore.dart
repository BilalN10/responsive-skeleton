// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

abstract class FirestoreUtils {
  static FutureOr<void> updateUserField(String fieldName, dynamic fieldData) async {
    await FirebaseFirestore.instance.collection(GetIt.instance<ApplicationDataModel>().userCollectionPath).doc(FirebaseAuth.instance.currentUser!.uid).update({fieldName: fieldData});
  }

  static FutureOr<void> updateUserDoc(Map<String, dynamic> userData) async {
    await FirebaseFirestore.instance.collection(GetIt.instance<ApplicationDataModel>().userCollectionPath).doc(FirebaseAuth.instance.currentUser!.uid).update(userData);
  }

  static FutureOr<void> updateUserDocWithId(String userId, Map<String, dynamic> userData) async {
    await FirebaseFirestore.instance.collection(GetIt.instance<ApplicationDataModel>().userCollectionPath).doc(userId).update(userData);
  }

  static FutureOr<void> updateDocument(String collectionPath, String documentPath, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection(collectionPath).doc(documentPath).update(data);
  }

  static FutureOr<void> getUserDocument(String userId) async {
    await FirebaseFirestore.instance.collection(GetIt.instance<ApplicationDataModel>().userCollectionPath).doc(userId).get();
  }

  static FutureOr<void> getDocument(String collectionPath, String documentPath) async {
    await FirebaseFirestore.instance.collection(collectionPath).doc(documentPath).get();
  }

  static FutureOr<QuerySnapshot<Map<String, dynamic>>> getCollection(String collectionPath) async {
    return await FirebaseFirestore.instance.collection(collectionPath).get();
  }

  static FutureOr<DocumentReference<Map<String, dynamic>>> getDocumentSnapshot(String collectionPath, String documentPath) async {
    return FirebaseFirestore.instance.collection(collectionPath).doc(documentPath);
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getSubCollection(DocumentReference<Object?> query, String collectionPath) async {
    return await query.collection(collectionPath).get();
  }

  static FutureOr<void> deleteDocument(String collectionPath, String documentPath) async {
    await FirebaseFirestore.instance.collection(collectionPath).doc(documentPath).delete();
  }

  static FutureOr<void> deleteCollection(String collectionPath) async {
    await FirebaseFirestore.instance.collection(collectionPath).get().then((value) => value.docs.forEach((doc) => doc.reference.delete()));
  }

  static FutureOr<void> deleteUserDocument(String userId) async {
    await FirebaseFirestore.instance.collection(GetIt.instance<ApplicationDataModel>().userCollectionPath).doc(userId).delete();
  }

  static FutureOr<void> deleteUserCollection() async {
    await FirebaseFirestore.instance.collection(GetIt.instance<ApplicationDataModel>().userCollectionPath).get().then((value) => value.docs.forEach((doc) => doc.reference.delete()));
  }

  static FutureOr<void> deleteUserCollectionWithId(String userId) async {
    await FirebaseFirestore.instance.collection(GetIt.instance<ApplicationDataModel>().userCollectionPath).doc(userId).delete();
  }

  static FutureOr<void> deleteUserCollectionWithIds(List<String> userIds) async {
    for (String userId in userIds) {
      await FirebaseFirestore.instance.collection(GetIt.instance<ApplicationDataModel>().userCollectionPath).doc(userId).delete();
    }
  }
}
