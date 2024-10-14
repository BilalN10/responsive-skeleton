import 'package:auto_route/auto_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:skeleton_kosmos/skeleton_kosmos.dart';

/// {@category Model}
class ApplicationDataModel<T extends UserModel> {
  /// Type de votre utilisateur (uniquement si vous avez ovveride '''UserModel'''), par défaut vous devez mettre '''UserModel'''.
  /// @Required
  final T userTypeProvider;

  /// Constructeur 'fromJson' de votre utilisateur (uniquement si vous avez ovveride '''UserModel'''), par défaut vous devez mettre '''UserModel.fomJson'''.
  /// @Required
  final T Function(Map<String, dynamic>) userConstructorProvider;

  /// Callback vous permettant d'initialiser différentes providers, widgets, models.. en meme temps que le chargement de la page et de l'utilisateur.
  /// @Nullable
  final Function(BuildContext context, WidgetRef ref)? dashboardInitialiser;

  final Widget Function(BuildContext context, WidgetRef ref)? subProfilBuilder;

  /// Callback vous permettant d'initialiser différentes providers, widgets, models.. dès que les données utilisateurs sont chargés.
  /// @Nullable
  final Function(BuildContext context, WidgetRef ref)? dashboardInitialiserWithUserData;

  /// Titre de l'application.
  /// @Required
  final String appTitle;

  /// Logo de l'application.
  /// @Required
  final String appLogo;

  /// Second logo de l'application.
  /// @Nullable
  final String? appLogoReverse;

  /// Format du / des logo(s).
  /// @Default : [SmartImageType.svg]
  final SmartImageType logoFormat;

  /// Email du contact de l'application.
  /// @Nullable
  final String? contactEmail;

  /// Numéro de téléphone du contact de l'application.
  /// @Nullable
  final String? contactPhone;

  /// Route principal de l'application
  /// @Required
  final PageRouteInfo mainRoute;

  /// Nom de la route principale de l'application
  /// @Required
  final String mainRouteName;

  /// Route par défaut des pages ne nécéssitant pas d'authentification (uniquement utilisé par [AppConfigModel.enableNoConnexion]).
  /// @Nullable
  final PageRouteInfo? noConnexionRoute;

  /// Nom de la route par défaut des pages ne nécéssitant pas d'authentification (uniquement utilisé par [AppConfigModel.enableNoConnexion]).
  /// @Nullable
  final String? noConnexionRouteName;

  /// Route du profil utilisateur.
  /// @Default: '"/dashboard/profile/settings"'
  final String profilRoute;

  /// Nom de la route du profil utilisateur.
  /// @Default: '"SettingsRoute"'
  final String profilRouteName;

  /// L'utilisateur a une page profil
  /// @Default: 'true
  final bool enableProfil;

  /// Lien de la page Facebook du projet.
  /// @Nullable
  final String? facebookUrl;

  /// Lien de la page Instagram du projet.
  /// @Nullable
  final String? instagramUrl;

  /// Lien de la page Twitter du projet.
  /// @Nullable
  final String? twitterUrl;

  /// Liste des langages supportés par l'application.
  /// /!\ Les langues doivent avoir leur fichier de traduction dans le dossier '''assets/translations/''' de l'application.
  /// @Default: const [Locale("fr", "FR")]
  final List<Locale> supportedLocales;

  /// Langue par défaut de l'application.
  /// @Default: const [Locale("fr", "FR")]
  final Locale defaultLocale;

  /// Largeur maximum pour l'UI téléphone.
  /// @Default: 538 (equal to LG G5, bigger phone)
  final double maxPhoneWidth;

  /// Largeur maximum pour l'UI tablette.
  /// @Default: 1024 (equal to Ipad Pro 12.9")
  final double maxTabletWidth;

  /// Largeur maximum pour l'UI ordinateur.
  /// @Default: 2400 (equal to Desktop)
  final double maxWebWidth;

  /// Taille maximum des UI de l'application.
  /// @Default: [double.infinity]
  final double maxWidth;

  /// Size du design de l'application (uniquement mobile).
  /// @Default: Size(375, 812) (equal to majority of Victor's design)
  final Size designSize;

  /// All data setup before Splash Screen fade out.
  final Future<T> Function<T>()? splashScreenPreserve;

  /// Fierbase est utilisé dans l'application.
  /// @Default: 'true'
  final bool firebaseIsEnabled;

  /// Firebase configuration.
  /// @Required (only for web)
  final FirebaseOptions? firebaseOptions;

  /// Nom de la collection ou sont stockés les données utilisateurs.
  /// @Default: "users"
  final String userCollectionPath;

  /// Si l'utilisateur doit forcement être connecté pour accéder à l'application.
  /// @Default: 'true'
  final bool forceUserConnection;

  /// Deconnect l'utilisateur à chaque restart (unqiuement en Debug).
  /// @default: 'false'
  final bool clearUserSessionOnDebugMode;

  /// Url des cloud functions.
  /// @Required (only if cloud functions is used)
  final String? firebaseFunctionsUri;

  /// Clé Stripe.
  /// @Required (only if stripe is used)
  final String? stripePublishableKey;

  /// Path de la cloud function pour l'api stripe.
  /// @Default: "/stripeApi"
  final String defaultApiPath;

  /// Path de la cloud function pour le Webhooks Stripe.
  /// @Default: "/stripeWebhooks"
  final String defaultWebhooksPath;

  /// Clé de l'api Google Maps.
  /// @Required (only if google maps is used)
  final String? gmapKey;

  /// ID de l'application sur algolia.
  /// @Required (only if algolia is used)
  final String? algoliaApplicationId;

  /// Clé de l'api Algolia.
  /// @Required (only if algolia is used)
  final String? algoliaKey;

  /// Durée de TimeOut pour les requêtes HTTP.
  /// @Default: Duration(seconds: 60)
  final Duration requestTimeout;

  /// Consiguration de l'interface du skeleton.
  /// @Default: const AppConfigModel()
  final AppConfigModel applicationConfig;

  final bool showEditImageProfil;
  final bool showUserImage;
  final bool showEmailInProfile;

  final Widget Function(BuildContext, WidgetRef)? profilButtonBuilder;
  final Function(BuildContext, WidgetRef)? logoutFunction;
  final Function(BuildContext, WidgetRef)? deleteAccountFunction;

  /// Contient les configurations de tous les packages Kosmos intégrés dans le skeleton.
  /// Voir plus dans [DependenciesConfiguration].
  final DependenciesConfiguration dependenciesConfiguration;

  const ApplicationDataModel({
    /// Application Data
    required this.userTypeProvider,
    required this.userConstructorProvider,
    this.dashboardInitialiser,
    this.subProfilBuilder,
    this.deleteAccountFunction,
    this.dashboardInitialiserWithUserData,
    required this.appLogo,
    required this.appTitle,
    required this.mainRoute,
    required this.mainRouteName,
    this.noConnexionRoute,
    this.noConnexionRouteName,
    this.logoutFunction,
    this.profilRoute = "/dashboard/profile/settings",
    this.profilRouteName = "SettingsRoute",
    this.enableProfil = true,
    this.showEditImageProfil = false,
    this.showUserImage = true,
    this.appLogoReverse,
    this.contactEmail,
    this.contactPhone,
    this.logoFormat = SmartImageType.svg,
    this.profilButtonBuilder,
    this.showEmailInProfile = true,

    /// Network
    this.facebookUrl,
    this.instagramUrl,
    this.twitterUrl,

    /// Translations
    this.supportedLocales = const [Locale("fr", "FR")],
    this.defaultLocale = const Locale("fr", "FR"),

    /// Responsive
    this.maxPhoneWidth = 800,
    this.maxTabletWidth = 1200,
    this.maxWebWidth = 2400,
    this.maxWidth = double.infinity,
    this.designSize = const Size(375, 812),

    /// Splash Screen
    this.splashScreenPreserve,

    /// Firebase
    this.firebaseIsEnabled = true,
    this.firebaseOptions,
    this.userCollectionPath = "users/",
    this.forceUserConnection = true,
    this.requestTimeout = const Duration(seconds: 60),
    this.clearUserSessionOnDebugMode = false,
    this.firebaseFunctionsUri,

    /// Stripe
    this.stripePublishableKey,
    this.defaultApiPath = "/stripeApi",
    this.defaultWebhooksPath = "/stripeWebhooks",

    /// Google maps
    this.gmapKey,

    /// Algolia
    this.algoliaApplicationId,
    this.algoliaKey,

    ///skeleton
    this.applicationConfig = const AppConfigModel(),
    this.dependenciesConfiguration = const DependenciesConfiguration(),
  })  : assert(appLogo.length > 0),
        assert(maxPhoneWidth <= maxTabletWidth),
        assert(maxTabletWidth <= maxWebWidth),
        assert(maxWebWidth <= maxWidth);
}
