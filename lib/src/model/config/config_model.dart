import 'package:dartz/dartz.dart' as dz;
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:form_generator_kosmos/form_generator_kosmos.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onboarding_kosmos/onboarding_kosmos.dart';
import 'package:settings_kosmos/settings_kosmos.dart';
import 'package:skeleton_kosmos/src/services/authentication/model/auth_response.dart';
import 'package:skeleton_kosmos/src/widget/link_item/model.dart';

//TODO v3_3_1

/// Diffenret Positions of the [LinkItem] in the whole app.
enum NavigationPosition {
  /// In Web, this display on side bar, and in mobile / tablet / application is inside a drawer.
  sidebar,

  /// In Web, this display on top bar, and in mobile / tablet / application is inside a [bottomNavigationBar].
  appbar,

  /// Display inside [appbar] and [sidebar],
  all,
}

/// Different way to connect with default [LoginPage]
enum LoginType {
  email,
  id,
}

/// Contient les configurations nécessaires pour l'interface du skeleton.
///
/// {@category Model}
class AppConfigModel {
  /// Affichage d'une [appBar] pour une application web.
  /// @Default: 'true'
  final bool showAppBarOnWeb;

  /// Affichage d'une [appBar] pour une application mobile ou UI tablette / mobile.
  /// @Default: 'true'
  final bool showAppBarOnMobile;

  /// Builder permettant de générer une appBar pour les pages du dashboard en version application.
  /// @Nullable
  final PreferredSizeWidget Function(BuildContext, WidgetRef)? mobileAppBarBuilder;

  /// Builder permettant de générer une bottomBar pour les pages du dashboard en version application.
  /// @Nullable
  final Widget Function(BuildContext, WidgetRef)? mobileBottomBarBuilder;

  /// Affichage du logo (path défini dans [ApplicationModel]) dans l'appBar (uniquement si [showAppBarOnWeb] est 'true').
  /// @Default: 'true'
  final bool appBarHaveLogo;

  /// Affichage d'un [ProfilButton] dans l'appBar (uniquement si [showAppBarOnWeb] est 'true').
  /// @Default: 'true'
  final bool appBarHaveProfilButton;

  /// Affichage de l'image de profil dans le [ProfilButton] (uniquement si [showAppBarOnWeb] est 'true' et [appBarHaveProfilButton] est 'true').
  /// @Default: 'true'
  final bool profilButtonHavePicture;

  /// Affichage d'une [bottomBar] pour une application web.
  /// @Default: 'true'
  final bool showBottomBarOnWeb;

  /// Affichage du logo (path défini dans [ApplicationModel]) dans la bottomBar (uniquement si [showBottomBarOnWeb] est 'true' et [bottomBarUseReverseLogo] est 'false').
  /// @Default: 'true'
  final bool bottomBarHaveLogo;

  /// Affichage du second logo (path défini dans [ApplicationModel]) dans la bottomBar (uniquement si [showBottomBarOnWeb] est 'true').
  /// @Default: 'true'
  final bool bottomBarUseReverseLogo;

  /// Affichage d'une [sideBar] ou d'un [Drawer] pour une application web.
  /// @Default: 'true'
  final bool showSideBarOrDrawerOnWeb;

  /// Position des items de navigations dans la [AppBar] ou dans le [Drawer] (uniquement si [showSideBarOrDrawerOnWeb] est 'true') ou dans les deux.
  /// @Default: [NavigationPosition.sidebar]
  final NavigationPosition whereNavigationItem;

  /// Utilisation d'une [bottomNavigationBar] en tablette / mobile / application.
  /// @Default: 'true'
  final bool bottomNavigationBarInMobile;

  /// Items de navigation, la première string étant le type d'utilisateur pour qui les items sont définis.
  /// Si vous n'avez pas de gestion de type d'utilisateur, vous pouvez utiliser la valeur 'default'.
  /// @Default: []
  ///
  /// Example: [
  ///   Tuple2("default", [LinkItemModel(), ...]),
  ///   ...
  /// ]
  final List<dz.Tuple2<String, List<LinkItemModel>>> navigationItems;

  /// List des items de navigation qui sont affichés dans la [bottomNavigationBar] (uniquement si [bottomNavigationBarInMobile] est 'true').
  /// @Default: []
  final List<LinkItemModel> bottomNavItems;

  /// Affiche le logo de l'application dans les pages d'authentication.
  /// @Default: 'true'
  final bool logoOnAuthenticationPage;

  /// Create Account need email
  /// @Default: 'true'
  final bool createAccountNeedEmail;

  /// Create Account need Password
  /// @Default: 'true'
  final bool createAccountNeedPassword;

  /// Create Account need Phone
  /// @Default: 'true'
  final bool createAccountNeedPhone;

  /// Affiche le champs de saisie du numéro de téléphone dans les pages de création de compte.
  /// Utilisé uniquement si [createAccountNeedPhone] est 'false'.
  final bool showPhoneNumber;

  /// Content of CGU
  /// @Default: "Lorem Ipsum"
  final String cguContent;

  /// Permet de customiser la page de complétion de profil.
  /// @Nullable
  final Widget? completeProfilPopup;

  /// Type de connexion, par défaut [LoginType.email]
  final LoginType typeOfLogin;

  final Function(BuildContext, AuthResponse)? onLoginSuccess;
  final Widget Function(BuildContext, WidgetRef)? cguContentBuilder;

  /// Le mail de l'utilisateur doit être vérifier pour accéder au site.
  /// @Default: 'false'
  final bool emailMustBeVerified;

  /// La connexion par téléphone est disponible dans l'application
  /// @Default: 'false'
  final bool enableConnexionWithPhone;

  /// L'application possède une / des page(s) ne nécéssitant pas de rediection et un bouton pour y accéder est disponible sur la page de connexion.
  /// @Default: 'false'
  final bool enableNoConnexion;

  /// La création de compte est disponible dans l'application
  /// @Default: 'true'
  final bool enableCreateAccount;

  /// L'utilisateur peut réinitiliser son mot de passe.
  /// @Default: 'true'
  final bool enableForgotPassword;

  /// L'image de profil de l'utilisateur est visible dans la page settings.
  /// @Default: 'true'
  final bool showUserImageOnSettings;

  /// Les pages d'authentification possède une [AppBar].
  /// @Default: 'false'
  final bool appBarOnAuthenticationPage;

  /// Les pages d'authentification possède une [BottomBar].
  /// @Default: 'false'
  final bool bottomBarOnAuthenticationPage;

  /// Les applications mobiles ou en ui tablette / mobile possède un [ProfilButton] (uniquement si [showAppBarOnMobile] est 'true').
  final bool enableProfilButtonInPhone;

  /// List des settings disponibles dans la page settings.
  /// @Default: []
  final List<Tuple2<String, List<SettingsNode>>> settingsNodes;

  /// Callback lorsqu'on tape le [ProfilButton] (uniquement si [appBarHaveProfilButton] est 'true' ou [enableProfilButtonInPhone] est 'true').
  /// @Nullable
  final Function(BuildContext)? onTapProfilButton;

  @Deprecated(
      "Desormais configurable dans [DependenciesConfiguration] dependenciesConfig.\n/!\\ Cette configuration va disparaître d'ici en Version 4.0.0")
  final List<Widget Function(BuildContext, WidgetRef, PageController)>? permissonWidgets;

  @Deprecated(
      "Desormais configurable dans [DependenciesConfiguration] dependenciesConfig.\n/!\\ Cette configuration va disparaître d'ici en Version 4.0.0")
  final bool applicationNeedsPermission;

  @Deprecated("Non utilisé\n/!\\ Cette propriété sera supprimée dans la version 4.0.0")
  final List<FieldModel> loginFields;

  @Deprecated("Non utilisé\n/!\\ Cette propriété sera supprimée dans la version 4.0.0")
  final Widget? loginCustomPage;

  @Deprecated("Non utilisé\n/!\\ Cette propriété sera supprimée dans la version 4.0.0")
  final List<FieldModel> loginWithPhoneFields;

  const AppConfigModel({
    /// Config
    this.showAppBarOnWeb = true,
    this.cguContentBuilder,
    this.showBottomBarOnWeb = true,
    this.showAppBarOnMobile = true,
    this.mobileAppBarBuilder,
    this.mobileBottomBarBuilder,
    this.showSideBarOrDrawerOnWeb = true,
    this.appBarHaveLogo = true,
    this.profilButtonHavePicture = true,
    this.appBarHaveProfilButton = true,
    this.bottomBarHaveLogo = true,
    this.bottomBarUseReverseLogo = false,
    this.whereNavigationItem = NavigationPosition.sidebar,
    this.bottomNavigationBarInMobile = true,
    this.navigationItems = const [],
    this.bottomNavItems = const [],
    this.loginFields = const [],
    this.loginWithPhoneFields = const [],
    this.createAccountNeedEmail = true,
    this.showPhoneNumber = true,
    this.createAccountNeedPassword = true,
    this.createAccountNeedPhone = true,
    this.cguContent = "Lorem Ipsum",
    this.typeOfLogin = LoginType.email,
    this.emailMustBeVerified = false,
    this.enableConnexionWithPhone = false,
    this.enableCreateAccount = true,
    this.enableNoConnexion = false,
    this.enableForgotPassword = true,
    this.showUserImageOnSettings = true,
    this.settingsNodes = const [],
    this.completeProfilPopup,
    this.loginCustomPage,
    this.appBarOnAuthenticationPage = false,
    this.bottomBarOnAuthenticationPage = false,
    this.onTapProfilButton,
    this.enableProfilButtonInPhone = true,
    this.logoOnAuthenticationPage = true,
    this.onLoginSuccess,

    /// Permission Package
    this.applicationNeedsPermission = false,
    this.permissonWidgets,
  });
}

class DependenciesConfiguration {
  ///////// Onboarding Package /////////

  /// Application have OnBoarding
  /// @Default: 'false'
  final bool enableOnBoarding;

  /// List of OnBoarding pages
  /// @Default: []
  final List<OnboardingModel> onBoardingPages;

  /// Type of OnBoarding
  /// @Default: [OnBoardingType.center]
  final OnboardingType onboardingType;

  //////// Permission Package ////////

  /// Liste des pages de permissions pour lesquelles l'utilisateur doit autoriser l'application.
  /// @Default: []
  final List<Widget Function(BuildContext, WidgetRef, PageController)> permissonWidgets;

  /// L'application possède un ou des pages de permissions à afficher lors du premier lancement.
  /// @Default: 'false'
  final bool applicationNeedsPermission;

  final bool permissionNeedConnectedUser;

  /// Settings Package
  final SettingsDependenciesConfiguration settingsDependenciesConfig;

  const DependenciesConfiguration({
    /// Onboarding Package
    this.enableOnBoarding = false,
    this.onBoardingPages = const [],
    this.onboardingType = OnboardingType.center,

    /// Permission Package
    this.applicationNeedsPermission = false,
    this.permissonWidgets = const [],
    this.permissionNeedConnectedUser = true,

    /// Settings Package
    this.settingsDependenciesConfig = const SettingsDependenciesConfiguration(),
  });
}

class SettingsDependenciesConfiguration {
  /// Event lorsqu'on clique sur le bouton de changement d'image de profil.
  final Function(BuildContext)? onChangedProfilPictureFunction;
  final bool showEditedBy;

  const SettingsDependenciesConfiguration({
    /// Settings Package
    this.onChangedProfilPictureFunction,
    this.showEditedBy = false,
  });
}
