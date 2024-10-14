/// How to add this package ?
///
/// ```yaml
/// skeleton_kosmos:
///   git:
///     url: https://gitlab+deploy-token-1159050:rz2ULXhKXbxtkPw6DxEa@gitlab.com/package16/responsive-skeleton-web.git
///     ref: main
/// ```
///
/// #Changelog:
///
/// ###v3_3_0
///
/// Kosmos package versionning:
///
///  - core_kosmos: main
///  - ui_kosmos_v4: v1_0_2
///  - form_generator_kosmos: v1_1_1
///
library skeleton_kosmos;

/// launcher
export 'package:skeleton_kosmos/src/core/launch_app.dart' show LaunchApplication;

/// Model
/// Application Model
export 'package:skeleton_kosmos/src/model/app_model.dart' show ApplicationDataModel;
export 'package:skeleton_kosmos/src/model/user/user_model.dart' show UserModel;
export 'package:skeleton_kosmos/src/model/config/config_model.dart';
export 'package:skeleton_kosmos/src/model/theme/authentication_theme.dart' show AuthenticationPageThemeData;
export "package:skeleton_kosmos/src/model/theme/settings_theme.dart";

/// Pages
export 'package:skeleton_kosmos/src/core/pages/dashboard.dart' show DashboardPage, userChangeNotifierProvider;
export 'package:skeleton_kosmos/src/core/pages/profil.dart' show ProfilePage;
export 'package:skeleton_kosmos/src/core/pages/profile/settings.dart' show SettingsPage;
export 'package:skeleton_kosmos/src/core/pages/profile/complete_profil.dart' show CompleteProfilPopup;
export 'package:skeleton_kosmos/src/core/pages/profile/responsive_settings.dart' show ResponsiveSettingsPage;
export 'package:skeleton_kosmos/src/core/pages/profile/node/switch_notif_email.dart' show SwicthNotifEmail, SwicthNotifPush, SwicthNotifSms;
export 'package:skeleton_kosmos/src/core/pages/authentication/login_page.dart' show LoginPage;
export 'package:skeleton_kosmos/src/core/pages/authentication/logout_page.dart' show LogoutPage;
export 'package:skeleton_kosmos/src/core/pages/authentication/login_with_phone_page.dart' show LoginWithPhonePage;
export 'package:skeleton_kosmos/src/core/pages/authentication/forgot_password_page.dart' show ForgotPasswordPage;
export 'package:skeleton_kosmos/src/core/pages/authentication/create_account_page.dart' show CreateAccountPage;
export 'package:skeleton_kosmos/src/core/pages/authentication/create_account/principal_data.dart' show PrincipalData;
export 'package:skeleton_kosmos/src/core/pages/authentication/create_account/cgvu_page.dart' show CgvuPage;
export 'package:skeleton_kosmos/src/core/pages/authentication/create_account/verification_email_send_page.dart' show VerificationEmailSendPage;
export 'package:skeleton_kosmos/src/core/pages/profile/node/modify_personnal_data.dart' show ModifyPersonnalDataNode;
export 'package:skeleton_kosmos/src/core/pages/profile/node/modify_password_data.dart' show ModifyPasswordDataNode;
export 'package:skeleton_kosmos/src/core/pages/profile/node/modify_email_data.dart' show ModifyEmailDataNode;
export 'package:skeleton_kosmos/src/core/pages/profile/settings_page/builder.dart';
export 'package:skeleton_kosmos/src/core/pages/onboarding/core_page.dart';
export 'package:skeleton_kosmos/src/core/pages/permission/permission_page.dart';

///Widget
export 'package:skeleton_kosmos/src/widget/appbar/theme.dart' show ResponsiveAppBarThemeData;
export 'package:skeleton_kosmos/src/widget/profil_button/theme.dart' show ProfilButtonThemeData;
export 'package:skeleton_kosmos/src/widget/profil_button/core.dart' show ProfilButton;
export 'package:skeleton_kosmos/src/widget/sidebar/theme.dart' show NavigationSidebarThemeData;
export 'package:skeleton_kosmos/src/widget/web_parent/core.dart' show WebParentCore, BasicWebParentPage;
export 'package:skeleton_kosmos/src/widget/web_parent/pages/clamping_page.dart' show ClampingPage;
export 'package:skeleton_kosmos/src/widget/web_parent/pages/scrolling_page.dart' show ScrollingPage;
export 'package:skeleton_kosmos/src/widget/link_item/core.dart' show LinkItem;
export 'package:skeleton_kosmos/src/widget/link_item/model.dart' show LinkItemModel;
export 'package:skeleton_kosmos/src/widget/link_item/theme.dart' show LinkItemThemeData;
export 'package:skeleton_kosmos/src/widget/scaffold_with_logo/core.dart' show ScaffoldWithLogo;
export 'package:skeleton_kosmos/src/widget/custom_card/core.dart' show CustomCard;
export 'package:skeleton_kosmos/src/widget/custom_card/theme.dart' show CustomCardThemeData;
export 'package:skeleton_kosmos/src/widget/img_with_smart_format/core.dart' show ImageWithSmartFormat;
export 'package:skeleton_kosmos/src/widget/img_with_smart_format/enum.dart' show SmartImageType;
export 'package:skeleton_kosmos/src/widget/appbar/core.dart' show ResponsiveAppBar;
export 'package:skeleton_kosmos/src/widget/appbar/theme.dart' show ResponsiveAppBarThemeData;
export 'package:skeleton_kosmos/src/widget/custom_expansion_box/expansion_container.dart' show OpenableContainer;
export 'package:skeleton_kosmos/src/widget/custom_expansion_box/custom_expansion_box.dart' show CustomExpansionPanelList;
export 'package:skeleton_kosmos/src/widget/custom_expansion_box/theme.dart' show CustomExpansionPanelListThemeData;
export 'package:skeleton_kosmos/src/widget/mobile_parent/pages/mobile_page_view.dart' show MobilePageView;
export 'package:skeleton_kosmos/src/widget/message_box/message_box.dart' show MessageBox;

/// Providers
export 'package:skeleton_kosmos/src/providers/dashboard_provider.dart' show DashboardProvider;
export 'package:skeleton_kosmos/src/providers/user_provider.dart' show UserProvider;
export 'package:skeleton_kosmos/src/providers/create_account_provider.dart' show CreateAccountProvider;

/// Guards
export 'package:skeleton_kosmos/src/guards/authentication/login_guard.dart' show LoginGuard;
export 'package:skeleton_kosmos/src/guards/authentication/already_logged.dart' show AlreadyLoggedGuard;
export 'package:skeleton_kosmos/src/guards/authentication/logout_guard.dart' show LogoutGuard;
export 'package:skeleton_kosmos/src/guards/onboarding_guard.dart' show OnboardingGuard;
export 'package:skeleton_kosmos/src/guards/permission_guard.dart' show PermissionGuard;


/// Services
export 'package:skeleton_kosmos/src/services/firebase/firestore.dart' show FirestoreUtils;
export 'package:skeleton_kosmos/src/services/google_maps/core.dart';
export 'package:skeleton_kosmos/src/services/google_maps/model/location/location_model.dart';
export 'package:skeleton_kosmos/src/services/shared_preferences/custom_shared_preferences.dart';

/// Misc
export 'package:skeleton_kosmos/src/misc/utils.dart' show ItemLinkHelper;

export 'package:ui_kosmos_v4/ui_kosmos_v4.dart';
export 'package:core_kosmos/core_kosmos.dart';
export 'package:settings_kosmos/settings_kosmos.dart';
export 'package:permissionrequest/permissons_package.dart';
export 'package:onboarding_kosmos/onboarding_kosmos.dart';