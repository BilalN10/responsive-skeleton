import 'package:cloud_firestore/cloud_firestore.dart';

/// [UserModel] contient toutes les informations utilisateurs que les applications ont besoin par défaut.
/// Si vous avez besoin de plus de champs, vous pouvez créer votre propre model héritant de [UserModel] et l'importer dans votre projet.
///
/// {@category Model}
/// {@subCategory User}
class UserModel {
  final String? id;
  final String? email;
  final String? firstname;
  final String? lastname;
  final bool? enablePushNotification;
  final bool? enableEmailNotification;
  final String? fcmToken;
  final String? phone;
  final String? profilImage;
  final String? stripeId;
  final String? language;
  final bool? cguAccepted;
  final bool? profilCompleted;
  final bool? isFirstLogin;
  final String userType;

  ///Required for Tchat
  final String? pseudo;
  final DateTime createdAt;
  final DateTime lastSeen;

  ///Required for Position
  final GeoPoint? lastKnownPosition;
  final DateTime? lastKnownPositionUpdate;

  UserModel({
    this.id,
    this.email,
    this.firstname,
    this.lastname,
    this.enablePushNotification,
    this.enableEmailNotification,
    this.fcmToken,
    this.phone,
    this.profilImage,
    this.stripeId,
    this.language,
    this.cguAccepted,
    this.profilCompleted,
    this.isFirstLogin,
    this.userType = "default",
    this.pseudo,
    this.lastKnownPosition,
    this.lastKnownPositionUpdate,
    DateTime? createdAt,
    DateTime? lastSeen,
  }) : createdAt = createdAt ?? DateTime.now(),
        lastSeen = lastSeen ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      enablePushNotification: json["enablePushNotification"],
      enableEmailNotification: json["enableEmailNotification"],
      fcmToken: json["fcmToken"],
      phone: json["phone"],
      profilImage: json["profilImage"],
      stripeId: json["stripeId"],
      language: json["language"],
      cguAccepted: json["cugAccepted"],
      profilCompleted: json["profilCompleted"],
      isFirstLogin: json["isFirstLogin"],
      userType: json["userType"] ?? "default",
      pseudo: json["pseudo"],
      createdAt: (json["createdAt"] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastSeen: (json["lastSeen"] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastKnownPosition: json["lastKnownPosition"],
      lastKnownPositionUpdate: (json["lastKnownPositionUpdate"] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "firstname": firstname,
      "lastname": lastname,
      "enablePushNotification": enablePushNotification,
      "enableEmailNotification": enableEmailNotification,
      "fcmToken": fcmToken,
      "phone": phone,
      "profilImage": profilImage,
      "stripeId": stripeId,
      "language": language,
      "cguAccepted": cguAccepted,
      "profilCompleted": profilCompleted,
      "isFirstLogin": isFirstLogin,
      "userType": userType,
      "pseudo": pseudo,
      "createdAt": Timestamp.fromDate(createdAt),
      "lastSeen": Timestamp.fromDate(lastSeen),
      "lastKnownPosition": lastKnownPosition,
      "lastKnownPositionUpdate": lastKnownPositionUpdate != null ? Timestamp.fromDate(lastKnownPositionUpdate!) : null,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? firstname,
    String? lastname,
    bool? enablePushNotification,
    bool? enableEmailNotification,
    String? fcmToken,
    String? profilImage,
    String? phone,
    String? stripeId,
    String? language,
    bool? cguAccepted,
    bool? profilCompleted,
    bool? isFirstLogin,
    String? userType,
    String? pseudo,
    DateTime? createdAt,
    DateTime? lastSeen,
    GeoPoint? lastKnownPosition,
    DateTime? lastKnownPositionUpdate,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      enablePushNotification: enablePushNotification ?? this.enablePushNotification,
      enableEmailNotification: enableEmailNotification ?? this.enableEmailNotification,
      fcmToken: fcmToken ?? this.fcmToken,
      phone: phone ?? this.phone,
      profilImage: profilImage ?? this.profilImage,
      stripeId: stripeId ?? this.stripeId,
      language: language ?? this.language,
      cguAccepted: cguAccepted ?? this.cguAccepted,
      profilCompleted: profilCompleted ?? this.profilCompleted,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
      userType: userType ?? this.userType,
      pseudo: pseudo ?? this.pseudo,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      lastKnownPosition: lastKnownPosition ?? this.lastKnownPosition,
      lastKnownPositionUpdate: lastKnownPositionUpdate ?? this.lastKnownPositionUpdate,
    );
  }
}
